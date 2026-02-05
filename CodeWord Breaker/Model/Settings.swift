//
//  Settings.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 21.01.2026.
//

import Foundation

typealias HexColor = Int

@dynamicMemberLookup @Observable
final class Settings {
    private var contents: Contents {
        didSet { UserDefaults[.settings] = contents }
    }
    
    init(contents: Contents) {
        self.contents = UserDefaults[.settings] ?? contents
    }
    
    /// Both `UserDefaults` exchange  and `Codable` conformance
    /// are simplified by putting properties in a `struct`.
    /// The former means you no longer need to (re)store properties one by one.
    /// The latter is due to automatic synthesis of conformance code.
    struct Contents: Codable {
        var wordLength: Int
        var pegShape: PegShape
        var matchColors: [Code.Match: HexColor]
    }
    
    /// Restoring direct access to properties
    subscript<T>(
        dynamicMember keyPath: WritableKeyPath<Contents, T>
    ) -> T {
        get { contents[keyPath: keyPath] }
        set { contents[keyPath: keyPath] = newValue }
    }
}

private extension UserDefaults.CodingKeys {
    static let settings = Self(stringValue: "Settings")
}
