//
//  ActivityViewModel.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/7/24.
//

import Foundation
import SwiftUI

public final class ActivityViewModel: ObservableObject {
    let pet: Pet
    @Binding var activities: [Activity]
    
    public init(pet: Pet, activities: Binding<[Activity]>) {
        self.pet = pet
        _activities = activities
    }
}
