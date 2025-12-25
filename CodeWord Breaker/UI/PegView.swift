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
        Circle()
            .stroke(match.color, lineWidth: 3)
            .overlay { Text(peg).flexibleSystemFont() }
    }
}

extension Match? {
    var color: Color {
        switch self {
        case .nomatch:
            .red
        case .exact:
            .green
        case .inexact:
            .yellow
        case .none:
            .clear
        }
    }
}

#Preview {
    PegView(peg: "A", match: .inexact)
        .padding()
}
