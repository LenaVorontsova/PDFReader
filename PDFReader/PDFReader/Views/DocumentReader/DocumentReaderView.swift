//
//  DocumentReaderView.swift
//  PDFReader
//
//  Created by Елена Воронцова on 13.02.2025.
//

import SwiftUI

struct DocumentReaderView: View {
    @State var document: Document
    @State private var currentPageIndex: Int = 0
    
    var body: some View {
        if let pages = document.pages?.sorted(by: { $0.pageIndex < $1.pageIndex}) {
            VStack(spacing: 10) {
                TabView(selection: $currentPageIndex) {
                    ForEach(pages.indices, id: \.self) {index in
                        let page = pages[index]
                        if let image = UIImage(data: page.pageData) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .tag(index)
                        }
                    }
                }
                .tabViewStyle(.page)
            }
        }
    }
}

#Preview {
    DocumentReaderView(document: Document(name: ""))
}
