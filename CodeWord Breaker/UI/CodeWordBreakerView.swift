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
    @State private var length = 5
    @State private var selection = 0
    @State private var checker = UITextChecker()
    
    var newGame: CodeBreaker {
        CodeBreaker(answer: words.random(length: length) ?? "ERROR")
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            CodeView(code: game.masterCode)
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
    
    var gameField: some View {
        ScrollView {
            if !game.isOver {
                CodeView(code: game.guess, selection: $selection)
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
    
    @ViewBuilder
    var keyboard: some View {
        if !game.isOver {
            Keyboard(
                canReturn: checker.isAWord(game.guess.word.capitalized)
                    && game.guess.word.count == game.masterCode.word.count,
                match: game.bestMatch,
                actions: (
                    onChoose: { peg in
                        game.setGuessPeg(peg, at: selection)
                        selection = (selection + 1) % game.masterCode.pegs.count
                    },
                    onBackspace: {
                        let indexToMove = max(selection - 1, .zero)
                        game.guess.pegs[indexToMove] = .missing
                        selection = indexToMove
                    },
                    onReturn: {
                        withAnimation(.guess) {
                            game.attemptGuess()
                            selection = 0
                        }
                    }
                )
            )
            .transition(.keyboard)
        }
    }
}

#Preview {
    CodeWordBreakerView()
}
