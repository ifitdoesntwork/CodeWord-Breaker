//
//  GameChooser.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 15.01.2026.
//

import SwiftUI

struct GameChooser: View {
    // MARK: Data In
    @Environment(\.settings) var settings
    
    // MARK: Data Owned by Me
    @State private var selection: CodeBreaker?
    @State private var newGameWordLength: Int?
    @State private var search = ""
    @State private var showsSettings = false
    @State private var showsConfirmation = false
    
    var body: some View {
        NavigationSplitView {
            GameList(
                selection: $selection,
                newGameWordLength: $newGameWordLength,
                containsWord: search
            )
            .navigationTitle("Games")
            .searchable(text: $search)
            .toolbar { gameListEditor }
        } detail: {
            if let selection {
                CodeWordBreakerView(game: selection)
            } else {
                Text("Choose a game!")
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
    
    @ToolbarContentBuilder
    var gameListEditor: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            settingsButton
        }
        ToolbarItemGroup {
            addGameButton
            EditButton()
        }
    }
    
    var settingsButton: some View {
        Button("Settings", systemImage: "gear") {
            showsSettings = true
        }
        .sheet(isPresented: $showsSettings) {
            SettingsEditor()
        }
    }
    
    var addGameButton: some View {
        Button("Add Game", systemImage: "plus") {
            newGameWordLength = settings.wordLength
        }
        .onLongPress {
            showsConfirmation = true
        }
        .confirmationDialog(
            "Word Length",
            isPresented: $showsConfirmation,
            titleVisibility: .visible
        ) {
            ForEach(3..<7) { length in
                Button("\(length)") {
                    newGameWordLength = length
                }
            }
        }
    }
}

#Preview(traits: .swiftData) {
    GameChooser()
}
