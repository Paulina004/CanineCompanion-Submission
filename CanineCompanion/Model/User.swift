//
//  User.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/1/24.
//

import Foundation



// the identifiable protocol marks a type as identifiable, meaning instances of that type have a unique id to distinguish them from one another
// the codable protocol combines the encodable and decodable protocols to allow for encoding and decoding of external representations, in this case, JSON lists from the database
struct User: Identifiable, Codable {
    let id: String
    let fullName: String
    let email: String
    // computed property to get the initials of the user's full name for the settings view
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}



// for testing user model for debugging
extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, fullName: "John Smith", email: "test@gmail.com")
}
