//
//  CanineCompanionApp.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 3/5/24.
//

import SwiftUI
import FirebaseCore
import GoogleMaps
import GooglePlaces


class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    // configuring Firebase
    FirebaseApp.configure()
    // requesting notification auth
    NotificationManager.shared.requestAuthorization()
      
    return true
  }
}


@main
//struct YourApp: App {
struct CanineCompanionApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var viewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(viewModel)
            }
        }
    }
}
