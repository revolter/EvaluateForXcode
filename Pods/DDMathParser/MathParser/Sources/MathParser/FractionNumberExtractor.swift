//
//  FractionNumberExtractor.swift
//  DDMathParser
//
//  Created by Dave DeLong on 8/30/15.
//
//

import Foundation

internal struct FractionNumberExtractor: TokenExtractor {
    
    internal static let fractions: Dictionary<Character, Double> = [
        "½": 0.5,
        "⅓": 0.3333333,
        "⅔": 0.6666666,
        "¼": 0.25,
        "¾": 0.75,
        "⅕": 0.2,
        "⅖": 0.4,
        "⅗": 0.6,
        "⅘": 0.8,
        "⅙": 0.1666666,
        "⅚": 0.8333333,
        "⅛": 0.125,
        "⅜": 0.375,
        "⅝": 0.625,
        "⅞": 0.875
    ]
    
    func matchesPreconditions(_ buffer: TokenCharacterBuffer, configuration: Configuration) -> Bool {
        guard let peek = buffer.peekNext() else { return false }
        guard let _ = FractionNumberExtractor.fractions[peek] else { return false }
        return true
    }
    
    func extract(_ buffer: TokenCharacterBuffer, configuration: Configuration) -> Tokenizer.Result {
        let start = buffer.currentIndex
        
        // consume the character
        buffer.consume()
        
        let range: Range<Int> = start ..< buffer.currentIndex
        let raw = buffer[range]
        return .value(FractionNumberToken(string: raw, range: range))
    }
    
}
