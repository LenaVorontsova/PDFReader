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
    @State private var showShareSheet = false
    @State private var showShareErrorAlert = false
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
                    if let filePath = document.filePath {
                        let fileURL = URL(fileURLWithPath: filePath)
                        if FileManager.default.fileExists(atPath: fileURL.path) {
                            showShareSheet = true
                            showShareErrorAlert = false
                        } else {
                            showShareErrorAlert = true
                            print("PDF file not found at path: \(filePath)")
                        }
                    } else {
                        showShareErrorAlert = true
                        print("File path is nil")
                    }
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title3)
                        .foregroundStyle(.white)
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.createPDF(from: document) { success in
                        saveSuccess = success
                        showSaveAlert = true
                    }
                }) {
                    Text("Save")
                }
                .alert(isPresented: $showSaveAlert) {
                    Alert(
                        title: Text(saveSuccess ? "Success" : "Error"),
                        message: Text(saveSuccess ? "PDF saved successfully!" : "Failed to save PDF."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
        .alert(isPresented: $showShareErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text("Failed to share the file."),
                dismissButton: .default(Text("OK"))
            )
        }
        .sheet(isPresented: $showShareSheet) {
            let fileURL = URL(fileURLWithPath: document.filePath ?? "")
            ActivityView(activityItems: [fileURL])
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
