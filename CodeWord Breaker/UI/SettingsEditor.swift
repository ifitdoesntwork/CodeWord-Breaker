//
//  SettingsEditor.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 21.01.2026.
//

import SwiftUI

struct SettingsEditor: View {
    // MARK: Data In
    @Environment(\.settings) var settings
    @Environment(\.dismiss) var dismiss
    
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
    var wordLength: some View {
        @Bindable var settings = settings
        
        Section("Word Length") {
            Stepper(
                "\(settings.wordLength)",
                value: $settings.wordLength,
                in: 3...6
            )
        }
    }
    
    @ViewBuilder
    var pegShape: some View {
        @Bindable var settings = settings
        
        Picker(
            "Peg Shape",
            selection: $settings.pegShape
        ) {
            ForEach(PegShape.allCases, id: \.self) { shape in
                shape.view
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxHeight: 40)
            }
        }
        .pickerStyle(.inline)
    }
    
    @ViewBuilder
    var matchColors: some View {
        @Bindable var settings = settings
        
        Section("Match Colors") {
            ForEach(Match.allCases, id: \.self) { match in
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
