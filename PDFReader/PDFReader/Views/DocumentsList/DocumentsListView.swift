//
//  DocumentsListView.swift
//  PDFReader
//
//  Created by Елена Воронцова on 12.02.2025.
//

import SwiftUI
import PhotosUI

struct DocumentsListView: View {
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true
    @AppStorage("hasRequestedPhotoAccess") private var hasRequestedPhotoAccess = false
    
    @StateObject private var viewModel = DocumentsListViewModel()
    @State private var showImagePicker = false
    @State private var askDocumentName = false
    @State private var showPrivacyAlert = false
    
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
                                NavigationLink(destination: DocumentReaderView(document: document,
                                                                               viewModel: viewModel)) {
                                    DocumentsListViewCell(document: document)
                                        .environmentObject(viewModel)
                                }
                            }
                        }
                                  .padding(10)
                    }
                }
                
                Button {
                    requestPhotoLibraryAccess()
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
            .alert("Document Name",
                   isPresented: $askDocumentName) {
                TextField("New Document", text: $viewModel.documentName)
                
                Button("Save") {
                    viewModel.createDocument()
                }
                .disabled(viewModel.documentName.isEmpty)
            }
        }
        .alert(Text("You must allow access to the gallery"),
               isPresented: $showPrivacyAlert) {
            
        }
               .alert(isPresented: $viewModel.showSaveAlert) {
                   Alert(
                    title: Text(viewModel.saveSuccess ? "Success" : "Error"),
                    message: Text(viewModel.saveSuccess ? "PDF saved successfully!" : "Failed to save PDF."),
                    dismissButton: .default(Text("OK"))
                   )
               }
        .sheet(isPresented: $isFirstLaunch) {
            WelcomeView()
                .interactiveDismissDisabled()
        }
        .sheet(isPresented: $viewModel.showMergeSelection) {
            if let firstDocument = viewModel.selectedDocumentForMerge {
                DocumentSelectionView(
                    documents: viewModel.documents.filter { $0.id != firstDocument.id },
                    onSelect: { secondDocument in
                        viewModel.mergeDocuments(firstDocument: firstDocument,
                                                 secondDocument: secondDocument)
                    }
                )
            }
        }
    }
    
    private func requestPhotoLibraryAccess() {
        if !hasRequestedPhotoAccess {
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        showImagePicker = true
                        showPrivacyAlert = false
                        hasRequestedPhotoAccess = true
                    } else {
                        showImagePicker = false
                        showPrivacyAlert = true
                        hasRequestedPhotoAccess = false
                    }
                }
            }
        } else {
            showImagePicker = true
        }
    }

}

#Preview {
    DocumentsListView()
}
