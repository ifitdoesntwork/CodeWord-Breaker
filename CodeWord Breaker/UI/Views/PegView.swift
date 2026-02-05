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
    let match: Code.Match?
    @Environment(\.settings) private var settings
    
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
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .strokeBorder(lineWidth: Constants.lineWidth)
        case .circular:
            Circle()
                .strokeBorder(lineWidth: Constants.lineWidth)
        case .empty:
            Color.clear
        }
    }
    
    struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
    }
}

#Preview {
    ForEach(PegShape.allCases, id: \.self) { shape in
        PegView(peg: "A", match: .inexact)
            .environment(\.settings.pegShape, shape)
            .padding()
    }
}
