//
//  ContentView.swift
//  Set
//
//  Created by Cassie Wallace on 9/20/22.
//

import SwiftUI

struct ShapeSetGameView: View {
    // MARK: Public Var(s)
    @ObservedObject var shapeSetGame: ShapeSetGame
    
    var body: some View {
        NavigationView {
            VStack {
                gameBody
                HStack(spacing: 30) {
                    undealtBody
                    discardBody
                }
            }
            .padding(.horizontal)
            .navigationBarTitle("Set", displayMode: .inline)
            .navigationBarItems(leading:
                Button {
                        newGame()
                for cardToDeal in cardsToDeal.prefix(12) {
                    withAnimation(dealAnimation(for: cardToDeal)) {
                        deal(cardToDeal)
                    }
                }
            } label: {
                    Text("New Game")
            })
        }
    }
    
    var gameBody: some View {
        AspectVGrid(items: shapeSetGame.cards.filter( { isDealt($0) && !isDiscarded($0) } ), aspectRatio: DrawingConstants.aspectRatio) { card in
                Card(card: card, isFaceUp: isDealt(card), isSelected: isSelected(card), isDiscarded: isDiscarded(card), match: $match, mismatch: $mismatch)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(DrawingConstants.cardPadding)
                    .onTapGesture {
                        withAnimation {
                            select(card)
                        }
                    }
            }
    }
    
    var undealtBody: some View {
        Deck(gameView: self, cards: shapeSetGame.cards.filter( { !isDealt($0) }), match: $match, mismatch: $mismatch, setZIndex: true, cardNamespace: dealingNamespace)
        .frame(width: DrawingConstants.deckWidth, height: DrawingConstants.deckHeight)
        .onTapGesture {
            withAnimation(Animation.linear.delay(0.5)) {
                discard()
            }
            cardsToDeal = shapeSetGame.cards.filter( { !isDealt($0) && !$0.isMatched } )
            for cardToDeal in cardsToDeal.prefix(dealt.count == 0 ? 12 : 3) {
                withAnimation(dealAnimation(for: cardToDeal)) {
                    deal(cardToDeal)
                }
            }
        }
    }
    
    var discardBody: some View {
        Deck(gameView: self, cards: shapeSetGame.cards.filter(isDiscarded), match: $match, mismatch: $mismatch, setZIndex: true, cardNamespace: dealingNamespace)
        .frame(width: DrawingConstants.deckWidth, height: DrawingConstants.deckHeight)
    }
    
    // MARK: Private Var(s)
    // TODO: Can I use a state object? This is getting unruly.
    @State private var dealt = Set<Int>()
    @State private var discardedCards = Set<Int>()
    @State private var cardsToDeal = [ShapeSetGame.Card]()
    @State private var selectedCards = [ShapeSetGame.Card]()
    @State private var match: Bool = false
    @State private var mismatch: Bool = false
    @Namespace private var dealingNamespace
    
    private struct DrawingConstants {
        static let aspectRatio: CGFloat = 2/3
        static let cardPadding: CGFloat = 5
        static let deckHeight: CGFloat = 90
        static let deckWidth: CGFloat = deckHeight * aspectRatio
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
    }
    
    // MARK: Public Func(s)
    func isSelected(_ card: ShapeSetGame.Card) -> Bool {
        if selectedCards.index(matching: card) != nil {
            return true
        } else {
            return false
        }
    }
    
    func isDealt(_ card: ShapeSetGame.Card) -> Bool {
        dealt.contains(card.id)
    }
    
    func isMatched(_ card: ShapeSetGame.Card) -> Bool {
        if let index = shapeSetGame.cards.index(matching: card) {
            return shapeSetGame.cards[index].isMatched
        }
        return false
    }
    
    func isDiscarded(_ card: ShapeSetGame.Card) -> Bool {
        discardedCards.contains(card.id)
    }
    
    // MARK: Private Func(s)
    private func newGame() {
        (selectedCards, discardedCards, dealt) = ([], [], [])
        shapeSetGame.startNewGame()
        cardsToDeal = shapeSetGame.cards.filter( { !isDealt($0) && !$0.isMatched } )
    }
    
    private func select(_ card: ShapeSetGame.Card) {
        mismatch = false
    
        discard()
        
        if selectedCards.count < 3 {
            if !isSelected(card) {
                selectedCards.append(card)
            } else if isSelected(card) {
                let indexOfSelectedCard = selectedCards.index(matching: card)!
                selectedCards.remove(at: indexOfSelectedCard)
            }
        }
        
        if selectedCards.count == 3 {
            if shapeSetGame.checkForMatch(between: selectedCards) {
                shapeSetGame.handleMatch(between: selectedCards)
                match = true
                
            } else {
                mismatch = true
            }
        }
    }

    private func deal(_ card: ShapeSetGame.Card) {
        dealt.insert(card.id)
    }
    
    private func dealAnimation(for card: ShapeSetGame.Card) -> Animation {
        var delay = 0.0
        if let index = shapeSetGame.cards.index(matching: card) {
            delay = Double(index) * (DrawingConstants.totalDealDuration / Double(shapeSetGame.cards.count))
        }
        return Animation.easeInOut(duration: DrawingConstants.dealDuration).delay(delay)
    }
    
    private func discard() {
        if selectedCards.count == 3 {
            if match {
                match = false
                for selectedCard in selectedCards {
                    discardedCards.insert(selectedCard.id)
                }
            }
            selectedCards = []
        }
    }
}

// MARK: Preview(s)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
    let game = ShapeSetGame()
    return ShapeSetGameView(shapeSetGame: game)
        .previewDevice("iPhone 14")
    }
}
