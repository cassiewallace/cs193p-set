//
//  SetGame.swift
//  Set
//
//  Created by Cassie Wallace on 9/20/22.
//

import Foundation

struct SetGame<CardContent> where CardContent: Equatable {
    // MARK: Private Var(s)
    private(set) var cards: Array<Card>

    // MARK: Init(s)
    init() {
        cards = []
    }
    
    struct Card: Identifiable {
        let content = "Placeholder"
        let id: Int
    }
    
}
