//
//  ShapeSetGame.swift
//  Set
//
//  Created by Cassie Wallace on 9/20/22.
//

import Foundation

class ShapeSetGame: ObservableObject {
    // MARK: Public Var(s)
    typealias Card = SetGame<String>.Card
    
    var cards: Array<Card> {
        return setGameModel.cards
    }
    
    // MARK: Private Var(s)
    @Published private var setGameModel: SetGame<String>
    
    // MARK: Init(s)
    init() {
        setGameModel = Self.createSetGame()
    }
    
    // MARK: Private Static Func(s)
    private static func createSetGame() -> SetGame<String> {
        let themeModel = GameTheme()
        
        let shapes = themeModel.shapes
    
        return SetGame<String>(cardTypes: shapes)
    }
    
}
