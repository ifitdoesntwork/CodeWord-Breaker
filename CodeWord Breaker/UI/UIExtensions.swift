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

extension PegShape {
    @ViewBuilder
    var view: some View {
        switch self {
        case .rectangular:
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(lineWidth: 2)
        case .circular:
            Circle()
                .strokeBorder(lineWidth: 2)
        case .empty:
            Color.clear
        }
    }
}
