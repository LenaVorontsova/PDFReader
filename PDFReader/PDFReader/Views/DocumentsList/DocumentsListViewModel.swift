//
//  DocumentsListViewModel.swift
//  PDFReader
//
//  Created by Елена Воронцова on 13.02.2025.
//

import SwiftUI

class DocumentsListViewModel: ObservableObject {
    @Published var documents: [Document] = []
    @Published var selectedImages: [UIImage] = []
    @State var documentName: String = "New Document"
    
    init() {
        loadMockData()
    }
    
    private func loadMockData() {
    }
    
    func createDocument() {
        guard !selectedImages.isEmpty else { return }
        
        Task.detached(priority: .high) { [documentName] in
            var pages: [DocumentPage] = []
            
            for (index, image) in self.selectedImages.enumerated() {
                guard let pageData = image.jpegData(compressionQuality: 0.65) else { return }
                let documentPage = DocumentPage(pageIndex: index, pageData: pageData)
                pages.append(documentPage)
            }
            let newDocument = Document(name: documentName, pages: pages)
            
            await MainActor.run {
                self.documents.append(newDocument)
                self.documentName = documentName
            }
        }
    }
}
