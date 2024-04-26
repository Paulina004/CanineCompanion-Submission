//
//  CarouselViewModel.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/7/24.
//

import Foundation
import SwiftUI

class CarouselViewModel: ObservableObject {
    @Published var cards = [
        Card(cardColor: Color(hex: 0x7975F7), title: "View and record important information about your pet.", subtitle: "Home Screen"),
        Card(cardColor: Color(hex: 0xFE5C12), title: "Chat with an AI assistant to answer your dog care questions.", subtitle: "Chat Screen"),
        Card(cardColor: Color(hex: 0xFFB63C), title: "Find the nearest dog parks to your local vicinity.", subtitle: "Map Screen"),
        Card(cardColor: Color(hex: 0x7975F7), title: "Register or delete pets on your account, update your password, sign out, & delete your account.", subtitle: "Settings Screen")
    ]
    @Published var swipedCard = 0
}
