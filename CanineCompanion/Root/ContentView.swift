//
//  ContentView.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/1/24.
//

import SwiftUI
import Firebase
import FirebaseAuth


struct ContentView: View {
    @State private var selectedTab: Tab = .house
    @EnvironmentObject var viewModel: AuthViewModel
 
    var body: some View {
        
        Group {
            if viewModel.userSession != nil {
                //DRAFTProfileView()
                //send the users to the main screens of the app
                VStack(spacing: 0) {
                    // Main content switches depending on the selected tab
                    VStack {
                        switch selectedTab {
                            case .house:
                                PetHomeView(settingsViewModel: SettingsViewModel(), carouselViewModel: CarouselViewModel()) // home view content
                            case .message:
                                ChatView() // messages view content
                            case .location:
                                DogParksView() // locations view content
                            case .gearshape:
                                SettingsView(settingsViewModel: SettingsViewModel()) // settings view content
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    // Custom tab bar at the bottom
                    CustomTabBarView(selectedTab: $selectedTab)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60) // height for the tab bar
                }
                .edgesIgnoringSafeArea(.bottom) // bottom safe area
            } else {
                StartView()
            }
        }
    }
}

#Preview {
    ContentView()
}
