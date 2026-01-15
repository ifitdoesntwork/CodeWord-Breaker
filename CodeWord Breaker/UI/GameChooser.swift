//
//  GameChooser.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 15.01.2026.
//

import SwiftUI

struct GameChooser: View {
    // MARK: Data Owned by Me
    @State private var games = [CodeBreaker]()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(games) { game in
                    Text(game.attempts.last?.word ?? "No attempts yet")
                }
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    GameChooser()
}
