//
//  CodeWordBreakerView.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 25.12.2025.
//

import SwiftUI

struct CodeWordBreakerView: View {
    // MARK: Data Shared with Me
    let game: CodeBreaker
    
    // MARK: Data Owned by Me
    @State private var selection = 0
    @State private var checker = UITextChecker()
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            CodeView(code: game.masterCode)
            gameField
        }
        .padding()
        .onChange(of: game.id) {
            selection = .zero
        }
        .trackElapsedTime(in: game)
        .toolbar {
            ToolbarItem {
                ElapsedTime(
                    startTime: game.startTime,
                    isOver: game.isOver,
                    elapsedTime: game.elapsedTime
                )
            }
            .hiddenSharedBackground()
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

extension View {
    func trackElapsedTime(in game: CodeBreaker) -> some View {
        modifier(ElapsedTimeTracker(game: game))
    }
}

struct ElapsedTimeTracker: ViewModifier {
    @Environment(\.scenePhase) var scenePhase
    let game: CodeBreaker
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                game.startTimer()
            }
            .onDisappear {
                game.pauseTimer()
            }
            .onChange(of: game) { oldGame, newGame in
                oldGame.pauseTimer()
                newGame.startTimer()
            }
            .onChange(of: scenePhase) {
                switch scenePhase {
                case .active: game.startTimer()
                case .background: game.pauseTimer()
                default: break
                }
            }
    }
}

extension ToolbarItem {
    @ToolbarContentBuilder
    func hiddenSharedBackground() -> some ToolbarContent {
        if #available(iOS 26.0, *) {
            sharedBackgroundVisibility(.hidden)
        } else {
            self
        }
    }
}

#Preview {
    @Previewable @State var game = CodeBreaker(answer: "AWAIT")
    
    NavigationStack {
        CodeWordBreakerView(game: game)
    }
}
