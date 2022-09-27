//
//  SetGame.swift
//  Set
//
//  Created by Cassie Wallace on 9/20/22.
//

import Foundation

struct SetGame {
    // MARK: Private Var(s)
    private(set) var cards: Array<Card> = []
    private(set) var numberOfCardsLeftToDeal: Int = 0
    
    // MARK: Public Var(s)
    var cardsInPlay: Array<Card> {
        return cards.filter( { $0.isInPlay } )
    }
    
    // MARK: Public Var(s)
    enum ShapeType: Int, CaseIterable {
        case circle
        case diamond
        case squiggle
    }
    
    enum ColorType: Int, CaseIterable {
        case green
        case purple
        case red
    }
    
    enum FillType: Int, CaseIterable {
        case empty
        case shaded
        case solid
    }
    
    // MARK: Public Func(s)
    func isValidMatch(c1: Card, c2: Card, c3: Card) -> Bool {
        return (c1.shape.rawValue + c2.shape.rawValue + c3.shape.rawValue) % 3 == 0
            && (c1.color.rawValue + c2.color.rawValue + c3.color.rawValue) % 3 == 0
            && (c1.fill.rawValue + c2.fill.rawValue + c3.fill.rawValue) % 3 == 0
            && (c1.numberOfShapes + c2.numberOfShapes + c3.numberOfShapes) % 3 == 0
    }
    
    mutating func handleMatch(between selectedCards: [ShapeSetGame.Card]) {
        guard isValidMatch(c1: selectedCards[0], c2: selectedCards[1], c3: selectedCards[2]) else {
            return
        }
        
        for selectedCard in selectedCards {
            if let selectedCardIndex = cards.firstIndex(where: { $0.id == selectedCard.id }) {
                    cards[selectedCardIndex].isMatched = true
            }
        }
    }
    
    mutating func clearCards() {
        let matchedCardsOnTheBoard = cards.filter( { $0.isMatched && $0.isInPlay } )
        
        for card in matchedCardsOnTheBoard {
            if let index = cards.firstIndex(where: { $0.id == card.id } ) {
                    cards[index].isInPlay = false
            }
        }
        
        if cardsInPlay.count < 12 {
            dealCards(3)
        }
    }
    
    // Marks the next 3 cards as in play and decrement the number of cards left to distribute.
    mutating func dealCards(_ numberOfCards: Int) {
        if let index = cards.firstIndex(where: { $0.isInPlay == false && $0.isMatched == false } ) {
            for index in index..<(index + numberOfCards) {
                cards[index].isInPlay = true
            }
            numberOfCardsLeftToDeal -= numberOfCards
        }
    }
    
    // Creates a deck of cards with 4 dimensions.
    mutating func createSetGameDeck() -> Array<Card> {
        var cardIndex = 0
        cards = []
        for shapeType in ShapeType.allCases {
            for colorType in ColorType.allCases {
                for fillType in FillType.allCases {
                    for numberOfShapes in 0..<3 {
                        cards.append(Card(
                            shape: shapeType,
                            color: colorType,
                            fill: fillType,
                            numberOfShapes: numberOfShapes,
                            id: cardIndex))
                        cardIndex += 1
                    }
                }
            }
        }
        numberOfCardsLeftToDeal = 81
        return cards
    }

    // MARK: Init(s)
    init() {
        cards = createSetGameDeck()
        cards.shuffle()
        dealCards(12)
    }
    
    struct Card: Identifiable {
        var isInPlay = false
        var isMatched = false
        let shape: ShapeType
        let color: ColorType
        let fill: FillType
        let numberOfShapes: Int
        let id: Int
    }
}
