//
//  PegView.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 25.12.2025.
//

import SwiftData
import SwiftUI

struct PegView: SettingsAwareView {
    // MARK: Data In
    let peg: Peg
    let match: Code.Match?
    @Query var settingsFetchResult: [Settings]
    
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

#Preview(traits: .swiftData) {
    PegView(peg: "A", match: .inexact)
}
