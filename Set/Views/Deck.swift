//
//  Deck.swift
//  Set
//
//  Created by Cassie Wallace on 9/29/22.
//

import SwiftUI

struct Deck: View {
    // MARK: Public Var(s)
    @Binding public var match: Bool
    @Binding public var mismatch: Bool
    let cards: Array<SetGame.Card>
    let gameView: ShapeSetGameView
    let setZIndex: Bool
    let cardNamespace: Namespace.ID

    var body: some View {
        ZStack {
            ForEach(cards) { card in
                Card(card: card, isFaceUp: gameView.isDealt(card), isSelected: gameView.isSelected(card), isDiscarded: gameView.isDiscarded(card), match: $match,  mismatch: $mismatch)
                .if(setZIndex) { view in
                    view.zIndex(zIndex(of: card))
                }
                .matchedGeometryEffect(id: card.id, in: cardNamespace)
            }
        }
    }
    
    // MARK: Private Func(s)
    private func zIndex(of card: ShapeSetGame.Card) -> Double {
        -Double(cards.index(matching: card) ?? 0)
    }
    
    // MARK: Init(s)
    init(gameView: ShapeSetGameView, cards: Array<SetGame.Card>, match: Binding<Bool>, mismatch: Binding<Bool>, setZIndex: Bool, cardNamespace: Namespace.ID) {
        self.gameView = gameView
        self.cards = cards
        _match = match
        _mismatch = mismatch
        self.setZIndex = setZIndex
        self.cardNamespace = cardNamespace
    }
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
            if condition {
                transform(self)
            } else {
                self
            }
    }
}
