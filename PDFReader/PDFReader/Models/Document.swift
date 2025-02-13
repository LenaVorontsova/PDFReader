//
//  Document.swift
//  PDFReader
//
//  Created by Елена Воронцова on 13.02.2025.
//

import Foundation

struct Document: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var filePath: String?
    var createdAt: Date = Date()
    var thumbnailData: Data?
    var pages: [DocumentPage]?
    
    var fileExtension: String {
        URL(fileURLWithPath: filePath ?? "").pathExtension
    }
    
    init(name: String, pages: [DocumentPage]? = nil) {
        self.name = name
        self.pages = pages
    }
    
    mutating func setPages(_ pagesArray: [DocumentPage]) {
        pages = pagesArray
    }
}
