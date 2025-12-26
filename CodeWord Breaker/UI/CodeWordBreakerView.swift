//
//  CodeWordBreakerView.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 25.12.2025.
//

import SwiftUI

struct CodeWordBreakerView: View {
    // MARK: Data In
    @Environment(\.words) var words
    
    // MARK: Data Owned by Me
    @State private var game = CodeBreaker(answer: "AWAIT")
    @State private var length = 3
    @State private var selection = 0
    @State private var hidesMasterCode = false
    @State private var checker = UITextChecker()
    
    var newGame: CodeBreaker {
        CodeBreaker(answer: words.random(length: length) ?? "ERROR")
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            menu
            CodeView(code: game.masterCode, hidesMasterCode: $hidesMasterCode)
            gameField
        }
        .padding()
        .onChange(of: words.count) {
            if game.attempts.count == 0 {
                game = newGame
            }
        }
        
        keyboard
    }
    
    @ViewBuilder
    var menu: some View {
        HStack {
            Picker("Letters:", selection: $length) {
                ForEach(3..<7) {
                    Text($0.description).tag($0)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: length, restart)
            
            Button(
                "Restart",
                systemImage: "arrow.circlepath",
                action: restart
            )
        }
    }
    
    func restart() {
        hidesMasterCode = true
        withAnimation(.restart) {
            hidesMasterCode = false
            selection = .zero
            game = newGame
        }
    }
    
    var gameField: some View {
        ScrollView {
            if !game.isOver {
                CodeView(code: game.guess, selection: $selection) {
                    if
                        checker.isAWord(game.guess.word.capitalized)
                        && game.guess.word.count == game.masterCode.word.count
                    {
                        guessButton
                    }
                }
                .animation(nil, value: game.attempts.count)
            }
            ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                CodeView(
                    code: game.attempts[index],
                    masterCode: game.masterCode
                )
                .transition(.attempt(game.isOver))
            }
        }
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation(.guess) {
                game.attemptGuess()
                selection = 0
            }
        }
        .flexibleSystemFont()
    }
    
    @ViewBuilder
    var keyboard: some View {
        if !game.isOver {
            Keyboard(match: game.bestMatch) { peg in
                game.setGuessPeg(peg, at: selection)
                selection = (selection + 1) % game.masterCode.pegs.count
            }
            .transition(.keyboard)
        }
    }
}

#Preview {
    CodeWordBreakerView()
}
