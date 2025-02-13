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
    var filePath: String
    var createdAt: Date
    var thumbnailData: Data?
    
    var fileExtension: String {
        URL(fileURLWithPath: filePath).pathExtension
    }
}
