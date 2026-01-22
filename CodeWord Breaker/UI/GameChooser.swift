//
//  GameChooser.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 15.01.2026.
//

import SwiftUI

struct GameChooser: View {
    // MARK: Data In
    @Environment(\.settings) var settings
    @Environment(\.words) var words
    
    // MARK: Data Owned by Me
    @State private var games = [CodeBreaker]()
    @State private var selection: CodeBreaker.ID?
    @State private var confirmationGameId: CodeBreaker.ID?
    @State private var showsSettings = false
    
    var sortedGames: [CodeBreaker] {
        get {
            games
                .sorted { $0.lastAttemptTime > $1.lastAttemptTime }
        }
        nonmutating set {
            games = newValue
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                ForEach(sortedGames) { game in
                    wordLengthSelection(for: game) {
                        NavigationLink { gameView } label: { summary(of: game) }
                    }
                }
                .onDelete {
                    sortedGames.remove(atOffsets: $0)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Games")
            .toolbar { gameListEditor }
            .onChange(of: words.count, addSampleGames)
        } detail: {
            gameView
        }
        .navigationSplitViewStyle(.balanced)
    }
    
    @ViewBuilder
    var gameView: some View {
        if let index = games.firstIndex(where: { $0.id == selection }) {
            CodeWordBreakerView(game: games[index])
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
            .frame(maxHeight: 40)
            .overlay {
                Color.clear
                    .contentShape(Rectangle())
            }
            HStack {
                Text("^[\(game.attempts.count) attempt](inflect: true)")
                Spacer()
                ElapsedTime(
                    startTime: game.startTime,
                    endTime: game.endTime,
                    elapsedTime: game.elapsedTime
                )
            }
        }
    }
    
    var settingsButton: some View {
        Button("Settings", systemImage: "gear") {
            showsSettings = true
        }
    }
    
    @ToolbarContentBuilder
    var gameListEditor: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            settingsButton
                .sheet(isPresented: $showsSettings) {
                    SettingsEditor()
                }
        }
        ToolbarItemGroup {
            addGameButton
            EditButton()
        }
    }
    
    var addGameButton: some View {
        Button("Add Game", systemImage: "plus") {
            withAnimation {
                games.append(.init(
                    answer: randomWord(ofLength: settings.wordLength)
                ))
            }
            if games.count == 1 {
                selection = games.first?.id
            }
        }
        .disabled(words.count == .zero)
    }
    
    func addSampleGames() {
        if games.isEmpty {
            (1...5)
                .forEach { _ in
                    let answerLength = Int.random(in: 3...6)
                    let guessLength = Int.random(in: 0...answerLength)
                    
                    games.append(.init(
                        answer: randomWord(ofLength: answerLength),
                        partialGuess: .init(
                            randomWord(ofLength: answerLength)
                                .dropLast(guessLength)
                        ),
                        attemptWords: (0...Int.random(in: 0...5))
                            .map { _ in randomWord(ofLength: answerLength) }
                            .dropLast()
                    ))
                }
        }
    }
    
    func randomWord(ofLength length: Int) -> String {
        words
            .random(length: length)
        ?? "ERROR"
    }
    
    func wordLengthSelection(
        for game: CodeBreaker,
        link: () -> some View
    ) -> some View {
        link()
            .contentShape(Rectangle())
            .onTapGesture(count: game.isNew ? 1 : .max) {
                confirmationGameId = game.id
            }
            .confirmationDialog(
                "Word Length",
                isPresented: .init(
                    get: { confirmationGameId == game.id },
                    set: { _ in confirmationGameId = nil }
                ),
                titleVisibility: .visible
            ) {
                ForEach(3..<7) { length in
                    Button("\(length)") {
                        let replacement = CodeBreaker(
                            answer: randomWord(ofLength: length)
                        )
                        games.removeAll { $0.id == game.id }
                        games.append(replacement)
                        selection = replacement.id
                    }
                }
            }
    }
}

#Preview {
    GameChooser()
}
