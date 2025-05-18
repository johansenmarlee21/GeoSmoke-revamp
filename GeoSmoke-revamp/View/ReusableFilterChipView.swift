//
//  ReusableFilterChipView.swift
//  GeoSmoke-revamp
//
//  Created by Johansen Marlee on 16/05/25.
//

import Foundation
import SwiftUI

struct ReusableFilterChipView: View {
    let image: String
    let label: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 3){
            Image(systemName: image)
                .font(.caption)
            Text(label)
                .font(.caption)
                .fontWeight(.regular)
            Button(action: onRemove){
                Image(systemName: "xmark.circle")
                    .font(.footnote)
                    .padding(.leading, 5)
                    .foregroundColor(Color.splashGreen)
            }

        }
        .frame(height: 31)
        .padding(.horizontal, 10)
        .background(Color.greenFilter)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.splashGreen, lineWidth: 1.2)
        )
        
        
    }
}

#Preview {
    ReusableFilterChipView(image: "checkmark",label: "Test", onRemove: {})
}
