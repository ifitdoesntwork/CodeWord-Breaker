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
                .modelContainer(for: [CodeBreaker.self, Settings.self])
        }
    }
}
