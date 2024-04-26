//
//  PetDetailsViewModel.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/6/24.
//

import Foundation

public final class PetDetailsViewModel: ObservableObject {
    let firebaseTools = FirebaseTools()
    @Published var pet: Pet
    @Published var selectedImg: String = "icon1"
    let img = ["icon1", "icon2", "icon3", "icon4", "icon5", "icon6", "icon7", "icon8", "icon9", "icon10", "icon11", "icon12", "icon13", "icon14", "icon15", "icon16"]
    // parameters to pass in during async calls
    @Published var activityName: String = ""
    @Published var mealTime: Date = Date.now
    @Published var foodType: String = ""
    @Published var foodAmount: String = ""
    @Published var specialInstructions: String = ""
    @Published var medName: String = ""
    @Published var dosage: String = ""
    @Published var frequency: String = ""
    @Published var startDate: Date = Date.now
    @Published var endDate: Date = Date.now
    @Published var appointmentName: String = ""
    @Published var dateAndTime: Date = Date.now
    @Published var vaccineName: String = ""
    @Published var dateAdministered: Date = Date.now
    // for retrieving information from the database
    @Published var activities: [Activity] = []
    @Published var mealSchedules: [MealSchedule] = []
    @Published var medications: [Medication] = []
    @Published var vetAppointments: [VetAppointment] = []
    @Published var vaccines: [Vaccine] = []
    
    
    // MARK: - Init
    public init(pet: Pet,
                isPickerVisible: Bool = false,
                selectedImg: String = "icon1",
                activityName: String? = nil,
                mealTime: Date? = nil,
                foodType: String? = nil,
                foodAmount: String? = nil,
                specialInstructions: String? = nil,
                medName: String? = nil,
                dosage: String? = nil,
                frequency: String? = nil,
                startDate: Date? = Date.now,
                endDate: Date? = Date.now,
                appointmentName: String? = "",
                dateAndTime: Date? = Date.now,
                vaccineName: String? = "",
                dateAdministered: Date? = Date.now,
                activities: [Activity],
                mealSchedules: [MealSchedule],
                medications: [Medication],
                vetAppointments: [VetAppointment],
                vaccines: [Vaccine])
                {
        // for pet img
        self.pet = pet
        Task { @MainActor in
            self.selectedImg = await firebaseTools.retrievePetImage(for: self.pet.id)
        }
        // for activities
        self.activityName = activityName ?? ""
        Task { @MainActor in
            self.activities = await firebaseTools.retrieveActivities(pet_id: pet.id)
        }
        // for meal schedules
        self.mealTime = mealTime ?? Date.now
        self.foodType = foodType ?? ""
        self.foodAmount = foodAmount ?? ""
        self.specialInstructions = specialInstructions ?? ""
        Task { @MainActor in
            self.mealSchedules = await firebaseTools.retrieveMealSchedules(pet_id: pet.id)
        }
        // for medications
        self.medName = medName ?? ""
        self.dosage = dosage ?? ""
        self.frequency = frequency ?? ""
        self.startDate = startDate ?? Date.now
        self.endDate = endDate ?? Date.now
        Task { @MainActor in
            self.medications = await firebaseTools.retrieveMedications(pet_id: pet.id)
        }
        // for vet appointments
        self.appointmentName = appointmentName ?? ""
        self.dateAndTime = dateAndTime ?? Date.now
        Task { @MainActor in
            self.vetAppointments = await firebaseTools.retrieveVetAppointments(pet_id: pet.id)
        }
        // for vaccines
        self.vaccineName = vaccineName ?? ""
        self.dateAdministered = dateAdministered ?? Date.now
        Task { @MainActor in
            self.vaccines = await firebaseTools.retrieveVaccines(pet_id: pet.id)
        }
    }
    
    // MARK: - Add Activity
    @MainActor
    public func addActivity(pet_id: UUID, activityName: String) async {
        let activityEntity = Activity(activityName: activityName, isCompleted: false)
        self.activities.append(activityEntity)
        await firebaseTools.addActivity(pet_id: pet_id, activityEntity: activityEntity)
        print("DEBUG: The list of activities is: \(self.activities)")
    }
    
    // MARK: - Add Meal Schedule
    @MainActor
    public func addMealSchedule(pet_id: UUID, mealTime: Date, foodType: String, foodAmount: String, specialInstructions: String) async {
        let mealScheduleEntity = MealSchedule(mealTime: mealTime, foodType: foodType, foodAmount: foodAmount, specialInstructions: specialInstructions)
        self.mealSchedules.append(mealScheduleEntity)
        await firebaseTools.addMealSchedule(pet_id: pet_id, mealScheduleEntity: mealScheduleEntity)
        print("DEBUG: The list of meal schedules is: \(self.mealSchedules)")
    }
    
    // MARK: - Add Medicine
    @MainActor
    public func addMedication(pet_id: UUID, medName: String, dosage: String, frequency: String, startDate: Date, endDate: Date) async {
        let medicationEntity = Medication(medName: medName, dosage: dosage, frequency: frequency, startDate: startDate, endDate: endDate)
        self.medications.append(medicationEntity)
        await firebaseTools.addMedication(pet_id: pet_id, medicationEntity: medicationEntity)
        print("DEBUG: The list of medications is: \(self.medications)")
    }
    
    // MARK: - Add Vet Appointment
    @MainActor
    public func addVetAppointment(pet_id: UUID, appointmentName: String, dateAndTime: Date) async {
        let vetAppointmentEntity = VetAppointment(appointmentName: appointmentName, dateAndTime: dateAndTime)
        self.vetAppointments.append(vetAppointmentEntity)
        await firebaseTools.addVetAppointment(pet_id: pet_id, vetAppointmentEntity: vetAppointmentEntity)
        print("DEBUG: The list of vet appointments is: \(self.vetAppointments)")
    }
    
    // MARK: - Add Vaccine
    @MainActor
    public func addVaccine(pet_id: UUID, vaccineName: String, dateAdministered: Date) async {
        let vaccineEntity = Vaccine(vaccineName: vaccineName, dateAdministered: dateAdministered)
        self.vaccines.append(vaccineEntity)
        await firebaseTools.addVaccine(pet_id: pet_id, vaccineEntity: vaccineEntity)
        print("DEBUG: The list of vaccines is: \(self.vaccines)")
    }
}




// Notes for the pet image
// Load up the pet
// get the image name -> use that to display the image

// When we update the image
// Update in the database
// Update locally to use the image
