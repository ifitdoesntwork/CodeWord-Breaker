//
//  ModelExtensions.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 26.12.2025.
//

import Foundation

extension RangeReplaceableCollection {
    
    func appending(_ element: Element?) -> Self {
        var result = self
        if let element {
            result.append(element)
        }
        return result
    }
}

extension TimeInterval {
    static let minute: Self = 60
}

extension UserDefaults {
    
    static subscript<T: Codable>(_ key: CodingKeys) -> T? {
        get {
            UserDefaults.standard
                .data(forKey: key.stringValue)
                .flatMap { try? JSONDecoder().decode(T.self, from: $0) }
        }
        set {
            UserDefaults.standard
                .set(
                    try? JSONEncoder().encode(newValue),
                    forKey: key.stringValue
                )
        }
    }
    
    struct CodingKeys {
        let stringValue: String
    }
}
