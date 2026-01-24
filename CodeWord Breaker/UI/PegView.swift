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
                    .flatMap { settings.matchColors[decodedFor: $0] }
                ?? (
                    peg.isEmpty ? .clear : .primary
                )
            )
    }
}

enum PegShape: CaseIterable, Codable {
    case rectangular
    case circular
    case empty
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .rectangular:
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(lineWidth: 2)
        case .circular:
            Circle()
                .strokeBorder(lineWidth: 2)
        case .empty:
            Color.clear
        }
    }
}

#Preview {
    ForEach(PegShape.allCases, id: \.self) { shape in
        PegView(peg: "A", match: .inexact)
            .environment(\.settings.pegShape, shape)
            .padding()
    }
}
