//
//  Code.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 25.12.2025.
//

import Foundation
import SwiftData

@Model final class Code {
    var kind: Kind
    var pegs: [Peg]
    var timestamp = Date.now
    
    init(kind: Kind, pegs: [Peg]) {
        self.kind = kind
        self.pegs = pegs
    }
    
    var word: String {
        get { pegs.joined() }
        set { pegs = newValue.map(String.init) }
    }
    
    enum Kind: Equatable, Codable {
        case master(isHidden: Bool)
        case guess
        case attempt
        case unknown
    }
    
    enum Match: Comparable, CaseIterable, Codable {
        case exact
        case inexact
        case noMatch
    }
    
    var isHidden: Bool {
        switch kind {
        case .master(let isHidden): isHidden
        default: false
        }
    }
    
    func reset() {
        pegs = .init(repeating: .missing, count: pegs.count)
    }
    
    func match(against otherCode: Code) -> [Match] {
        var pegsToMatch = otherCode.pegs
        
        let backwardsExactMatches = pegs.indices
            .reversed()
            .map { index in
                if
                    pegsToMatch.count > index,
                    pegsToMatch[index] == pegs[index]
                {
                    pegsToMatch.remove(at: index)
                    return Match.exact
                } else {
                    return .noMatch
                }
            }
        
        let exactMatches = Array(backwardsExactMatches.reversed())
        
        return pegs.indices
            .map { index in
                if
                    exactMatches[index] != .exact,
                    let matchIndex = pegsToMatch.firstIndex(of: pegs[index])
                {
                    pegsToMatch.remove(at: matchIndex)
                    return .inexact
                } else {
                    return exactMatches[index]
                }
            }
    }
    
    var asAttempt: Self {
        .init(kind: .attempt, pegs: pegs)
    }
}

extension Peg {
    static let missing = ""
}
