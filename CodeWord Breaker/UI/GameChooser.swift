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
                    link(to: game)
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
    
    func link(to game: CodeBreaker) -> some View {
        NavigationLink {
            if
                let index = games
                    .firstIndex(where: { $0.id == game.id })
            {
                CodeWordBreakerView(game: $games[index])
            }
        } label: {
            CodeView(
                code: game.attempts.last ?? game.masterCode,
                masterCode: game.masterCode
            )
            .overlay {
                Color.clear
                    .contentShape(Rectangle())
            }
        }
    }
}

#Preview {
    GameChooser()
}
