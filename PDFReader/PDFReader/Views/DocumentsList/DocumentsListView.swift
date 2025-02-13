//
//  DocumentsListView.swift
//  PDFReader
//
//  Created by Елена Воронцова on 12.02.2025.
//

import SwiftUI

struct DocumentsListView: View {
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true
    
    @StateObject private var viewModel = DocumentsListViewModel()
    @State private var showImagePicker = false
    @State private var askDocumentName: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.documents.isEmpty {
                    Spacer()
                    
                    Text("Documents list is empty")
                        .font(.title3)
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 115, maximum: 115)), count: 3),
                                  spacing: 10) {
                            ForEach(viewModel.documents) { document in
                                NavigationLink(destination: DocumentReaderView(document: document, viewModel: viewModel)) {
                                    DocumentsListViewCell(document: document)
                                }
                            }
                        }
                                  .padding(10)
                    }
                }
                
                Button {
                    showImagePicker.toggle()
                } label: {
                    Text("Generate PDF")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(width: 260, height: 50)
                        .foregroundStyle(.white)
                        .background(Color("darkGreen"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                }
                .padding(.bottom, 25)
            }
            .navigationTitle("Documents")
            .sheet(isPresented: $showImagePicker) {
                ImagePicker {
                    showImagePicker = false
                    viewModel.showDocumentReader = false
                } didFinish: { images in
                    showImagePicker = false
                    viewModel.selectedImages = images
                    askDocumentName = true
                }
            }
            .background {
                if let createdDocument = viewModel.createdDocument {
                    NavigationLink(
                        destination: DocumentReaderView(document: createdDocument, viewModel: viewModel),
                        isActive: $viewModel.showDocumentReader
                    ) {
                        EmptyView()
                    }
                }
            }
            .alert("Document Name", isPresented: $askDocumentName) {
                TextField("New Document", text: $viewModel.documentName)
                
                Button("Save") {
                    viewModel.createDocument()
                }
                .disabled(viewModel.documentName.isEmpty)
            }
        }
        .sheet(isPresented: $isFirstLaunch) {
            WelcomeView()
                .interactiveDismissDisabled()
        }
    }
}

#Preview {
    DocumentsListView()
}
