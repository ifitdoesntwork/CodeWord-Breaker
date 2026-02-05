//
//  ElapsedTimeTracker.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 30.01.2026.
//

import SwiftData
import SwiftUI

extension View {
    func trackElapsedTime(in game: CodeBreaker) -> some View {
        modifier(ElapsedTimeTracker(game: game))
    }
}

private struct ElapsedTimeTracker: ViewModifier {
    // MARK: Data In
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.modelContext) private var modelContext
    
    // MARK: Data Shared with Me
    let game: CodeBreaker
    
    // MARK: - Body
    
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
            .onReceive(modelContextWillSave) { _ in
                game.updateElapsedTime()
                print("updated elapsed time to \(game.elapsedTime)")
            }
    }
    
    private var modelContextWillSave: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(
            for: ModelContext.willSave,
            object: modelContext
        )
    }
}
