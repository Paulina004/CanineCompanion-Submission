//
//  CustomModifiers.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 3/21/24.
//

import Foundation
import SwiftUI



struct AccountScreenTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .fontWeight(.bold)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .foregroundColor(Color(hex: 0x6A2956))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.3), radius: 5, x:4, y:4)
            .padding(.horizontal, 40)
    }
}


extension View {
    func accountScreenTextFieldStyle() -> some View {
        self.modifier(AccountScreenTextFieldStyle())
    }
}
