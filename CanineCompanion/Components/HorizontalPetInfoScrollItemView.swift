//
//  HorizontalPetInfoScrollItemView.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/3/24.
//

import SwiftUI

struct HorizontalPetInfoScrollItemView: View {
    
    let imageName: String
    let title: String
    let petInfoData: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: imageName)
                .imageScale(.medium)
                .foregroundColor(Color(.white))
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(petInfoData)
                    .font(.footnote)
                    .foregroundColor(Color(.white))
            }
            Spacer()
        }
        .padding(10)
        .frame(width: 140, height: 80)
        .background(color)
        .cornerRadius(15)
    }
}

#Preview {
    HorizontalPetInfoScrollItemView(imageName: "gear", title: "Test", petInfoData: "Other Test", color: Color(hex: 0xFE5C12))
}
