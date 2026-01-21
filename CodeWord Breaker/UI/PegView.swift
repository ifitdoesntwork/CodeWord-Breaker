//
//  PegView.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 25.12.2025.
//

import SwiftUI

enum PegShape: CaseIterable {
    case rectangular
    case circular
    case empty
}

struct PegView: View {
    // MARK: Data In
    let peg: Peg
    let match: Match?
    @Environment(\.settings) var settings
    
    // MARK: - Body
    
    var body: some View {
        settings.pegShape.view
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                Text(peg)
                    .flexibleSystemFont()
            }
            .foregroundStyle(
                match
                    .flatMap { settings.colors[$0] }
                ?? (
                    peg.isEmpty ? .clear : .primary
                )
            )
    }
}

#Preview {
    ForEach(PegShape.allCases, id: \.self) { shape in
        PegView(peg: "A", match: .inexact)
            .environment(\.settings.pegShape, shape)
            .padding()
    }
}
