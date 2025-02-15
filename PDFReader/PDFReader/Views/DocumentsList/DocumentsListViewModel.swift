//
//  DocumentsListViewModel.swift
//  PDFReader
//
//  Created by Елена Воронцова on 13.02.2025.
//

import SwiftUI
import PDFKit
import RealmSwift

class DocumentsListViewModel: ObservableObject {
    @Published var documents: [Document] = []
    @Published var selectedImages: [UIImage] = []
    @Published var documentName = "New Document"
    @Published var showDocumentReader = false
    @Published var createdDocument: Document? = nil
    @Published var isLoading = false
    @Published var selectedDocumentForMerge: Document? = nil
    @Published var showMergeSelection = false
    @Published var saveSuccess = false
    @Published var showSaveAlert = false
    
    init() {
        loadDocuments()
    }
    
    private func loadDocuments() {
        let realm = try! Realm()
        let storedDocuments = realm.objects(Document.self)
        self.documents = Array(storedDocuments)
    }
    
    func createDocument() {
        guard !selectedImages.isEmpty else { return }
        isLoading = true
        Task(priority: .high) { [weak self] in
            guard let self = self else { return }
            
            var pages: [DocumentPage] = []
            
            for (index, image) in self.selectedImages.enumerated() {
                guard let pageData = image.jpegData(compressionQuality: 0.65) else { return }
                let documentPage = DocumentPage(pageIndex: index, pageData: pageData)
                pages.append(documentPage)
            }
            let thumbnail = selectedImages.first
            let newDocument = Document(name: documentName, pages: pages, thumbnailData: thumbnail?.jpegData(compressionQuality: 0.7))
            
            await MainActor.run {
                self.selectedImages.removeAll()
                self.createdDocument = newDocument
                self.isLoading = false
                self.showDocumentReader = true
            }
        }
    }
    
    func saveDocumentToRealm(_ document: Document) {
        do {
            let realm = try! Realm()
            try realm.write {
                realm.add(document)
            }
        } catch {
            print("Error saving document to Realm: \(error)")
        }
        loadDocuments()
    }
    
    func createPDF(from document: Document, completion: @escaping (Bool) -> Void) {
        let pages = document.pages.sorted(by: { $0.pageIndex < $1.pageIndex })
        
        isLoading = true
        
        Task(priority: .high) { [weak self] in
            guard let self = self else { return }
            sleep(2)
            
            let pdfDocument = PDFDocument()
            for index in pages.indices {
                if let pageImage = UIImage(data: pages[index].pageData),
                   let pdfPage = PDFPage(image: pageImage) {
                    pdfDocument.insert(pdfPage, at: index)
                }
            }
            
            let pdfURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("pdf")
            let saveResult = pdfDocument.write(to: pdfURL)
            
            let newDocument = Document(name: document.name,
                                       pages: pages,
                                       filePath: "\(pdfURL.path)",
                                       thumbnailData: document.thumbnailData)
            
            await MainActor.run {
                self.isLoading = false
                self.saveDocumentToRealm(newDocument)
                completion(saveResult)
            }
        }
    }
    
    func deleteDocument(_ id: String) {
        documents = documents.filter { $0.id != id }
        
        Task(priority: .high) {
            await MainActor.run {
                let realm = try! Realm()
                
                if let documentToDelete = realm.object(ofType: Document.self, forPrimaryKey: id) {
                    try! realm.write {
                        if let filePath = documentToDelete.filePath {
                            let fileURL = URL(fileURLWithPath: filePath)
                            try? FileManager.default.removeItem(at: fileURL)
                        }
                        
                        realm.delete(documentToDelete)
                    }
                } else {
                    print("Document not found in Realm")
                }
            }
        }
    }
    
    func mergeDocuments(firstDocument: Document, secondDocument: Document) {
        var mergedPages: [DocumentPage] = []
        
        for (index, page) in firstDocument.pages.enumerated() {
            let documentPage = DocumentPage(pageIndex: index, pageData: page.pageData)
            mergedPages.append(documentPage)
        }
        
        for (index, page) in secondDocument.pages.enumerated() {
            let documentPage = DocumentPage(pageIndex: index, pageData: page.pageData)
            mergedPages.append(documentPage)
        }
        
        let mergedDocument = Document(
            name: "Merged Document",
            pages: Array(mergedPages),
            thumbnailData: firstDocument.thumbnailData ?? secondDocument.thumbnailData
        )
        
        createPDF(from: mergedDocument) { [weak self] success in
            guard let self = self else { return }
            self.saveSuccess = success
            showSaveAlert = true
        }
        
        selectedDocumentForMerge = nil
        showMergeSelection = false
    }
}
