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
                AspectVGrid(items: shapeSetGame.cardsInPlay, aspectRatio: DrawingConstants.aspectRatio) { card in
                        Card(card: card, isSelected: isSelected(card), mismatch: $mismatch)
                            .padding(DrawingConstants.cardPadding)
                            .onTapGesture {
                                select(card)
                            }
                    }
            }
            .padding(.horizontal)
            .navigationBarTitle("Set", displayMode: .inline)
            .navigationBarItems(leading:
                Button {
                    shapeSetGame.startNewGame()
                    selected = []
            } label: {
                    Text("New Game")
            })
            .navigationBarItems(trailing:
                Button {
                    shapeSetGame.dealCards(3)
                    shapeSetGame.clearCards()
                    selected = []
            } label: {
                    Text("Deal 3")
            }
            .disabled(shapeSetGame.numberOfCardsLeftToDeal == 0)
            )
        }
    }
    
    // MARK: Private Var(s)
    @State private var selected = [ShapeSetGame.Card]()
    @State private var mismatch: Bool = false
    
    private struct DrawingConstants {
        static let aspectRatio: CGFloat = 2/3
        static let cardPadding: CGFloat = 5
    }
    
    // MARK: Private Func(s)
    private func select(_ card: ShapeSetGame.Card) {
        shapeSetGame.clearCards()
        mismatch = false
    
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
}

// MARK: Preview(s)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
    let game = ShapeSetGame()
    return ShapeSetGameView(shapeSetGame: game)
        .previewDevice("iPhone 13")
    }
}
