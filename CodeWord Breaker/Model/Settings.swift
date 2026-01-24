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
    
    struct Contents: Codable {
        var wordLength: Int
        var pegShape: PegShape
        var matchColors: [Match: HexColor]
    }
    
    subscript<T>(
        dynamicMember keyPath: WritableKeyPath<Contents, T>
    ) -> T {
        get { contents[keyPath: keyPath] }
        set { contents[keyPath: keyPath] = newValue }
    }
    
    init(contents: Contents) {
        self.contents = UserDefaults[.settings] ?? contents
    }
    
    private var contents: Contents {
        didSet { UserDefaults[.settings] = contents }
    }
}

extension UserDefaults.CodingKeys {
    static let settings = Self(stringValue: "Settings")
}
