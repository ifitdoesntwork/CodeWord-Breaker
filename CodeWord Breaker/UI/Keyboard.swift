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
    var onChoose: ((Peg) -> Void)?
    var onBackspace: () -> Void
    var onReturn: () -> Void

    // MARK: - Body
    
    var body: some View {
        HStack(spacing: .zero) {
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
    
    var ancillaries: some View {
        VStack {
            Button("⌫", action: onBackspace)
                .flexibleSystemFont()
                .frame(width: 40, height: 40)
            Spacer()
                .aspectRatio(10, contentMode: .fit)
            Button("↩︎", action: onReturn)
                .disabled(!canReturn)
                .flexibleSystemFont()
                .frame(width: 40, height: 40)
        }
    }
}

#Preview {
    Keyboard(canReturn: true) { _ in
        nil
    } onChoose: { key in
        print("chose \(key)")
    } onBackspace: {
        
    } onReturn: {
        
    }
    .padding()
}
