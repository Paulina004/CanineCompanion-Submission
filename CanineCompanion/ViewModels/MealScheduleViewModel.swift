//
//  MealScheduleViewModel.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/7/24.
//

import Foundation
import SwiftUI

public final class MealScheduleViewModel: ObservableObject {
    let pet: Pet
    @Binding var mealSchedules: [MealSchedule]
    
    public init(pet: Pet, mealSchedules: Binding<[MealSchedule]>) {
        self.pet = pet
        _mealSchedules = mealSchedules
    }
}
