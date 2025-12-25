//
//  PegChooser.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 25.12.2025.
//

import SwiftUI

struct PegChooser: View {
    
    // MARK: Data In
    let choices: [Peg]
    
    // MARK: Data Out Function
    var onChoose: ((Peg) -> Void)?

    // MARK: - Body
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(choices, id: \.self) { peg in
                    Button {
                        onChoose?(peg)
                    } label: {
                        Text(peg)
                    }
                }
            }
        }
    }
}

#Preview {
    PegChooser(choices: .keyboard) { peg in
        print("chose \(peg)")
    }
    .padding()
}
