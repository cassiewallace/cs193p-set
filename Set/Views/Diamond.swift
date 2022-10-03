//
//  Diamond.swift
//  Memorize
//
//  Created by Cassie Wallace on 9/21/22.
//

import SwiftUI

struct Diamond: Shape {
    
    @ViewBuilder
    static func helperBuilder(color: Color, fill: FillType, lineWidth: CGFloat) -> some View {
        switch fill {
            case .empty: Diamond().stroke(lineWidth: lineWidth)
                .foregroundColor(color)
            case .shaded: Diamond().stroke(lineWidth: lineWidth)
                    .background(Diamond()
                        .foregroundStyle(
                            .linearGradient(
                                colors: [.white, color],
                                startPoint: .top,
                                endPoint: .bottom
                            )))
                .foregroundColor(color)
            case .solid: Diamond()
                .fill()
                .foregroundColor(color)
        }
    }

    func path(in rect: CGRect) -> Path {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        var p = Path()
        p.move(to: CGPoint(x: center.x, y: center.y + radius * 0.8
        ))
        p.addLine(to: CGPoint(x: center.x + radius * 1.2, y: center.y))
        p.addLine(to: CGPoint(x: center.x, y: center.y - radius * 0.8))
        p.addLine(to: CGPoint(x: center.x - radius * 1.2, y: center.y))
        p.addLine(to: CGPoint(x: center.x, y: center.y + radius * 0.8))
        
        return p
    }
    
}
