//
//  Code.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 25.12.2025.
//

import Foundation

struct Code {
    var kind: Kind
    var pegs: [Peg]
    
    var word: String {
        get { pegs.joined() }
        set { pegs = newValue.map(String.init) }
    }
    
    enum Kind: Equatable {
        case master(isHidden: Bool)
        case guess
        case attempt([Match])
        case unknown
    }
    
    var isHidden: Bool {
        switch kind {
        case .master(let isHidden): isHidden
        default: false
        }
    }
    
    mutating func reset() {
        pegs = .init(repeating: .missing, count: pegs.count)
    }
    
    var matches: [Match]? {
        switch kind {
        case .attempt(let matches): matches
        default: nil
        }
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
    
    func asAttempt(master: Code) -> Self {
        var attempt = self
        attempt.kind = .attempt(attempt.match(against: master))
        return attempt
    }
}

enum Match: Comparable, CaseIterable, Codable {
    case exact
    case inexact
    case noMatch
}

extension Peg {
    static let missing = ""
}
