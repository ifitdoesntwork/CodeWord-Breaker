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
            GameChooser()
                .modelContainer(for: CodeBreaker.self)
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
}
