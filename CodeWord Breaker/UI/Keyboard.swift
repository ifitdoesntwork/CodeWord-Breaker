//
//  Keyboard.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 25.12.2025.
//

import SwiftUI

struct Keyboard: View {
    // MARK: Data In Function
    var match: (Peg) -> Match?
    
    // MARK: Data Out Function
    var onChoose: ((Peg) -> Void)?

    // MARK: - Body
    
    var body: some View {
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
    }
    
    func view(for key: Peg) -> some View {
        Color.clear
            .aspectRatio(contentMode: .fit)
            .overlay {
                Button {
                    onChoose?(key)
                } label: {
                    Text(key)
                        .flexibleSystemFont()
                        .foregroundStyle(match(key).color)
                }
            }
    }
}

#Preview {
    Keyboard { _ in nil } onChoose: { key in
        print("chose \(key)")
    }
    .padding()
}
