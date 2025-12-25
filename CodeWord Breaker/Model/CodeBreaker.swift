//
//  CodeBreaker.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 25.12.2025.
//

import Foundation

typealias Peg = String

struct CodeBreaker {
    var masterCode: Code
    var guess = Code(kind: .guess)
    var attempts = [Code]()
    let pegChoices: [Peg]
    
    init(answer: String) {
        pegChoices = .keyboard
        masterCode = .init(
            kind: .master(isHidden: true),
            pegs: answer.map(Peg.init)
        )
        print(masterCode)
    }
    
    var isOver: Bool {
        attempts.last?.pegs == masterCode.pegs
    }
    
    mutating func attemptGuess() {
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
        
        guess.reset()
        
        if isOver {
            masterCode.kind = .master(isHidden: false)
        }
    }
    
    mutating func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else {
            return
        }
        
        guess.pegs[index] = peg
    }
}

extension Array where Element == String {
    static let keyboard = "QWERTYUIOPASDFGHJKLZXCVBNM"
        .map(String.init)
}


