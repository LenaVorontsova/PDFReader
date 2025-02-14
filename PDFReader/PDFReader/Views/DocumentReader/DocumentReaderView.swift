//
//  DocumentReaderView.swift
//  PDFReader
//
//  Created by Елена Воронцова on 13.02.2025.
//

import SwiftUI

struct DocumentReaderView: View {
    @State var document: Document
    @State var viewModel: DocumentsListViewModel
    @State private var currentPageIndex: Int = 0
    @State private var showSaveAlert = false
    @State private var saveSuccess = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        let pages = document.pages.sorted(by: { $0.pageIndex < $1.pageIndex})
        VStack {
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
            
            Spacer()
            
            HStack {
                Button {
                    viewModel.createPDF(from: document) { success in
                        saveSuccess = success
                        showSaveAlert = true
                    }
                } label: {
                    VStack {
                        Image(systemName: "square.and.arrow.down")
                            .font(.title3)
                            .tint(Color.darkGreen)
                        
                        Text("Generate PDF file \nand save")
                            .font(.footnote)
                            .foregroundStyle(Color.darkGreen)
                    }
                }
                .alert(isPresented: $showSaveAlert) {
                    Alert(
                        title: Text(saveSuccess ? "Success" : "Error"),
                        message: Text(saveSuccess ? "PDF saved successfully!" : "Failed to save PDF."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
                Spacer()
                
                Button {
                    deletePage()
                } label: {
                    Image(systemName: "trash.fill")
                        .font(.title3)
                        .foregroundStyle(.red)
                }
            }
            .padding([.horizontal, .bottom], 15)
        }
    }
    
    private func deletePage() {
        document.pages.remove(at: currentPageIndex)
        
        if currentPageIndex == currentPageIndex {
            currentPageIndex = max(0, currentPageIndex - 1 )
        }
        if document.pages.isEmpty == true {
            presentationMode.wrappedValue.dismiss()
        } else {
//            viewModel.saveDocumentToRealm(document)
        }
    }
}

#Preview {
    DocumentReaderView(document: Document(name: ""), viewModel: DocumentsListViewModel())
}
