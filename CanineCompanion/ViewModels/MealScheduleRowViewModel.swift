//
//  MealScheduleRowViewModel.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/7/24.
//

import Foundation

public final class MealScheduleRowViewModel: ObservableObject {
    let pet: Pet
    let mealSchedule: MealSchedule
    
    public init(pet: Pet, mealSchedule: MealSchedule) {
        self.pet = pet
        self.mealSchedule = mealSchedule
    }
}
