//
//  VaccineRowViewModel.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/18/24.
//

import Foundation

public final class VaccineRowViewModel: ObservableObject {
    let pet: Pet
    let vaccine: Vaccine
    
    public init(pet: Pet, vaccine: Vaccine) {
        self.pet = pet
        self.vaccine = vaccine
    }
}
