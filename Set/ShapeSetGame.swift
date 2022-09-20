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
    
    var cards: Array<Card> {
        return setGameModel.cards
    }
    
    // Enable the ShapeSetGameView to only display cards that are
    // currently in play.
    var cardsInPlay: Array<Card> {
        return setGameModel.cardsInPlay
    }
    
    var numberOfCardsLeftToDeal: Int {
        return setGameModel.numberOfCardsLeftToDeal
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
    
    func select(_ card: Card) {
        setGameModel.select(card)
    }
    
    // Deals a specific number of cards.
    func dealCards(_ numberOfCards: Int) {
        setGameModel.dealCards(numberOfCards)
    }
}

