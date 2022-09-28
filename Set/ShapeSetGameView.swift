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
                HStack {
                    deckBody
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
        AspectVGrid(items: shapeSetGame.cards.filter( { isDealt($0) && !$0.isMatched } ), aspectRatio: DrawingConstants.aspectRatio) { card in
                Card(card: card, isFaceUp: isDealt(card), isSelected: isSelected(card), match: $match, mismatch: $mismatch)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(DrawingConstants.cardPadding)
                    .onTapGesture {
                        withAnimation {
                            select(card)
                        }
                    }
            }
    }
    
    var deckBody: some View {
        // TODO: Refactor to deal with duplicated code with discardBody.
        ZStack {
            ForEach(shapeSetGame.cards.filter( { !isDealt($0) } )) { card in
                Card(card: card, isFaceUp: isDealt(card), isSelected: isSelected(card), match: $match,  mismatch: $mismatch)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .zIndex(zIndex(of: card))
            }
        }
        .frame(width: DrawingConstants.deckWidth, height: DrawingConstants.deckHeight)
        .onTapGesture {
            selected = []
            cardsToDeal = shapeSetGame.cards.filter( { !isDealt($0) && !$0.isMatched } )
            for cardToDeal in cardsToDeal.prefix(dealt.count == 0 ? 12 : 3) {
                withAnimation(dealAnimation(for: cardToDeal)) {
                    deal(cardToDeal)
                }
            }
        }
    }
    
    var discardBody: some View {
        ZStack {
            ForEach(shapeSetGame.cards.filter(isMatched)) { card in
                Card(card: card, isFaceUp: isDealt(card), isSelected: isSelected(card), match: $match, mismatch: $mismatch)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .zIndex(zIndex(of: card))
            }
        }
        .frame(width: DrawingConstants.deckWidth, height: DrawingConstants.deckHeight)
        .foregroundStyle(.black)
    }
    
    // MARK: Private Var(s)
    @State private var selected = [ShapeSetGame.Card]()
    @State private var cardsToDeal = [ShapeSetGame.Card]()
    @State private var match: Bool = false
    @State private var mismatch: Bool = false
    @State private var dealt = Set<Int>()
    @Namespace private var dealingNamespace
    
    private struct DrawingConstants {
        static let aspectRatio: CGFloat = 2/3
        static let cardPadding: CGFloat = 5
        static let deckHeight: CGFloat = 90
        static let deckWidth: CGFloat = deckHeight * aspectRatio
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
    }
    
    // MARK: Private Func(s)
    private func newGame() {
        selected = []
        dealt = []
        shapeSetGame.startNewGame()
        cardsToDeal = shapeSetGame.cards.filter( { !isDealt($0) && !$0.isMatched } )
    }
    
    private func select(_ card: ShapeSetGame.Card) {
        mismatch = false
        match = false
    
        if selected.count == 3 {
            selected = []
        }
        
        if selected.count < 3 {
            if !isSelected(card) {
                selected.append(card)
            } else if isSelected(card) {
                let indexOfSelectedCard = selected.firstIndex(where: { $0.id == card.id })!
                selected.remove(at: indexOfSelectedCard)
            }
        }
        
        if selected.count == 3 {
            if shapeSetGame.checkForMatch(between: selected) {
                shapeSetGame.handleMatch(between: selected)
                match = false
            } else {
                mismatch = true
            }
        }
    }
    
    private func isSelected(_ card: ShapeSetGame.Card) -> Bool {
        if selected.firstIndex(where: { $0.id == card.id }) != nil {
            return true
        } else {
            return false
        }
    }

    private func deal(_ card: ShapeSetGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isDealt(_ card: ShapeSetGame.Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: ShapeSetGame.Card) -> Animation {
        var delay = 0.0
        if let index = shapeSetGame.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (DrawingConstants.totalDealDuration / Double(shapeSetGame.cards.count))
        }
        return Animation.easeInOut(duration: DrawingConstants.dealDuration).delay(delay)
    }
    
    private func isMatched(_ card: ShapeSetGame.Card) -> Bool {
        if let index = shapeSetGame.cards.firstIndex(where: { $0.id == card.id }) {
            return shapeSetGame.cards[index].isMatched
        }
        return false
    }
    
    private func zIndex(of card: ShapeSetGame.Card) -> Double {
        -Double(shapeSetGame.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
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
