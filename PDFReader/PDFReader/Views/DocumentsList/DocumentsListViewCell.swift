//
//  DocumentsListViewCell.swift
//  PDFReader
//
//  Created by Елена Воронцова on 13.02.2025.
//

import SwiftUI

struct DocumentsListViewCell: View {
    let document: Document
    
    var body: some View {
        VStack {
            if let thumbnailData = document.thumbnailData,
               let uiImage = UIImage(data: thumbnailData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 50, maxHeight: 50)
            } else {
                Image("PDFIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
            }
            
            Text(document.name)
                .font(.headline)
                .foregroundStyle(.black)
                .lineLimit(1)
                .multilineTextAlignment(.center)
            
            Text(".\(document.fileExtension)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(Formatter.dateFormatter.string(from: document.createdAt))
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 3))
        .contextMenu {
            Button(action: {
            }) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
            
            Button(role: .destructive, action: {
            }) {
                Label("Delete", systemImage: "trash")
            }
            
            Button(action: {
            }) {
                Label("Merge", systemImage: "doc.on.doc")
            }
        }
    }
}
