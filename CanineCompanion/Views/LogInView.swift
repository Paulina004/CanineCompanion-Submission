//
//  LogInView.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 3/18/24.
//

import SwiftUI


// MARK: - Log In View
struct LogInView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        ZStack {
            Color(hex: 0xFFB63C).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 25) {
                AccountInputView(text: $email, placeholder: "Email")
                    .autocapitalization(.none)
                AccountInputView(text: $password, placeholder: "Password", isSecureField: true)
                    .autocapitalization(.none)
                
                Button(action: {
                    Task {
                        try await viewModel.signIn(withEmail: email, password: password)
                    }
                }) {
                    Text("Log In")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.white)
                        .background(Color(hex: 0x6A2956))
                        .cornerRadius(20)
                        .padding(.horizontal, 40)
                        .disabled(!formIsValid)  // if form is not valid, button will not perform action (create user)
                        .opacity(formIsValid ? 1.0 : 0.5)
                }
                //MARK: - Google Sign Up
//                Button(action: {
//                    // Handle Google login action
//                }) {
//                    HStack {
//                        Text("or continue with")
//                            .font(.system(size: 16))
//                            .fontWeight(.bold)
//                        .foregroundColor(.black)
//                    }
//                    Image("google-logo")
//                        .resizable()
//                        .renderingMode(.original)
//                        .frame(width: 20, height: 20)
//                        .padding(5)
//                        .background(Color.white)
//                        .clipShape(Circle())
//                }
            }
            .background(Color(hex: 0xFFB63C))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

// MARK: - Form Validation Extension
extension LogInView: AuthFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

// MARK: - Preview
#Preview {
    LogInView()
}







