//
//  Settings.swift
//  CodeWord Breaker
//
//  Created by Denis Avdeev on 21.01.2026.
//

import SwiftData

typealias HexColor = Int

@Model final class Settings {
    var wordLength: Int
    var pegShape: PegShape
    var matchColors: [Code.Match: HexColor]
    
    init(
        wordLength: Int,
        pegShape: PegShape,
        matchColors: [Code.Match : HexColor]
    ) {
        self.wordLength = wordLength
        self.pegShape = pegShape
        self.matchColors = matchColors
    }
}
