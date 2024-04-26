//
//  PetRecordsViewModels.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/5/24.
//

import Combine
import Foundation
import Firebase



public final class ActivitiesViewModel: ObservableObject {
    @Published var id: String = ""
    @Published var activityName: String = ""
    @Published var isCompleted: Bool = false
    let user = Auth.auth().currentUser
    private var cancellables = Set<AnyCancellable>()
    

    //MARK: - Add Pet Function
    public func addActivity() async {
        let ref = Database.database().reference()
        guard let uid = user?.uid else { return }
        //guard let pid = pet?.uid else { return }    //how do I get the specific pet? by id, but how?
        let activityEntity = Activity(activityName: activityName, isCompleted: isCompleted)
        //let petEntity = Pet(name: name, breed: breed, birthday: birthday, age: age, sex: sex, weight: Double(weight) ?? 0.0)
        
        do {
            let encodedActivity = try Database.Encoder().encode(activityEntity)
            //try await ref.child("root/users/\(uid)/pets/\(pid)").child("activities").child(activityEntity.id.uuidString).setValue(encodedActivity)
        } catch {
            print("DEBUG: Error saving activity information.")
        }
    }
    
    //MARK: - Delete Pet Function
    
    

}
