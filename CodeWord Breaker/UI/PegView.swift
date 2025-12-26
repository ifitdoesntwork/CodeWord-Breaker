//
//  PegView.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 25.12.2025.
//

import SwiftUI

struct PegView: View {
    // MARK: Data In
    let peg: Peg
    let match: Match?
    
    // MARK: - Body
    
    var body: some View {
        Color.clear
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                Text(peg)
                    .flexibleSystemFont()
                    .foregroundStyle(match.color)
            }
    }
}

#Preview {
    PegView(peg: "A", match: .inexact)
        .padding()
}
