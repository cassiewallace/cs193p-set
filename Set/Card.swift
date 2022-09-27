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
            cardOutline.fill().foregroundColor(.white)
            cardOutline.stroke(lineWidth: isSelected ? DrawingConstants.cardLineWidth * 3 : DrawingConstants.cardLineWidth)
        
            VStack {
                ForEach(0..<card.numberOfShapes + 1, id: \.self) { _ in
                shapeBuilder(shape: card.shape, fill: card.fill, color: shapeColor).frame(maxHeight:40)
                }
            }
            .foregroundColor(shapeColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            
            if card.isMatched {
                cardOutline.foregroundColor(.green)
                Text("Matched!")
            } else if mismatch && isSelected {
                cardOutline.stroke(.red)
            }
        }
    }
    
    private struct DrawingConstants {
        static let cardCornerRadius: CGFloat = 10
        static let cardLineWidth: CGFloat = 0.5
        static let shapeCornerRadius: CGFloat = 12
        static let shapeLineWidth: CGFloat = 2
    }
}
