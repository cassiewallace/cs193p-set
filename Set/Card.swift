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
    
    // QUESTION: I did it this way because if you split it into 2 ViewBuilders, the Shape one has to return `some View`, and then you can't use `ViewModifier`s like `.stroke` and `.fill()`, which are only available on `Shape`, and then it starts getting messy. Would another mechanism help here?
    // QUESTION: Can I move this up to the ShapeSetGame, or recreate a ViewModel for Cards specifically? Right now, the View is communicating directly with the model. But it also does that for other things technically?
    @ViewBuilder
    func shapeBuilder(shape: SetGame.ShapeType, fill: SetGame.FillType, color: Color) -> some View {

        let shapeFillCombo = (shape, fill)

        switch shapeFillCombo {
            case (.circle, .empty):
                Circle().stroke(lineWidth: 2)
            case (.diamond, .empty):
                Diamond().stroke(lineWidth: 2)
            case (.squiggle, .empty):
                RoundedRectangle(cornerRadius: 2).stroke(lineWidth: 2)
            case (.circle, .solid):
                Circle().fill()
            case (.diamond, .solid):
                Diamond().fill()
            case (.squiggle, .solid):
                RoundedRectangle(cornerRadius: 2).fill()
            case (.circle, .shaded):
                Circle().strokeBorder(lineWidth: 2)
                    .background(Circle()
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.white, color],
                                startPoint: .top,
                                endPoint: .bottom
                            )))
            case (.diamond, .shaded):
                Diamond().stroke(lineWidth: 2)
                    .background(Diamond()
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.white, color],
                                startPoint: .top,
                                endPoint: .bottom
                            )))
            case (.squiggle, .shaded):
                RoundedRectangle(cornerRadius: 2).strokeBorder(lineWidth: 2)
                    .background(RoundedRectangle(cornerRadius: 2)
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.white, color],
                                startPoint: .top,
                                endPoint: .bottom
                            )))
    }
}
    
    var body: some View {
        ZStack {
            let cardOutline = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            cardOutline.fill().foregroundColor(.white)
            cardOutline.stroke(lineWidth: card.isCurrentlySelected ? DrawingConstants.lineWidth * 3 : DrawingConstants.lineWidth)
        
            VStack {
                ForEach(0..<card.numberOfShapes + 1, id: \.self) { _ in
                shapeBuilder(shape: card.shape, fill: card.fill, color: shapeColor).frame(maxHeight:40)
                }
            }
            .foregroundColor(shapeColor)
            .padding(15)
            
            if card.isMatched {
                cardOutline.foregroundColor(.green)
                Text("Matched!")
            }
        }
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 0.5
    }
}
