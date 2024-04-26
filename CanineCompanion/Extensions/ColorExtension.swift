//
//  ColorExtension.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 3/21/24.
//

import Foundation
import SwiftUI



extension Color {
    init(hex: UInt) {
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0x00FF00) >> 8) / 255.0
        let blue = Double(hex & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}
