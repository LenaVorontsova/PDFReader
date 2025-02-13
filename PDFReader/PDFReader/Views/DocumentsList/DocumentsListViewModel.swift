//
//  DocumentsListViewModel.swift
//  PDFReader
//
//  Created by Елена Воронцова on 13.02.2025.
//

import SwiftUI

class DocumentsListViewModel: ObservableObject {
    @Published var documents: [Document] = []
    
    init() {
        loadMockData()
    }
    
    private func loadMockData() {
        let mockDocuments = [
            Document(name: "Sample 1 Sample 1", filePath: "/path/to/sample1.pdf", createdAt: Date(), thumbnailData: nil),
            Document(name: "Sample 2", filePath: "/path/to/sample2.pdf", createdAt: Date(), thumbnailData: nil),
            Document(name: "Sample 3", filePath: "/path/to/sample3.pdf", createdAt: Date(), thumbnailData: nil),
            Document(name: "Sample 4", filePath: "/path/to/sample4.pdf", createdAt: Date(), thumbnailData: nil),
            Document(name: "Sample 5", filePath: "/path/to/sample5.pdf", createdAt: Date(), thumbnailData: nil),
            Document(name: "Sample 6", filePath: "/path/to/sample6.pdf", createdAt: Date(), thumbnailData: nil)
        ]
        documents = mockDocuments
    }
}
