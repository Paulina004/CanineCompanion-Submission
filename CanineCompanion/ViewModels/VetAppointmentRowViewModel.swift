//
//  VetAppointmentRowViewModel.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/9/24.
//

import Foundation

public final class VetAppointmentRowViewModel: ObservableObject {
    let pet: Pet
    let vetAppointment: VetAppointment
    
    public init(pet: Pet, vetAppointment: VetAppointment) {
        self.pet = pet
        self.vetAppointment = vetAppointment
    }
}
