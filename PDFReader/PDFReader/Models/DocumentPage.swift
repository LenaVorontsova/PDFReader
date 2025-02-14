//
//  DocumentPage.swift
//  PDFReader
//
//  Created by Елена Воронцова on 13.02.2025.
//

import Foundation
import RealmSwift

class DocumentPage: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var document: Document?
    @objc dynamic var pageIndex: Int = 0
    @objc dynamic var pageData: Data = Data()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(pageIndex: Int, pageData: Data) {
        self.init()
        self.pageIndex = pageIndex
        self.pageData = pageData
    }
}
