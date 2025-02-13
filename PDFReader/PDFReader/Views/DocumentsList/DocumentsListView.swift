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
                                DocumentsListViewCell(document: document)
                            }
                        }
                                  .padding(10)
                    }
                }
                Button {
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
            .background(.white)
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
