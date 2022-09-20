//
//  SetGame.swift
//  Set
//
//  Created by Cassie Wallace on 9/20/22.
//

import Foundation
    
protocol SetCard {
    
}

struct SetGame<CardContent> where CardContent: Equatable {
    // MARK: Private Var(s)
    private(set) var cards: Array<Card>

    // MARK: Init(s)
    init(cardTypes: [CardContent]) {
        cards = []
        for tripleIndex in 0...2 {
            let content = cardTypes[tripleIndex]
            cards.append(Card(content: content, id: tripleIndex*3))
            cards.append(Card(content: content, id: tripleIndex*3+1))
            cards.append(Card(content: content, id: tripleIndex*3+2))
        }
    }
    
    struct Card: Identifiable {
        let content: CardContent
        let id: Int
    }
    
}
