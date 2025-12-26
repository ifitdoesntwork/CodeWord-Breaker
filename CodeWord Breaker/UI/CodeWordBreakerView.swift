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
    @State private var selection = 0
    @State private var hidesMasterCode = false
    @State private var checker = UITextChecker()
    
    var newGame: CodeBreaker {
        CodeBreaker(answer: words.random(length: .random(in: 3...5)) ?? "ERROR")
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Button("Restart", systemImage: "arrow.circlepath") {
                hidesMasterCode = true
                withAnimation(.restart) {
                    hidesMasterCode = false
                    selection = .zero
                    game = newGame
                }
            }
            CodeView(code: game.masterCode, hidesMasterCode: $hidesMasterCode)
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
        .padding()
        .onChange(of: words.count) {
            if game.attempts.count == 0 {
                game = newGame
            }
        }
        
        if !game.isOver {
            Keyboard() { peg in
                game.setGuessPeg(peg, at: selection)
                selection = (selection + 1) % game.masterCode.pegs.count
            }
            .transition(.keyboard)
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
}

#Preview {
    CodeWordBreakerView()
}
