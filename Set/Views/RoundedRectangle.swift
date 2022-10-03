//
//  RoundedRectangle.swift
//  Set
//
//  Created by Cassie Wallace on 10/2/22.
//

import SwiftUI

extension RoundedRectangle {
    
    @ViewBuilder
    static func helperBuilder(color: Color, fill: FillType, cornerRadius: CGFloat, lineWidth: CGFloat, shapeMaxWidth: CGFloat, shapeMaxHeight: CGFloat) -> some View {
        switch fill {
        case .empty: RoundedRectangle(cornerRadius:
            cornerRadius)
            .stroke(lineWidth: lineWidth)
            .foregroundColor(color)
            .frame(maxWidth: shapeMaxWidth, maxHeight: shapeMaxHeight)
        case .shaded: RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(lineWidth: lineWidth)
                    .background(RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.white, color],
                                startPoint: .top,
                                endPoint: .bottom
                            )))
                            .foregroundColor(color)
                            .frame(maxWidth: shapeMaxWidth, maxHeight: shapeMaxHeight)
        case .solid: RoundedRectangle(cornerRadius: cornerRadius)
                    .fill()
                    .foregroundColor(color)
                    .frame(maxWidth: shapeMaxWidth, maxHeight: shapeMaxHeight)
        }
    }
}
