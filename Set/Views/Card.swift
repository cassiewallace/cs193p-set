//
//  Card.swift
//  Set
//
//  Created by Cassie Wallace on 9/20/22.
//

import SwiftUI

struct Card: View {
    // MARK: - Public Var(s)
    
    let card: ShapeSetGame.Card
    var isDealt: Bool
    var isSelected: Bool
    var isDiscarded: Bool
    @Binding public var match: Bool
    @Binding public var mismatch: Bool
    
    // MARK: Private Var(s)
    
    private var numberOfShapes: Int {
        return card.numberOfShapes
    }
    
    private var shapeColor: Color {
        switch card.color {
            case .green: return .green
            case .purple: return .purple
            case .red: return .red
        }
    }
    
    private var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    private var rotation: Double
    
    private struct DrawingConstants {
        static let cardCornerRadius: CGFloat = 10
        static let cardLineWidth: CGFloat = 0.5
        static let shapeCornerRadius: CGFloat = 12
        static let shapeLineWidth: CGFloat = 2
        static let shapeMaxWidth: CGFloat = 80
        static let shapeMaxHeight: CGFloat = 40
    }
    
    // MARK: Init(s)
    
    init(card: ShapeSetGame.Card, isDealt: Bool, isSelected: Bool, isDiscarded: Bool, match: Binding<Bool>, mismatch: Binding<Bool>) {
        rotation = isDealt ? 0 : 180
        self.isDealt = isDealt
        self.isSelected = isSelected
        self.isDiscarded = isDiscarded
        self.card = card
        _match = match
        _mismatch = mismatch
    }
    
    // MARK: Public Func(s)
    
    @ViewBuilder
    func shapeBuilder(shape: ShapeType, fill: FillType, color: Color) -> some View {
        switch shape {
            case .circle: Circle.helperBuilder(color: color, fill: fill, lineWidth: DrawingConstants.shapeLineWidth)
            case .diamond: Diamond.helperBuilder(color: color, fill: fill, lineWidth: DrawingConstants.shapeLineWidth)
            case .squiggle: RoundedRectangle.helperBuilder(color: color, fill: fill, cornerRadius: DrawingConstants.shapeCornerRadius, lineWidth: DrawingConstants.shapeLineWidth, shapeMaxWidth: DrawingConstants.shapeMaxWidth, shapeMaxHeight: DrawingConstants.shapeMaxHeight)
        }
        
}
    
    var body: some View {
        ZStack {
            let cardOutline = RoundedRectangle(cornerRadius: DrawingConstants.cardCornerRadius)
            
            if rotation < 90 {
                cardOutline.fill().foregroundColor(.white)
            } else {
                if #available(iOS 16.0, *) {
                    cardOutline.fill(Gradient(colors: [.blue, .black]))
                    
                } else {
                    cardOutline.fill(.gray)
                }
            }
            
            cardOutline.stroke(lineWidth: isSelected ? DrawingConstants.cardLineWidth * 3 : DrawingConstants.cardLineWidth)
            
            if isSelected {
                if match {
                    cardOutline.foregroundColor(.green).opacity(0.4)
                } else if mismatch {
                    cardOutline.stroke(.red)
                }
            }
            
            VStack {
                ForEach(0..<card.numberOfShapes + 1, id: \.self) { _ in
                    shapeBuilder(shape: card.shape, fill: card.fill, color: shapeColor)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .opacity(rotation < 90 ? 1 : 0)
        }
    }
}
