//
//  Keyboard.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 25.12.2025.
//

import SwiftUI

struct Keyboard: View {
    // MARK: Data In
    let canReturn: Bool
    @Environment(\.settings) private var settings
    
    // MARK: Data In Function
    var match: (Peg) -> Code.Match?
    
    // MARK: Data Out Functions
    var actions: (
        onChoose: ((Peg) -> Void)?,
        onBackspace: () -> Void,
        onReturn: () -> Void
    )

    // MARK: - Body
    
    var body: some View {
        HStack {
            VStack(spacing: .zero) {
                ForEach(Constants.rows, id: \.self) { row in
                    HStack(spacing: .zero) {
                        ForEach(row.map(String.init), id: \.self) { key in
                            view(for: key)
                        }
                    }
                }
            }
            .aspectRatio(Self.keysAspectRatio, contentMode: .fit)
            
            ancillaries
        }
        .aspectRatio(Self.aspectRatio, contentMode: .fit)
    }
    
    static var aspectRatio: CGFloat {
        CGFloat((Constants.rows.map(\.count).max() ?? .zero) + 1)
        / CGFloat(Constants.rows.count)
    }
    
    private static var keysAspectRatio: CGFloat {
        CGFloat(Constants.rows.map(\.count).max() ?? .zero)
        / CGFloat(Constants.rows.count)
    }
    
    private func view(for key: Peg) -> some View {
        Color.clear
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                Button {
                    actions.onChoose?(key)
                } label: {
                    Text(key)
                        .flexibleSystemFont()
                        .foregroundStyle(
                            match(key)
                                .map { settings.matchColors[decodedFor: $0] }
                            ?? .accentColor
                        )
                }
            }
    }
    
    private var ancillaries: some View {
        VStack {
            Button("⌫", action: actions.onBackspace)
                .flexibleSystemFont()
            Spacer()
            Button("↩︎", action: actions.onReturn)
                .disabled(!canReturn)
                .flexibleSystemFont()
        }
        .aspectRatio(1 / 3, contentMode: .fit)
    }
    
    fileprivate struct Constants {
        static let rows = ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"]
    }
}

#Preview {
    Keyboard(
        canReturn: true,
        match: { _ in nil },
        actions: (
            onChoose: { key in
                print("chose \(key)")
            },
            onBackspace: {},
            onReturn: {}
        )
    )
    .padding()
}
