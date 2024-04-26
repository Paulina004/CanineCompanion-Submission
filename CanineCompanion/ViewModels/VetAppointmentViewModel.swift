//
//  VetAppointmentViewModel.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/9/24.
//

import Foundation
import SwiftUI

public final class VetAppointmentViewModel: ObservableObject {
    let pet: Pet
    @Binding var vetAppointments: [VetAppointment]
    
    public init(pet: Pet, vetAppointments: Binding<[VetAppointment]>) {
        self.pet = pet
        _vetAppointments = vetAppointments
    }
}
