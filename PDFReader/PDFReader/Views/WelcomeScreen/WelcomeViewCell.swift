//
//  WelcomeViewCell.swift
//  PDFReader
//
//  Created by Елена Воронцова on 13.02.2025.
//

import SwiftUI

struct WelcomeViewCell: View {
    let title: String
    let imageName: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            
            Text(title)
        }
        .padding(.leading)
    }
}
