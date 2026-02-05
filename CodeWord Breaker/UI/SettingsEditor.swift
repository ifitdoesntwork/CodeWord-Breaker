//
//  SettingsEditor.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 21.01.2026.
//

import SwiftUI

struct SettingsEditor: View {
    // MARK: Data In
    @Environment(\.dismiss) private var dismiss
    @Environment(\.words) private var words
    
    // MARK: Data Shared with Me
    @Environment(\.settings) private var settings
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            Form {
                wordLength
                pegShape
                matchColors
            }
            .navigationTitle("Settings")
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
    
    @ViewBuilder
    private var wordLength: some View {
        @Bindable var settings = settings
        
        Section("Word Length") {
            Stepper(
                "\(settings.wordLength) letters",
                value: $settings.wordLength,
                in: words.lengthRange
            )
        }
    }
    
    @ViewBuilder
    private var pegShape: some View {
        @Bindable var settings = settings
        
        Picker(
            "Peg Shape",
            selection: $settings.pegShape
        ) {
            ForEach(PegShape.allCases, id: \.self) { shape in
                shape.view
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxHeight: .tappableHeight)
            }
        }
        .pickerStyle(.inline)
    }
    
    @ViewBuilder
    private var matchColors: some View {
        @Bindable var settings = settings
        
        Section("Match Colors") {
            ForEach(Code.Match.allCases, id: \.self) { match in
                ColorPicker(
                    selection: $settings.matchColors[decodedFor: match],
                    supportsOpacity: false
                ) {
                    Text(match.title)
                }
            }
        }
    }
}

#Preview {
    SettingsEditor()
}
