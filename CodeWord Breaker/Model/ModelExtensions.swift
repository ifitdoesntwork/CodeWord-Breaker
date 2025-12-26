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
