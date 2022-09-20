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
            // Started here with the AspectVGrid from class, but I might actually want to
            // go back to a simpler fixed-column setup like the real game uses.
                AspectVGrid(items: shapeSetGame.cards, aspectRatio: DrawingConstants.aspectRatio) { card in
                        Card(card: card)
                            .padding(DrawingConstants.cardPadding)
                    }
                Text("Set Game time!")
            }
            .padding(.horizontal)
            .navigationBarTitle("Set", displayMode: .inline)
            .navigationBarItems(leading:
                Button {} label: {
                    Text("New Game")
            })
            .navigationBarItems(trailing:
                Button {} label: {
                    Text("Deal 3")
            })
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
