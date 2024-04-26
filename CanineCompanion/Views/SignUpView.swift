//
//  SignUpView.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 3/9/24.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase


struct SignUpView: View {
    // user object variables
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var fullName = ""
    // alert
    @State private var alertDisplay = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    // auth view model
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: 0xFFB63C)
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 25) {
                    AccountInputView(text: $email, placeholder: "Email")
                        .autocapitalization(.none)
                    AccountInputView(text: $password, placeholder: "Password", isSecureField: true)
                        .autocapitalization(.none)
                    AccountInputView(text: $confirmPassword, placeholder: "Confirm Password", isSecureField: true)
                        .autocapitalization(.none)
                    AccountInputView(text: $fullName, placeholder: "Full Name")
                    //MARK: - Sign Up Button
                    Button(action: {
                        Task {
                            try await viewModel.createUser(withEmail: email, password: password, fullName: fullName)
                        }
                    }) {
                        Text("Sign Up")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.white)
                            .background(Color(hex: 0x6A2956))
                            .cornerRadius(20)
                            .padding(.horizontal, 40)
                            .disabled(!formIsValid)  //if form is not valid, button will not perform action (create user)
                            .opacity(formIsValid ? 1.0 : 0.5)
                    }
                    
                    //MARK: - Google Sign Up
//                    Button(action: {
//                        // Handle Google login action
//                    }) {
//                        HStack {
//                            Text("or continue with")
//                                .font(.system(size: 16))
//                                .fontWeight(.bold)
//                            .foregroundColor(.black)
//                        }
//                        Image("google-logo") 
//                            .resizable()
//                            .renderingMode(.original)
//                            .frame(width: 20, height: 20)
//                            .padding(5)
//                            .background(Color.white)
//                            .clipShape(Circle())
//                    }
                }
                .background(Color(hex: 0xFFB63C))
                .edgesIgnoringSafeArea(.all)
            }
        }
        .alert(isPresented: $alertDisplay) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

// MARK: - Form Validation Extension
extension SignUpView: AuthFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
        && !fullName.isEmpty
    }
}

// MARK: - Preview
#Preview {
    SignUpView()
}
