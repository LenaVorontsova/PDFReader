//
//  WelcomeView.swift
//  PDFReader
//
//  Created by Елена Воронцова on 13.02.2025.
//

import SwiftUI

struct WelcomeView: View {
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    
    var body: some View {
        ZStack {
            Color("lightGreen")
                .ignoresSafeArea()
            VStack {
                Text("Welcome to \nPDFReader")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .padding(.top, 50)
                    .padding(.bottom, 50)
                
                VStack(alignment: .leading, spacing: 25) {
                    WelcomeViewCell(title: "Generate PDF file",
                                    imageName: "PDFIcon")
                    
                    WelcomeViewCell(title: "Edit and save PDF file",
                                    imageName: "editFile")
                    
                    WelcomeViewCell(title: "Share PDF file",
                                    imageName: "shareFile")
                }
                .padding(.horizontal, 10)
                
                Spacer()
                
                Button {
                    isFirstLaunch = false
                    
                } label: {
                    Text("Start")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(width: 260, height: 50)
                        .foregroundStyle(.white)
                        .background(Color("darkGreen"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                }
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    WelcomeView()
}
