//
//  UtilityExtensions.swift
//  Set
//
//  Created by Cassie Wallace on 9/29/22.
//

import Foundation

extension Array where Element: Identifiable {
    func index(matching element: Element) -> Int? {
        return firstIndex(where: { $0.id == element.id })
    }
}
