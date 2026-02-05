//
//  GameChooser.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 15.01.2026.
//

import SwiftUI

struct GameChooser: View {
    // MARK: Data In
    @Environment(\.settings) private var settings
    @Environment(\.words) private var words
    
    // MARK: Data Owned by Me
    @State private var selection: CodeBreaker?
    @State private var newGameWordLength: Int?
    @State private var search = ""
    @State private var showsSettings = false
    @State private var showsConfirmation = false
    @State private var filterOption = GameList.Filter.all
    
    // MARK: - Body
    
    var body: some View {
        NavigationSplitView {
            filter
            
            GameList(
                selection: $selection,
                newGameWordLength: $newGameWordLength,
                containsWord: search,
                filterBy: filterOption
            )
            .navigationTitle("Games")
            .searchable(text: $search)
            .animation(.default, value: search)
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
    
    private var filter: some View {
        Picker(
            "Filter By",
            selection: $filterOption.animation(.default)
        ) {
            ForEach(GameList.Filter.allCases, id: \.self) {
                Text($0.title)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    @ToolbarContentBuilder
    private var gameListEditor: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            settingsButton
        }
        ToolbarItemGroup {
            addGameButton
            EditButton()
        }
    }
    
    private var settingsButton: some View {
        Button("Settings", systemImage: "gear") {
            showsSettings = true
        }
        .sheet(isPresented: $showsSettings) {
            SettingsEditor()
        }
    }
    
    private var addGameButton: some View {
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
            ForEach(words.lengthRange, id: \.self) { length in
                Button("\(length) letters") {
                    newGameWordLength = length
                }
            }
        }
    }
}

#Preview(traits: .swiftData) {
    GameChooser()
}
