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
    
    init(
        answer: String,
        partialGuess: String = "",
        attemptWords: [String] = []
    ) {
        let master = Code(
            kind: .master(isHidden: true),
            pegs: answer.map(Peg.init)
        )
        masterCode = master
        guess = .init(
            kind: .guess,
            pegs: (0..<answer.count)
                .map { index in
                    index < partialGuess.count
                        ? .init(Array(partialGuess)[index])
                        : .missing
                }
        )
        attempts = attemptWords
            .map {
                Code(kind: .guess, pegs: $0.map(Peg.init))
                    .asAttempt(master: master)
            }
        lastAttemptTime = .now
        print(masterCode)
    }
    
    var isOver: Bool {
        attempts.last?.pegs == masterCode.pegs
    }
    
    func attemptGuess() {
        attempts.append(guess.asAttempt(master: masterCode))
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
