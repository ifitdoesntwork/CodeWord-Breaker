//
//  Color+Hex.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 05.02.2026.
//

import SwiftUI

extension Color {
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

extension Dictionary where Key == Code.Match, Value == HexColor {
    subscript(decodedFor match: Code.Match) -> Color {
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
