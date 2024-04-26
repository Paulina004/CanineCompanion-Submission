//
//  CardView.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/7/24.
//

import SwiftUI


struct CardView: View {
    @ObservedObject var carouselViewModel: CarouselViewModel
    var card: Card
    
    public init(carouselViewModel: CarouselViewModel, card: Card) {
        self.carouselViewModel = carouselViewModel
        self.card = card
    }
    
    var body: some View {
        VStack {
            Text(card.subtitle)
                .font(.caption)
                .foregroundColor(Color.white.opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.top, 10)
            Text(card.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .frame(alignment: .leading)
                .padding()
            Spacer(minLength: 0)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(card.cardColor)
        .cornerRadius(25)
    }
}

//#Preview {
//    CardView(carouselViewModel: CarouselViewModel)
//}
