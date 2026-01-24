//
//  UIExtensions.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 25.12.2025.
//

import SwiftUI

extension Animation {
    static let codeBreaker = Animation.bouncy
    static let guess = Animation.codeBreaker
    static let restart = Animation.codeBreaker
    static let selection = Animation.codeBreaker
}

extension AnyTransition {
    static let keyboard = AnyTransition.offset(x: .zero, y: 200)
    
    static func attempt(_ isOver: Bool) -> AnyTransition {
        .asymmetric(
            insertion: isOver ? .opacity : .move(edge: .top),
            removal: .move(edge: .trailing)
        )
    }
}

extension View {
    func celebration(isOn: Bool) -> some View {
        self
            .rotation3DEffect(.degrees(isOn ? 0 : 360), axis: (0, 1, 0))
            .offset(x: .zero, y: isOn ? -10 : 0)
    }
    
    func flexibleSystemFont(minimum: CGFloat = 8, maximum: CGFloat = 80) -> some View {
        self
            .font(.system(size: maximum))
            .minimumScaleFactor(minimum/maximum)
    }
}

extension Color {
    init(light: Color, dark: Color) {
        self = .init(uiColor: .init { traits in
            traits.userInterfaceStyle == .light ? .init(light) : .init(dark)
        })
    }
    
    static func gray(_ brightness: CGFloat) -> Color {
        Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
    
    init(hex: Int) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 08) & 0xFF) / 255,
            blue: Double((hex >> 00) & 0xFF) / 255
        )
    }
    
    var hex: Int {
        var red = CGFloat.zero
        var green = CGFloat.zero
        var blue = CGFloat.zero
        var alpha = CGFloat.zero
        
        UIColor(self)
            .getRed(
                &red,
                green: &green,
                blue: &blue,
                alpha: &alpha
            )
        
        return (Int)(red * 255) << 16
        | (Int)(green * 255) << 08
        | (Int)(blue * 255) << 00
    }
}

extension Match {
    var title: String {
        switch self {
        case .exact:
            "Exact"
        case .inexact:
            "Inexact"
        case .noMatch:
            "No Match"
        }
    }
}

extension Dictionary where Key == Match, Value == HexColor {
    subscript(decodedFor match: Match) -> Color {
        get {
            self[match]
                .map(Color.init)
            ?? .clear
        }
        set {
            self[match] = newValue.hex
        }
    }
}

// MARK: - Long Press

// Source - https://stackoverflow.com/a/76412638
// Posted by Steve Barnes
// Retrieved 2026-01-24, License - CC BY-SA 4.0

extension View {
    func onLongPress(
        action: @escaping () -> ()
    ) -> some View {
        modifier(SupportsLongPressModifier(action: action))
    }
}

struct SupportsLongPressModifier: ViewModifier {
    let action: () -> ()
    
    func body(content: Content) -> some View {
        content
            .buttonStyle(SupportsLongPress(action: action))
    }
}

struct SupportsLongPress: PrimitiveButtonStyle {
    let action: () -> ()
    @State var isPressed: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        let result = configuration.label
            .opacity(isPressed ? 0.25 : 1)
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
