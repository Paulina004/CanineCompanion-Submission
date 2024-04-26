//
//  VaccineViewModel.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/18/24.
//

import Foundation
import SwiftUI

public final class VaccineViewModel: ObservableObject {
    let pet: Pet
    @Binding var vaccines: [Vaccine]
    
    public init(pet: Pet, vaccines: Binding<[Vaccine]>) {
        self.pet = pet
        _vaccines = vaccines
    }
}
