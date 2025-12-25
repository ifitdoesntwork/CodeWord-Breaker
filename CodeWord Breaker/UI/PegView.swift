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
    
    // MARK: - Body
    
    let pegShape = Circle()
    
    var body: some View {
        pegShape
            .stroke()
            .overlay { Text(peg).flexibleSystemFont() }
    }
}

#Preview {
    PegView(peg: "A")
        .padding()
}
