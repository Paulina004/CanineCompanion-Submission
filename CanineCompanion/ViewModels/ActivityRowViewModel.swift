//
//  ActivityRowViewModel.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/7/24.
//

import Foundation

public final class ActivityRowViewModel: ObservableObject {
    let pet: Pet
    let activity: Activity
    @Published var isCompleted: Bool
    
    public init(pet: Pet, activity: Activity) {
        self.pet = pet
        self.activity = activity
        self.isCompleted = activity.isCompleted
    }
    
    @MainActor
    public func updateIsCompletedState() async {
        isCompleted.toggle()
        await FirebaseTools().toggleActivityState(pet: pet, activity: self.activity, isCompleted: self.isCompleted)
    }
}
