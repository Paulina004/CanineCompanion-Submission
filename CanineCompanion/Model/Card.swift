//
//  Card.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/7/24.
//

import Foundation
import SwiftUI

struct Card: Identifiable {
    var id = UUID().uuidString
    var cardColor: Color
    var offset: CGFloat = 0
    var title: String
    var subtitle: String
}
