//
//  AuthViewModel.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/1/24.
//

import Foundation
import Firebase
import FirebaseAuth

protocol AuthFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var accountDeleted: Bool = false
    
    
    //MARK: - Init
    init() {
        // when our AuthViewModel initilizes, it is going to check if there is a current user
        // this is login persistence functionality
        self.userSession = Auth.auth().currentUser
        // we are also going to try to fetch our user data right away
        Task {
            await fetchUser()
        }
    }
    
    //MARK: - Sign In
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: Error signing in with error... \(error.localizedDescription)")
        }
    }
    
    //MARK: - Create User
    func createUser(withEmail email: String, password: String, fullName: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullName: fullName, email: email)
            // encoding the user's data
            let encodedUser = try Database.Encoder().encode(user)
            // storing the encoded user's data in the database
            try await Database.database().reference().child("root/users").child(user.id).setValue(encodedUser)
            // getting our newly created user and saving it in memory
            // we use await because we are waiting for Firebase to first store the data in Firebase before we can fetch it
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user to Firebase Auth with error... \(error.localizedDescription)")
        }
    }
    
    //MARK: - Sign Out
    func signOut() {
        do {
            // signing out user on backend
            try Auth.auth().signOut()
            // wipes out user session and takes us back to start screen
            self.userSession = nil
            // wipes out the current user object
            self.currentUser = nil
            print("DEBUG: Signed out successfully.")
        } catch {
            print("DEBUG: Failed to sign out with error... \(error.localizedDescription)")
        }
    }
    
    //MARK: - Delete Account
    func deleteAccount() {
        let user = Auth.auth().currentUser
        let uid = Auth.auth().currentUser?.uid ?? ""
        user?.delete { error in
            if let error {
                print("DEBUG: Error deleting account with error... \(String(describing: error))")
            } else {
                Task {
                    print("DEBUG: Successfully deleted account.")
                    await self.deleteUserFromDatabase(uid: uid)
                    try? Auth.auth().signOut()
                    self.userSession = nil
                    self.currentUser = nil
                }
            }
        }
    }
    
    //MARK: - Delete User from Database
    private func deleteUserFromDatabase(uid: String) async {
        let ref = Database.database().reference()
        
        do {
            try await ref.child("root/users").child(uid).removeValue()
          print("DEBUG: User deleted successfully!")
        } catch {
          print("DEBUG: Data could not be deleted: \(error).")
        }
    }
    
    //MARK: - Edit Password
    func editPassword(for newPassword: String) {
        guard let user = Auth.auth().currentUser else { return }
        user.updatePassword(to: newPassword) { error in
            if error != nil {
                print("DEBUG: Error updating password with error... \(String(describing: error))")
            } else {
                print("DEBUG: Successfully updated password.")
                try? Auth.auth().signOut()
                self.userSession = nil
                self.currentUser = nil
            }
        }
    }
    
    //MARK: - Fetch User
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("root/users").child(uid).observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self,
                  snapshot.exists() else { return }
            
            // extracting the data from database
            if let userData = snapshot.value as? [String: Any],
               let fullName = userData["fullName"] as? String,
               let email = userData["email"] as? String {
                // mapping the data from firebase into the current user object stored locally within the app instance
                strongSelf.currentUser = User(id: uid, fullName: fullName, email: email)
                print("DEBUG: The current user full name is \(String(describing: strongSelf.currentUser?.fullName))")
            }
        })
    }
}
