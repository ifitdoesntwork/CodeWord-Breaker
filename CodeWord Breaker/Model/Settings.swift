//
//  Settings.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 21.01.2026.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var settings = Settings.shared
}

@Observable final class Settings {
    var wordLength = 5
    var pegShape = PegShape.empty
    
    var colors = [
        Match.exact: Color.green,
        .inexact: .orange,
        .noMatch: .red
    ]
    
    static let shared = Settings()
}
