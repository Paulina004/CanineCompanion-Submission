//
//  SettingsViewModel.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/5/24.
//

import Combine
import Foundation
import Firebase

public final class SettingsViewModel: ObservableObject {
    @Published var pets: [Pet] = []
    @Published var name: String = ""
    @Published var breed: String = ""
    @Published var birthday: Date = Date.now
    @Published var age: Int = 0
    @Published var sex: String = ""
    @Published var weight: String = ""
    let user = Auth.auth().currentUser
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init() {
        self.age = calculateAge(birthDate: birthday)
        Task { @MainActor in
            pets = await FirebaseTools().retrievePets()
        }

        $birthday
            .sink { [weak self] birthday in
                guard let self = self else { return }
                self.age = self.calculateAge(birthDate: birthday)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Calculate Age
    private func calculateAge(birthDate: Date) -> Int {
        let currentDate = Date()
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: currentDate)
        guard let age = ageComponents.year else {
            return 0  // if unable to calculate age, return 0
        }
        return age
    }
}
