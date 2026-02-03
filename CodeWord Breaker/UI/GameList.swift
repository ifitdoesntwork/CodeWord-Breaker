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
    @Environment(\.words) var words
    @Environment(\.modelContext) var modelContext
    
    // MARK: Data Shared with Me
    @Binding var selection: CodeBreaker?
    @Binding var newGameWordLength: Int?
    @Query private var games: [CodeBreaker]
    
    init(
        selection: Binding<CodeBreaker?>,
        newGameWordLength: Binding<Int?>,
        containsWord search: String = "",
        filterBy option: Option = .all
    ) {
        _selection = selection
        _newGameWordLength = newGameWordLength
        
        _games = Query(
            filter: CodeBreaker.predicate(
                search: search,
                showsOnlyCompleted: option == .completed
            ),
            sort: \CodeBreaker.lastAttemptTime,
            order: .reverse
        )
    }
    
    enum Option: CaseIterable {
        case all
        case completed
        
        var title: String {
            switch self {
            case .all:
                "All"
            case .completed:
                "Completed"
            }
        }
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
        .onChange(of: games) {
            if let selection, !games.contains(selection) {
                self.selection = nil
            }
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
    @Previewable @State var selection: CodeBreaker?
    @Previewable @State var newGameWordLength: Int?
    @Previewable @State var showsOnlyCompleted = false

    NavigationSplitView {
        GameList(
            selection: $selection,
            newGameWordLength: $newGameWordLength,
            filterBy: showsOnlyCompleted ? .completed : .all
        )
        .toolbar {
            Button(
                "Show Completed",
                systemImage: showsOnlyCompleted ? "flag.fill" : "flag"
            ) {
                showsOnlyCompleted.toggle()
            }
            Button("Add Game", systemImage: "plus") {
                newGameWordLength = 5
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
