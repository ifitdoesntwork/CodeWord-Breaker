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
    var attempts: [Code]
    
    var lastAttemptTime: Date
    var startTime: Date?
    var endTime: Date?
    var elapsedTime = TimeInterval.zero
    
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
    
    var isNew: Bool {
        elapsedTime == .zero && attempts.isEmpty
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
            endTime = .now
            pauseTimer()
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
    
    func startTimer() {
        if startTime == nil, !isOver {
            startTime = .now
        }
    }
    
    func pauseTimer() {
        if let startTime {
            elapsedTime += Date.now.timeIntervalSince(startTime)
        }
        startTime = nil
    }
}

extension CodeBreaker: Identifiable, Equatable {
    static func == (lhs: CodeBreaker, rhs: CodeBreaker) -> Bool {
        lhs.id == rhs.id
    }
}
