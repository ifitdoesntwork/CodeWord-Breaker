//
//  GameChooser.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 15.01.2026.
//

import SwiftData
import SwiftUI

struct GameChooser: View {
    // MARK: Data In
    @Environment(\.settings) var settings
    @Environment(\.words) var words
    @Environment(\.modelContext) var modelContext
    
    // MARK: Data Shared with Me
    @Query(sort: \CodeBreaker.lastAttemptTime, order: .reverse)
    private var games: [CodeBreaker]
    
    // MARK: Data Owned by Me
    @State private var selection: CodeBreaker.ID?
    @State private var showsSettings = false
    @State private var showsConfirmation = false
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                ForEach(games) { game in
                    NavigationLink { gameView } label: { summary(of: game) }
                }
                .onDelete {
                    $0.forEach {
                        modelContext.delete(games[$0])
                    }
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
                    isOver: game.isOver,
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
            addGame(wordLength: settings.wordLength)
        }
        .onLongPress {
            showsConfirmation = true
        }
        .confirmationDialog(
            "Word Length",
            isPresented: $showsConfirmation,
            titleVisibility: .visible
        ) {
            ForEach(3..<7) { length in
                Button("\(length)") {
                    addGame(wordLength: length)
                }
            }
        }
        .disabled(words.count == .zero)
    }
    
    func addGame(wordLength: Int) {
        let game = CodeBreaker(answer: randomWord(ofLength: wordLength))
        modelContext.insert(game)
        if games.count == .zero {
            selection = game.id
        }
    }
    
    func addSampleGames() {
        let fetchDescriptor = FetchDescriptor<CodeBreaker>()
        if (try? modelContext.fetchCount(fetchDescriptor)) == .zero {
            (1...5)
                .forEach { _ in
                    let answerLength = Int.random(in: 3...6)
                    let guessLength = Int.random(in: 0...answerLength)
                    
                    modelContext.insert(
                        CodeBreaker(
                            answer: randomWord(ofLength: answerLength),
                            partialGuess: .init(
                                randomWord(ofLength: answerLength)
                                    .dropLast(guessLength)
                            ),
                            attemptWords: (0...Int.random(in: 0...5))
                                .map { _ in randomWord(ofLength: answerLength) }
                                .dropLast()
                        )
                    )
                }
        }
    }
    
    func randomWord(ofLength length: Int) -> String {
        words
            .random(length: length)
        ?? "ERROR"
    }
}

#Preview(traits: .swiftData) {
    GameChooser()
}
