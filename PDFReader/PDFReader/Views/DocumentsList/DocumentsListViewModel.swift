//
//  DocumentsListViewModel.swift
//  PDFReader
//
//  Created by Елена Воронцова on 13.02.2025.
//

import SwiftUI
import PDFKit

class DocumentsListViewModel: ObservableObject {
    @Published var documents: [Document] = []
    @Published var selectedImages: [UIImage] = []
    @Published var documentName: String = "New Document"
    @Published var showDocumentReader = false
    @Published var createdDocument: Document? = nil
    @Published var isLoading: Bool = false
    
    init() {
        loadMockData()
    }
    
    private func loadMockData() {
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
            let newDocument = Document(name: documentName, pages: pages)
            
            await MainActor.run {
                self.selectedImages.removeAll()
                self.documents.append(newDocument)
                self.documentName = documentName
                self.createdDocument = newDocument
                self.isLoading = false
                self.showDocumentReader = true
            }
        }
    }
    
    func createPDF(from document: Document, completion: @escaping (Bool) -> Void) {
        guard let pages = document.pages?.sorted(by: { $0.pageIndex < $1.pageIndex}) else {
            completion(false)
            return
        }
        
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
            var pdfURL = FileManager.default.temporaryDirectory
            let fileName = "\(document.name).pdf"
            pdfURL = pdfURL.appendingPathComponent(fileName)
            
            let saveResult = pdfDocument.write(to: pdfURL)
            await MainActor.run {
                self.isLoading = false
                completion(saveResult)
            }
        }
    }
}
