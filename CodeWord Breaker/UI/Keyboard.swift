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
    
    // MARK: Data In Function
    var match: (Peg) -> Match?
    
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
                ForEach(["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"], id: \.self) { row in
                    HStack(spacing: .zero) {
                        ForEach(row.map(String.init), id: \.self) { key in
                            view(for: key)
                        }
                    }
                }
            }
            .aspectRatio(10/3, contentMode: .fit)
            
            ancillaries
        }
        .aspectRatio(11/3, contentMode: .fit)
    }
    
    func view(for key: Peg) -> some View {
        Color.clear
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                Button {
                    actions.onChoose?(key)
                } label: {
                    Text(key)
                        .flexibleSystemFont()
                        .foregroundStyle(match(key).color)
                }
            }
    }
    
    var ancillaries: some View {
        VStack {
            Button("⌫", action: actions.onBackspace)
                .flexibleSystemFont()
            Spacer()
            Button("↩︎", action: actions.onReturn)
                .disabled(!canReturn)
                .flexibleSystemFont()
        }
        .aspectRatio(1/3, contentMode: .fit)
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
