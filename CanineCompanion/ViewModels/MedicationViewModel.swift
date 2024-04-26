//
//  MedicationViewModel.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/7/24.
//

import Foundation
import SwiftUI

public final class MedicationViewModel: ObservableObject {
    let pet: Pet
    @Binding var medications: [Medication]
    
    public init(pet: Pet, medications: Binding<[Medication]>) {
        self.pet = pet
        _medications = medications
    }
}
