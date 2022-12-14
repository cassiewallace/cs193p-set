//
//  ShapeSetGame.swift
//  Set
//
//  Created by Cassie Wallace on 9/20/22.
//

import SwiftUI

class ShapeSetGame: ObservableObject {
    // MARK: Public Var(s)
    typealias Card = SetGame.Card
    
    var cards: [Card] {
        return setGameModel.cards
    }
    
    // MARK: Private Var(s)
    @Published private var setGameModel: SetGame
    
    // MARK: Init(s)
    init() {
        setGameModel = Self.createSetGame()
    }
    
    // MARK: Private Static Func(s)
    private static func createSetGame() -> SetGame {        
        return SetGame()
    }
    
    // MARK: - Intent(s)
    func startNewGame() {
        setGameModel =  Self.createSetGame()
    }
    
    func checkForMatch(between selectedCards: [ShapeSetGame.Card]) -> Bool {
        return setGameModel.isValidMatch(c1: selectedCards[0], c2: selectedCards[1], c3: selectedCards[2])
    }
    
    func handleMatch(between selectedCards: [ShapeSetGame.Card]) {
        setGameModel.handleMatch(between: selectedCards)
    }
}
