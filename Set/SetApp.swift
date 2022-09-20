//
//  SetApp.swift
//  Set
//
//  Created by Cassie Wallace on 9/20/22.
//

import SwiftUI

@main
struct SetApp: App {
    private let game = ShapeSetGame()
    
    var body: some Scene {
        WindowGroup {
            ShapeSetGameView(shapeSetGame: game)
        }
    }
}
