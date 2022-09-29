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
    var isSelected: Bool
    var isDiscarded: Bool
    @Binding public var match: Bool
    @Binding public var mismatch: Bool
    
    var numberOfShapes: Int {
        return card.numberOfShapes
    }
    
    var shapeColor: Color {
        switch card.color {
            case .green: return .green
            case .purple: return .purple
            case .red: return .red
        }
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    var rotation: Double // in degrees
    
    // MARK: Private Var(s)
    private struct DrawingConstants {
        static let cardCornerRadius: CGFloat = 10
        static let cardLineWidth: CGFloat = 0.5
        static let shapeCornerRadius: CGFloat = 12
        static let shapeLineWidth: CGFloat = 2
    }
    
    // MARK: Public Func(s)
    @ViewBuilder
    func shapeBuilder(shape: SetGame.ShapeType, fill: SetGame.FillType, color: Color) -> some View {

        let shapeFillCombo = (shape, fill)

        switch shapeFillCombo {
            case (.circle, .empty):
                Circle().stroke(lineWidth: DrawingConstants.shapeLineWidth)
            case (.diamond, .empty):
                Diamond().stroke(lineWidth: DrawingConstants.shapeLineWidth)
            case (.squiggle, .empty):
                RoundedRectangle(cornerRadius: DrawingConstants.shapeCornerRadius).stroke(lineWidth: DrawingConstants.shapeLineWidth)
                    .frame(maxWidth: 80, maxHeight: 40)
            case (.circle, .solid):
                Circle().fill()
            case (.diamond, .solid):
                Diamond().fill()
            case (.squiggle, .solid):
                RoundedRectangle(cornerRadius: DrawingConstants.shapeCornerRadius)
                    .fill()
                    .frame(maxWidth: 80, maxHeight: 40)
            case (.circle, .shaded):
                Circle().strokeBorder(lineWidth: DrawingConstants.shapeLineWidth)
                    .background(Circle()
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.white, color],
                                startPoint: .top,
                                endPoint: .bottom
                            )))
            case (.diamond, .shaded):
                Diamond().stroke(lineWidth: DrawingConstants.shapeLineWidth)
                    .background(Diamond()
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.white, color],
                                startPoint: .top,
                                endPoint: .bottom
                            )))
            case (.squiggle, .shaded):
                RoundedRectangle(cornerRadius: DrawingConstants.shapeCornerRadius)
                    .strokeBorder(lineWidth: DrawingConstants.shapeLineWidth)
                    .background(RoundedRectangle(cornerRadius: DrawingConstants.shapeCornerRadius)
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.white, color],
                                startPoint: .top,
                                endPoint: .bottom
                            )))
                    .frame(maxWidth: 80, maxHeight: 40)
    }
}
    
    var body: some View {
        ZStack {
            let cardOutline = RoundedRectangle(cornerRadius: DrawingConstants.cardCornerRadius)
            cardOutline.fill().foregroundColor(rotation < 90 ? .white : .gray)
            cardOutline.stroke(lineWidth: isSelected ? DrawingConstants.cardLineWidth * 3 : DrawingConstants.cardLineWidth)
        
            VStack {
                ForEach(0..<card.numberOfShapes + 1, id: \.self) { _ in
                    shapeBuilder(shape: card.shape, fill: card.fill, color: shapeColor).frame(maxHeight:40)
                    .opacity(rotation < 90 ? 1 : 0)
                }
            }
            .foregroundColor(shapeColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            
            if isSelected {
                if match {
                    cardOutline.foregroundColor(.green).opacity(0.4)
                } else if mismatch {
                    cardOutline.stroke(.red)
                }
            }
        }
        // TODO: Fix the fact that this is moving everytime any card is modified.
        .rotationEffect(Angle.degrees(isDiscarded ? Double.random(in: -30...30) : 0))
        // TODO: Get the flip working.
        // .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
    
    // MARK: Init(s)
    init(card: ShapeSetGame.Card, isFaceUp: Bool, isSelected: Bool, isDiscarded: Bool, match: Binding<Bool>, mismatch: Binding<Bool>) {
        rotation = isFaceUp ? 0 : 180
        self.isSelected = isSelected
        self.isDiscarded = isDiscarded
        self.card = card
        _match = match
        _mismatch = mismatch
    }
}
