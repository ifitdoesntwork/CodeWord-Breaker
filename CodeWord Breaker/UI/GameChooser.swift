//
//  GameChooser.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 15.01.2026.
//

import SwiftUI

struct GameChooser: View {
    // MARK: Data In
    @Environment(\.words) var words
    
    // MARK: Data Owned by Me
    @State private var games = [CodeBreaker]()
    @State private var length = 5
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(
                    games
                        .sorted { $0.lastAttemptTime > $1.lastAttemptTime }
                ) { game in
                    Text(game.attempts.last?.word ?? "No attempts yet")
                }
            }
            .listStyle(.plain)
            .toolbar {
                Button("Add Game", systemImage: "plus") {
                    games.append(.init(
                        answer: words.random(length: length) ?? "ERROR"
                    ))
                }
                .disabled(words.count == .zero)
            }
        }
    }
}

#Preview {
    GameChooser()
}
