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
    
    //  QUESTION: What is the difference between Array<Card> and [ Card ]?
    private var selectedCards: [ Card ] {
        return cards.filter( { $0.isCurrentlySelected } )
    }
    
    // MARK: Public Var(s)
    var cardsInPlay: Array<Card> {
        return cards.filter( { $0.isInPlay } )
    }
    
    var selectionCount: Int {
        return selectedCards.count
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
    
    mutating func handleMatch() {
        if selectedCards.count == 3 {
            let playStatus = isValidMatch(c1: selectedCards[0], c2: selectedCards[1], c3: selectedCards[2]) ? false : true
            
            for selectedCard in selectedCards {
               if let selectedCardIndex = cards.firstIndex(where: { $0.id == selectedCard.id }) {
                    cards[selectedCardIndex].isCurrentlySelected = false
                    cards[selectedCardIndex].isInPlay = playStatus
                }
            }
        }
    }

    mutating func select(_ card: Card) {
        handleMatch()
        
        if cardsInPlay.count < 12 {
            dealCards(3)
        }
        
        // Sets a chosenIndex to the index in the current array when the chosen card is.
        // If we simply use the id of the selected card (n = card.id), the nth currently displayed card will be selected. Instead, we want to find the id of the card in the current array, and set that card to selected.
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if selectionCount < 3 {
                cards[chosenIndex].isCurrentlySelected.toggle()
            }
            
            if selectionCount == 3 {
                if isValidMatch(c1: selectedCards[0], c2: selectedCards[1], c3: selectedCards[2]){
                    for selectedCard in selectedCards {
                        if let selectedCardIndex = cards.firstIndex(where: { $0.id == selectedCard.id }) {
                                cards[selectedCardIndex].isMatched = true
                        }
                    }
                } else {
                    print("It's not a match.")
                    // TODO: Show a mismatch.
                    // QUESTION: Need help on how to do this.
                    // QUESTION: General cleanup.
                }
            }
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
        var isCurrentlySelected = false
        var isMatched = false
        let shape: ShapeType
        let color: ColorType
        let fill: FillType
        let numberOfShapes: Int
        let id: Int
    }
}
