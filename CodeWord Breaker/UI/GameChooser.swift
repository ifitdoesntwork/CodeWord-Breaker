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
    @State private var selection: CodeBreaker.ID?
    @State private var length = 5
    
    var body: some View {
        NavigationSplitView {
            List(
                games.sorted { $0.lastAttemptTime > $1.lastAttemptTime },
                selection: $selection
            ) { game in
                NavigationLink { gameView } label: { summary(of: game) }
            }
            .listStyle(.plain)
            .toolbar {
                addGameButton
            }
        } detail: {
            gameView
        }
        .navigationSplitViewStyle(.balanced)
    }
    
    @ViewBuilder
    var gameView: some View {
        if let index = games.firstIndex(where: { $0.id == selection }) {
            CodeWordBreakerView(game: $games[index])
        } else {
            Text("Choose a game!")
        }
    }
    
    func summary(of game: CodeBreaker) -> some View {
        VStack(alignment: .leading) {
            CodeView(
                code: game.attempts.last ?? game.masterCode,
                masterCode: game.masterCode
            )
            .overlay {
                Color.clear
                    .contentShape(Rectangle())
            }
            Text("^[\(game.attempts.count) attempt](inflect: true)")
        }
    }
    
    var addGameButton: some View {
        Button("Add Game", systemImage: "plus") {
            withAnimation {
                games.append(.init(
                    answer: words.random(length: length) ?? "ERROR"
                ))
            }
            if games.count == 1 {
                selection = games.first?.id
            }
        }
        .disabled(words.count == .zero)
    }
}

#Preview {
    GameChooser()
}
