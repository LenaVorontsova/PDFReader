//
//  DocumentSelectionView.swift
//  PDFReader
//
//  Created by Елена Воронцова on 14.02.2025.
//

import SwiftUI

struct DocumentSelectionView: View {
    let documents: [Document]
    let onSelect: (Document) -> Void

    var body: some View {
        List(documents) { document in
            Button(action: {
                onSelect(document)
            }) {
                HStack {
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
                        .font(.title2)
                        .foregroundStyle(.black)
                    
                    Spacer()
                }
            }
        }
        .navigationTitle("Select Document to Merge")
    }
}
