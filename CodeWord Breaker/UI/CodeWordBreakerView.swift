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
    @State private var checker = UITextChecker()
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            CodeView(code: game.masterCode)
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
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    CodeView(
                        code: game.attempts[index],
                        masterCode: game.masterCode
                    )
                }
            }
            PegChooser(choices: game.pegChoices) { peg in
                game.setGuessPeg(peg, at: selection)
                selection = (selection + 1) % game.masterCode.pegs.count
            }
        }
        .padding()
        .onChange(of: words.count) {
            if game.attempts.count == 0 {
                game = CodeBreaker(answer: words.random(length: 5) ?? "ERROR")
            }
        }
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
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
