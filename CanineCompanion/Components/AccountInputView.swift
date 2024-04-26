//
//  AccountInputView.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 3/27/24.
//

import SwiftUI


struct AccountInputView: View {
    @Binding var text: String
    let placeholder: String
    @State var isSecureField = false
    
    var body: some View {
        
        if isSecureField {
            SecureField(placeholder, text: $text)
                .font(.title3)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .foregroundColor(Color(hex: 0x373E4E))
                .cornerRadius(20)
                //.shadow(color: Color.black.opacity(0.3), radius: 5, x:4, y:4)
                .padding(.horizontal, 40)
        } else {
            TextField(placeholder, text: $text)
                .font(.title3)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .foregroundColor(Color(hex: 0x373E4E))
                .cornerRadius(20)
                //.shadow(color: Color.black.opacity(0.3), radius: 5, x:4, y:4)
                .padding(.horizontal, 40)
        }
    }
}

#Preview {
    AccountInputView(text: .constant(""), placeholder: "Placeholder")
}
