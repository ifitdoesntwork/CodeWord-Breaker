//
//  LongPressModifier.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 04.02.2026.
//
//  Source - https://stackoverflow.com/a/76412638
//  Posted by Steve Barnes
//  Retrieved 2026-01-24, License - CC BY-SA 4.0
//

import SwiftUI

extension View {
    /// Long Press for Buttons
    func onLongPress(
        action: @escaping () -> ()
    ) -> some View {
        modifier(LongPressModifier(action: action))
    }
}

private struct LongPressModifier: ViewModifier {
    let action: () -> ()
    
    func body(content: Content) -> some View {
        content
            .buttonStyle(SupportsLongPress(action: action))
    }
}

private struct SupportsLongPress: PrimitiveButtonStyle {
    // MARK: Data Out Function
    let action: () -> ()
    
    // MARK: Data Owned by Me
    @State private var isPressed: Bool = false
    
    // MARK: - Body
    
    func makeBody(configuration: Configuration) -> some View {
        let result = configuration.label
            .opacity(isPressed ? .pressedOpacity : 1)
            .onTapGesture {
                configuration.trigger()
            }
            .onLongPressGesture(
                perform: {
                    action()
                },
                onPressingChanged: { pressing in
                    isPressed = pressing
                }
            )
        
        if #available(iOS 26.0, *) {
            result
        } else {
            result
                .foregroundStyle(Color.accentColor)
        }
    }
}
