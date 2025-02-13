//
//  Formatter.swift
//  PDFReader
//
//  Created by Елена Воронцова on 13.02.2025.
//

import Foundation

struct Formatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
}
