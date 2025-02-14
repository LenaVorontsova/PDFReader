//
//  Document.swift
//  PDFReader
//
//  Created by Елена Воронцова on 13.02.2025.
//

import Foundation
import RealmSwift

class Document: Object, Identifiable {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var filePath: String?
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var thumbnailData: Data?
    
    let pages: List<DocumentPage> = List<DocumentPage>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(name: String, pages: [DocumentPage]? = nil, filePath: String? = nil, thumbnailData: Data? = nil) {
        self.init()
        self.name = name
        if let pages = pages {
            self.pages.append(objectsIn: pages)
        }
        self.filePath = filePath
        self.thumbnailData = thumbnailData
    }
    
    var fileExtension: String {
        return URL(fileURLWithPath: filePath ?? "").pathExtension
    }
}
