//
//  SettingsAwareView.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 03.02.2026.
//

import SwiftData
import SwiftUI

protocol SettingsAwareView: View {
    var settingsFetchResult: [Settings] { get }
}

extension SettingsAwareView {
    var settings: Settings {
        settingsFetchResult.first ?? .initial
    }
    
    func initializeSettings(in modelContext: ModelContext) {
        if settingsFetchResult.isEmpty {
            modelContext.insert(Settings.initial)
        }
    }
}

extension Settings {
    static let initial = Settings(
        wordLength: 5,
        pegShape: .empty,
        matchColors: [
            .exact: Color.green,
            .inexact: .orange,
            .noMatch: .red
        ]
        .mapValues(\.hex)
    )
}
