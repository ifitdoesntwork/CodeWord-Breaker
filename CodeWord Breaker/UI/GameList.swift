//
//  GameList.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 29.01.2026.
//

import SwiftData
import SwiftUI

struct GameList: View {
    // MARK: Data In
    @Environment(\.settings) var settings
    @Environment(\.words) var words
    @Environment(\.modelContext) var modelContext
    
    // MARK: Data Shared with Me
    @Binding var selection: CodeBreaker?
    @Binding var newGameWordLength: Int?
    @Query private var games: [CodeBreaker]
    
    init(
        selection: Binding<CodeBreaker?>,
        newGameWordLength: Binding<Int?>,
        containsWord search: String = ""
    ) {
        _selection = selection
        _newGameWordLength = newGameWordLength
        
        let search = search.uppercased()
        let predicate = #Predicate<CodeBreaker> { game in
            game.masterCode.word.contains(search)
            || game._attempts.contains { $0.word.contains(search) }
            || search.isEmpty
        }
        _games = Query(
            filter: predicate,
            sort: \CodeBreaker.lastAttemptTime,
            order: .reverse
        )
    }
    
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                NavigationLink(value: game) { summary(of: game) }
            }
            .onDelete {
                $0.forEach {
                    modelContext.delete(games[$0])
                }
            }
        }
        .listStyle(.plain)
        .onChange(of: words.count, addSampleGames)
        .onChange(of: newGameWordLength) {
            $1.map(addGame)
            newGameWordLength = nil
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
    
    func addGame(wordLength: Int) {
        guard words.count > 0 else {
            return
        }
        
        let game = CodeBreaker(answer: randomWord(ofLength: wordLength))
        modelContext.insert(game)
        if games.count == .zero {
            selection = game
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
    @Previewable @Environment(\.settings) var settings
    @Previewable @State var selection: CodeBreaker?
    @Previewable @State var newGameWordLength: Int?

    NavigationSplitView {
        GameList(
            selection: $selection,
            newGameWordLength: $newGameWordLength
        )
        .toolbar {
            Button("Add Game", systemImage: "plus") {
                newGameWordLength = settings.wordLength
            }
        }
    } detail: {
        if let selection {
            CodeWordBreakerView(game: selection)
        } else {
            Text("Choose a game!")
        }
    }
}
