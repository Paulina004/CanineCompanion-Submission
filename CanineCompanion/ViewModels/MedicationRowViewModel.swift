//
//  MedicationRowViewModel.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/7/24.
//

import Foundation

public final class MedicationRowViewModel: ObservableObject {
    let pet: Pet
    let medication: Medication
    
    public init(pet: Pet, medication: Medication) {
        self.pet = pet
        self.medication = medication
    }
}
