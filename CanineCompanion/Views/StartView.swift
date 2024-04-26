//
//  StartView.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 3/19/24.
//

import SwiftUI


struct StartView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: 0xFFB63C)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image("dog-start-view")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: .infinity, height: 300)
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: UIScreen.main.bounds.width, height: .infinity)
                            .cornerRadius(radius: 80, corners: [.topRight])
                            .edgesIgnoringSafeArea(.all)
            
                        VStack {
                            Image("logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: .infinity, height: .infinity)
                                .padding()
                            Text("Welcome!")
                                .font(.title)
                                .foregroundColor(.black)
                            Text("Let's get you logged in.")
                                .font(.body)
                                .foregroundColor(.black)
                            NavigationLink {
                                LogInView()
                            } label: {
                                Image(systemName: "arrow.right.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(Color(hex: 0xFFB63C))
                                    .padding()
                                    .clipShape(Circle())
                            }
                            HStack{
                                NavigationLink {
                                    SignUpView()
                                } label: {
                                    Text("New here?")
                                        .foregroundColor(Color(.black))
                                    Text("Sign Up")
                                        .foregroundColor(Color(.black))
                                        .fontWeight(.bold)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .tint(Color(hex: 0x6A2956))
    }
}



#Preview {
    StartView()
}
