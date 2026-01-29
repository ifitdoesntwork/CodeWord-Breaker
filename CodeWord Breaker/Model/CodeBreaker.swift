//
//  CodeBreaker.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 25.12.2025.
//

import Foundation
import SwiftData

typealias Peg = String

@Model final class CodeBreaker {
    @Relationship(deleteRule: .cascade) var masterCode: Code
    @Relationship(deleteRule: .cascade) var guess: Code
    @Relationship(deleteRule: .cascade) var _attempts: [Code]
    
    var lastAttemptTime: Date
    @Transient var startTime: Date?
    var elapsedTime = TimeInterval.zero
    
    var attempts: [Code] {
        get { _attempts.sorted { $0.timestamp < $1.timestamp } }
        set { _attempts = newValue }
    }
    
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
        _attempts = attemptWords
            .map {
                Code(kind: .guess, pegs: $0.map(Peg.init))
                    .asAttempt
            }
        lastAttemptTime = .now
        print(masterCode.word)
    }
    
    var isNew: Bool {
        elapsedTime == .zero && attempts.isEmpty
    }
    
    var isOver: Bool {
        attempts.last?.pegs == masterCode.pegs
    }
    
    func attemptGuess() {
        attempts.append(guess.asAttempt)
        lastAttemptTime = .now
        
        guess.reset()
        
        if isOver {
            masterCode.kind = .master(isHidden: false)
            pauseTimer()
        }
    }
    
    func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else {
            return
        }
        
        guess.pegs[index] = peg
    }
    
    func bestMatch(for peg: Peg) -> Code.Match? {
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
            elapsedTime += 0.00001
        }
    }
    
    func pauseTimer() {
        if let startTime {
            elapsedTime += Date.now.timeIntervalSince(startTime)
        }
        startTime = nil
    }
    
    static func predicate(
        search: String,
        showsOnlyCompleted: Bool
    ) -> Predicate<CodeBreaker> {
        let search = search.uppercased()
        let containsWord = #Predicate<CodeBreaker> { game in
            game.masterCode.word.contains(search)
            || game._attempts.contains { $0.word.contains(search) }
            || search.isEmpty
        }
        let filtersByCompletion = #Predicate<CodeBreaker> { game in
            showsOnlyCompleted
                ? game._attempts.contains { $0.word == game.masterCode.word }
                : true
        }
        return #Predicate<CodeBreaker> { game in
            containsWord.evaluate(game)
            && filtersByCompletion.evaluate(game)
        }
    }
}
