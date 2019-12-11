//
//  Tokenizer.swift
//  DDMathParser
//
//  Created by Dave DeLong on 8/6/15.
//
//

import Foundation

public struct Tokenizer {
    internal typealias Result = Either<RawToken, MathParserError>
    
    private let string: String
    internal let configuration: Configuration
    
    private let buffer: TokenCharacterBuffer
    private let extractors: Array<TokenExtractor>
    
    public init(string: String, configuration: Configuration = .default) {
        self.string = string
        self.configuration = configuration
        
        buffer = TokenCharacterBuffer(string: string)
        let operatorTokens = configuration.operatorSet.operatorTokenSet
        
        let numberExtractor: TokenExtractor
        if let locale = configuration.locale {
            numberExtractor = LocalizedNumberExtractor(locale: locale)
        } else {
            numberExtractor = DecimalNumberExtractor()
        }
        
        extractors = [
            HexNumberExtractor(),
            OctalNumberExtractor(),
            numberExtractor,
            FractionNumberExtractor(),
            ExponentExtractor(),
            
            VariableExtractor(operatorTokens: operatorTokens),
            QuotedVariableExtractor(),
            
            OperatorExtractor(operatorTokens: operatorTokens),
            
            IdentifierExtractor(operatorTokens: operatorTokens)
        ]
        
    }
    
    public func tokenize() throws -> Array<RawToken> {
        var tokens = Array<RawToken>()
        
        while let next = next() {
            switch next {
                case .error(let e): throw e
                case .value(let t): tokens.append(t)
            }
        }
        
        return tokens
    }
    
    private func next() -> Result? {
        while buffer.peekNext()?.isWhitespaceOrNewline == true {
            buffer.consume()
        }
        
        guard buffer.isAtEnd == false else { return nil }
        
        let start = buffer.currentIndex
        var errors = Array<Result>()
        
        for extractor in extractors {
            guard extractor.matchesPreconditions(buffer, configuration: configuration) else { continue }
            
            buffer.resetTo(start)
            let result = extractor.extract(buffer, configuration: configuration)
            
            switch result {
                case .value(_): return result
                case .error(_): errors.append(result)
            }
        }
        
        return errors.first
    }
    
}
