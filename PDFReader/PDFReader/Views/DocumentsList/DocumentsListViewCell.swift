//
//  DocumentsListViewCell.swift
//  PDFReader
//
//  Created by Елена Воронцова on 13.02.2025.
//

import SwiftUI
import RealmSwift

struct DocumentsListViewCell: View {
    @ObservedRealmObject var document: Document
    @EnvironmentObject var viewModel: DocumentsListViewModel
    @State private var showShareSheet = false
    @State private var showShareErrorAlert = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            if let thumbnailData = document.thumbnailData,
               let uiImage = UIImage(data: thumbnailData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxHeight: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            } else {
                Image("PDFIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)
                    .padding()
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
        .frame(width: 115, height: 155)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 3))
        .contextMenu {
            Button(action: {
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
            }) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
            
            Button(role: .destructive, action: {
                dismiss()
                viewModel.deleteDocument(document.id)
            }) {
                Label("Delete", systemImage: "trash")
            }
            
            Button(action: {
                viewModel.selectedDocumentForMerge = document
                viewModel.showMergeSelection = true
            }) {
                Label("Merge", systemImage: "doc.on.doc")
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
}
