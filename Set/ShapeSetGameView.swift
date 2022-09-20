//
//  ContentView.swift
//  Set
//
//  Created by Cassie Wallace on 9/20/22.
//

import SwiftUI

struct ShapeSetGameView: View {
    @ObservedObject var shapeSetGame: ShapeSetGame
    
    var body: some View {
        NavigationView {
            VStack {
                AspectVGrid(items: shapeSetGame.cardsInPlay, aspectRatio: DrawingConstants.aspectRatio) { card in
                        Card(card: card)
                            .padding(DrawingConstants.cardPadding)
                            .onTapGesture{
                                shapeSetGame.select(card)
                            }
                    }
            }
            .padding(.horizontal)
            .navigationBarTitle("Set", displayMode: .inline)
            .navigationBarItems(leading:
                Button {
                    shapeSetGame.startNewGame()} label: {
                    Text("New Game")
            })
            .navigationBarItems(trailing:
                Button {
                    shapeSetGame.dealCards(3)} label: {
                    Text("Deal 3")
            }
            .disabled(shapeSetGame.numberOfCardsLeftToDeal == 0)
            )
        }
    }
    
    private struct DrawingConstants {
        static let aspectRatio: CGFloat = 2/3
        static let cardPadding: CGFloat = 5
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
    let game = ShapeSetGame()
    return ShapeSetGameView(shapeSetGame: game)
        .previewDevice("iPhone 13")
    }
}
