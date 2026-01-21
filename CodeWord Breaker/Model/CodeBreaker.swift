//
//  CodeBreaker.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 25.12.2025.
//

import Foundation

typealias Peg = String

@Observable final class CodeBreaker {
    var masterCode: Code
    var guess: Code
    var attempts = [Code]()
    var lastAttemptTime: Date
    
    init(answer: String) {
        masterCode = .init(
            kind: .master(isHidden: true),
            pegs: answer.map(Peg.init)
        )
        guess = .init(
            kind: .guess,
            pegs: .init(repeating: .missing, count: answer.count)
        )
        lastAttemptTime = .now
        print(masterCode)
    }
    
    var isOver: Bool {
        attempts.last?.pegs == masterCode.pegs
    }
    
    func attemptGuess() {
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
        lastAttemptTime = .now
        
        guess.reset()
        
        if isOver {
            masterCode.kind = .master(isHidden: false)
        }
    }
    
    func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else {
            return
        }
        
        guess.pegs[index] = peg
    }
    
    func bestMatch(for peg: Peg) -> Match? {
        attempts
            .reduce(nil) { result, code in
                code.pegs
                    .enumerated()
                    .filter { $0.element == peg }
                    .map(\.offset)
                    .map { code.match(against: masterCode)[$0] }
                    .appending(result)
                    .sorted()
                    .first
            }
    }
}

extension CodeBreaker: Identifiable {
    var id: String {
        masterCode.word
    }
}
