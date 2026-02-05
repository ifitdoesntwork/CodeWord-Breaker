//
//  CodeWordBreakerApp.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 25.12.2025.
//

import SwiftData
import SwiftUI

@main
struct CodeWordBreakerApp: App {
    var body: some Scene {
        WindowGroup {
            GeometryReader {
                GameChooser()
                    .modelContainer(for: CodeBreaker.self)
                    .environment(\.sceneFrame, $0.frame(in: .global))
            }
            .ignoresSafeArea()
        }
    }
}

extension EnvironmentValues {
    @Entry var settings = Settings(contents: .init(
        wordLength: 5,
        pegShape: .empty,
        matchColors: [
            .exact: Color.green,
            .inexact: .orange,
            .noMatch: .red
        ]
        .mapValues(\.hex)
    ))
    @Entry var sceneFrame = CGRect.zero
    @Entry var words = Words.shared
}
