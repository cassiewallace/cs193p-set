//
//  CardCircle.swift
//  Set
//
//  Created by Cassie Wallace on 10/2/22.
//

import SwiftUI

extension Circle {

    @ViewBuilder
    static func helperBuilder(color: Color, fill: FillType, lineWidth: CGFloat) -> some View {
        switch fill {
        case .empty: Circle()
                    .stroke(lineWidth: lineWidth)
                    .foregroundColor(color)
        case .shaded: Circle().strokeBorder(lineWidth: lineWidth)
                    .background(Circle()
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.white, color],
                                startPoint: .top,
                                endPoint: .bottom
                            )))
                    .foregroundColor(color)
        case .solid: Circle()
                    .fill()
                    .foregroundColor(color)
        }
    }

}
