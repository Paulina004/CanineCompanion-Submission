//
//  FirebaseTools.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/5/24.
//

import Foundation
import Firebase
import FirebaseAuth


public final class FirebaseTools {
    let user = Auth.auth().currentUser
    var name: String?
    var breed: String?
    var birthday: Date?
    var age: Int?
    var sex: String?
    var weight: String?
    var imgName: String?

    // MARK: - Init
    init(name: String? = nil,
         breed: String? = nil,
         birthday: Date? = Date.now,
         age: Int? = 0,
         sex: String? = nil,
         weight: String? = nil,
         imgName: String? = nil) {
        self.name = name
        self.breed = breed
        self.birthday = birthday
        self.age = age
        self.sex = sex
        self.weight = weight
        self.imgName = imgName
    }
    
    // MARK: - Retrieve Pet
    func retrievePets() async -> [Pet] {
        let user = Auth.auth().currentUser
        let databaseReference = Database.database().reference()
        var pets = [Pet]()
        guard let user else { return [] }

        do {
            let snapshot = try await databaseReference.child("root/users").child(user.uid).child("pets").getData()

            let petDictionary = snapshot.value as? [String: Any]

            guard let petDictionary else { return [] }
            for pet in petDictionary {
                let convertedPet = pet.value as? [String: Any]
                
                guard let convertedPet else { return [] }
                
                // TODO: - Paulina Add the vaccines to the new pet variable
                let newPet = Pet(id: UUID(uuidString: convertedPet["id"] as? String ?? "") ?? UUID(),
                                 imgName: convertedPet["imgName"] as? String ?? "",
                                 name: convertedPet["name"] as? String ?? "",
                                 breed: convertedPet["breed"] as? String ?? "",
                                 birthday: convertedPet["birthday"] as? Date ?? Date(),
                                 age: convertedPet["age"] as? Int ?? 0,
                                 sex: convertedPet["sex"] as? String ?? "",
                                 weight: convertedPet["weight"] as? Double ?? 0,
                                 activities: convertActivities(pet: convertedPet),
                                 mealSchedule: convertMealSchedules(pet: convertedPet),
                                 vetAppointments: convertVetAppointments(pet: convertedPet),
                                 vaccines: convertVaccines(pet: convertedPet))
                pets.append(newPet)
            }
        } catch {
            print("DEBUG: Error retrieving pets data... \(error)")
        }
        return pets
    }
    
    // for activities
    private func convertActivities(pet: [String: Any]) -> [Activity] {
        var activities = [Activity]()
        guard let activitiesDictionary = pet["activities"] as? [String: Any] else { return [] }
        for activity in activitiesDictionary.values {
            guard let activityDictionary = activity as? [String: Any] else { return [] }
            activities.append(Activity(id: UUID(uuidString: activityDictionary["id"] as? String ?? "") ?? UUID(),
                                       activityName: activityDictionary["activityName"] as? String ?? "",
                                       isCompleted: activityDictionary["isCompleted"] as? Bool ?? false))
        }
        return activities
    }
    // for meal schedules
    private func convertMealSchedules(pet: [String: Any]) -> [MealSchedule] {
        var mealSchedules = [MealSchedule]()
        guard let mealSchedulesDictionary = pet["activities"] as? [String: Any] else { return [] }
        for mealSchedule in mealSchedulesDictionary.values {
            guard let mealSchedulesDictionary = mealSchedule as? [String: Any] else { return [] }
            mealSchedules.append(MealSchedule(id: UUID(uuidString: mealSchedulesDictionary["id"] as? String ?? "") ?? UUID(),
                                       mealTime: mealSchedulesDictionary["mealTime"] as? Date ?? Date.now,
                                       foodType: mealSchedulesDictionary["foodType"] as? String ?? "",
                                       foodAmount: mealSchedulesDictionary["foodAmount"] as? String ?? "",
                                       specialInstructions: mealSchedulesDictionary["specialInstructions"] as? String ?? ""))
        }
        return mealSchedules
    }
    // for medications
    private func convertMedications(pet: [String: Any]) -> [Medication] {
        var medications = [Medication]()
        guard let medicationsDictionary = pet["medications"] as? [String: Any] else { return [] }
        for medication in medicationsDictionary.values {
            guard let medicationsDictionary = medication as? [String: Any] else { return [] }
            medications.append(Medication(id: UUID(uuidString: medicationsDictionary["id"] as? String ?? "") ?? UUID(),
                                       medName: medicationsDictionary["medName"] as? String ?? "",
                                       dosage: medicationsDictionary["dosage"] as? String ?? "",
                                       frequency: medicationsDictionary["frequency"] as? String ?? "",
                                       startDate: medicationsDictionary["startDate"] as? Date ?? Date.now,
                                       endDate: medicationsDictionary["endDate"] as? Date ?? Date.now))
        }
        return medications
    }
    // for vet appointments
    private func convertVetAppointments(pet: [String: Any]) -> [VetAppointment] {
        var vetAppointments = [VetAppointment]()
        guard let vetAppointmentsDictionary = pet["vetAppointments"] as? [String: Any] else { return [] }
        for vetAppointment in vetAppointmentsDictionary.values {
            guard let vetAppointmentsDictionary = vetAppointment as? [String: Any] else { return [] }
            vetAppointments.append(VetAppointment(id: UUID(uuidString: vetAppointmentsDictionary["id"] as? String ?? "") ?? UUID(),
                                       appointmentName: vetAppointmentsDictionary["appointmentName"] as? String ?? "",
                                       dateAndTime: vetAppointmentsDictionary["dateAndTime"] as? Date ?? Date.now))
        }
        return vetAppointments
    }
    // for vaccinations
    private func convertVaccines(pet: [String: Any]) -> [Vaccine] {
        var vaccines = [Vaccine]()
        guard let vaccinesDictionary = pet["vaccines"] as? [String: Any] else { return [] }
        for vaccine in vaccinesDictionary.values {
            guard let vaccinesDictionary = vaccine as? [String: Any] else { return [] }
            vaccines.append(Vaccine(id: UUID(uuidString: vaccinesDictionary["id"] as? String ?? "") ?? UUID(),
                                       vaccineName: vaccinesDictionary["vaccineName"] as? String ?? "",
                                    dateAdministered: vaccinesDictionary["dateAdministered"] as? Date ?? Date.now))
        }
        return vaccines
    }
    
    // MARK: - Add Pet
    public func addPet() async {
        let ref = Database.database().reference()
        guard let id = user?.uid,
        let name = self.name,
        let breed = self.breed,
        let birthday = self.birthday,
        let age = self.age,
        let sex = self.sex,
        let weight = self.weight
        else { return }
        let petEntity = Pet(name: name, breed: breed, birthday: birthday, age: age, sex: sex, weight: Double(weight) ?? 0.0)
        
        do {
            let encodedPet = try Database.Encoder().encode(petEntity)
            try await ref.child("root/users").child(id).child("pets").child(petEntity.id.uuidString).setValue(encodedPet)
        } catch {
            print("DEBUG: Error adding pet to database.")
        }
    }
    
    // MARK: - Delete Pet
    public func deletePet(at offset: IndexSet.Element?, petsList: [Pet]) async {
        let ref = Database.database().reference()
        guard let offset,
        let id = user?.uid else { return }
        let index = offset as Int
        
        // give it the list of pets before removal
        // use it to find the index of the pet and grab its id
        let petForDeletion = petsList[index]
        // send id into firebase for deletion
        let nodeToDelete = ref.child("root/users").child(id).child("pets").child(petForDeletion.id.uuidString)
        
        do {
            try await nodeToDelete.removeValue()
            print("\(petForDeletion.name) deleted successfully!")
        } catch {
            print("DEBUG: Error deleting pet from database.")
        }
    }
    
    // MARK: - Retrieve Pet Image
    public func retrievePetImage(for pet_id: UUID) async -> String {
        let user = Auth.auth().currentUser
        let databaseReference = Database.database().reference()
        var imgString = ""
        guard let user else { return "icon1" }

        do {
            let snapshot = try await databaseReference.child("root/users").child(user.uid).child("pets").child(pet_id.uuidString).child("imgName").getData()
            
            let imgData = snapshot.value as? String
            
            guard let imgData else { return "icon1" }
            imgString = imgData
            print("DEBUG: The value in imgString is: \(imgString)")
        } catch {
            print("DEBUG: Error retrieving pet image data... \(error)")
        }
        return imgString
    }
    
    // MARK: - Update Pet Image
    public func updatePetImg(pet_id: UUID, img: String) async {
        let ref = Database.database().reference()
        guard let id = user?.uid
        else { return }
        
        do {
            let encodedImg = try Database.Encoder().encode(img)
            try await ref.child("root/users").child(id).child("pets").child(pet_id.uuidString).child("imgName").setValue(encodedImg)
        } catch {
            print("DEBUG: Error adding pet to database.")
        }
    }
    
    // MARK: - Retrieve Activities
    public func retrieveActivities(pet_id: UUID) async -> [Activity] {
        let user = Auth.auth().currentUser
        let databaseReference = Database.database().reference()
        var activities = [Activity]()
        guard let user else { return [] }

        do {
            let snapshot = try await databaseReference.child("root/users").child(user.uid).child("pets").child(pet_id.uuidString).child("activities").getData()

            let activityDictionary = snapshot.value as? [String: Any]

            guard let activityDictionary else { return [] }
            for activity in activityDictionary {
                let convertedActivity = activity.value as? [String: Any]

                guard let convertedActivity else { return [] }
                let newActivity = Activity(id: UUID(uuidString: convertedActivity["id"] as? String ?? "") ?? UUID(),
                                 activityName: convertedActivity["activityName"] as? String ?? "",
                                 isCompleted: convertedActivity["isCompleted"] as? Bool ?? false)

                activities.append(newActivity)
            }
        } catch {
            print("DEBUG: Error retrieving activities data... \(error)")
        }
        return activities
    }
    
    // MARK: - Add Activity
    public func addActivity(pet_id: UUID, activityEntity: Activity) async {
        let ref = Database.database().reference()
        guard let id = user?.uid
        else { return }
        
        do {
            let encodedActivity = try Database.Encoder().encode(activityEntity)
            try await ref.child("root/users").child(id).child("pets").child(pet_id.uuidString).child("activities").child(activityEntity.id.uuidString).setValue(encodedActivity)
        } catch {
            print("DEBUG: Error adding activity to database.")
        }
    }
    
    // MARK: - Delete Activity
    public func deleteActivity(at offset: IndexSet.Element?, activityList: [Activity], pet_id: UUID) async {
        let ref = Database.database().reference()
        guard let offset,
        let id = user?.uid else { return }
        let index = offset as Int
        
        // give it the list of pets before removal
        // use it to find the index of the pet and grab its id
        let activityForDeletion = activityList[index]
        // send id into firebase for deletion
        let nodeToDelete = ref.child("root/users").child(id).child("pets").child(pet_id.uuidString).child("activities").child(activityForDeletion.id.uuidString)
        
        do {
            try await nodeToDelete.removeValue()
            print("DEBUG: Activity deleted successfully!")
        } catch {
            print("DEBUG: Error deleting activity from database.")
        }
    }
    
    // MARK: - Toggle Activity State
    public func toggleActivityState(pet: Pet, activity: Activity, isCompleted: Bool) async {
        // we need the pet id, user id, and the activity id
        let ref = Database.database().reference()
        let petId = pet.id
        let activityId = activity.id
        guard let id = user?.uid else { return }
        
        do {
            let encodedState = try Database.Encoder().encode(isCompleted)
            try await ref.child("root/users").child(id).child("pets").child(petId.uuidString).child("activities").child(activityId.uuidString).child("isCompleted").setValue(encodedState)
        } catch {
            print("DEBUG: Error updating activity state in database...\(error)")
        }
    }

    // MARK: - Retrieve Meal Schedules
    public func retrieveMealSchedules(pet_id: UUID) async -> [MealSchedule] {
        let user = Auth.auth().currentUser
        let databaseReference = Database.database().reference()
        var mealSchedules = [MealSchedule]()
        guard let user else { return [] }

        do {
            let snapshot = try await databaseReference.child("root/users").child(user.uid).child("pets").child(pet_id.uuidString).child("mealSchedules").getData()

            let mealScheduleDictionary = snapshot.value as? [String: Any]

            guard let mealScheduleDictionary else { return [] }
            for mealSchedule in mealScheduleDictionary {
                let convertedMealSchedule = mealSchedule.value as? [String: Any]

                guard let convertedMealSchedule else { return [] }
                let newMealSchedule = MealSchedule(id: UUID(uuidString: convertedMealSchedule["id"] as? String ?? "") ?? UUID(),
                                           mealTime: convertedMealSchedule["mealTime"] as? Date ?? Date.now,
                                           foodType: convertedMealSchedule["foodType"] as? String ?? "",
                                           foodAmount: convertedMealSchedule["foodAmount"] as? String ?? "",
                                           specialInstructions: convertedMealSchedule["specialInstructions"] as? String ?? "")

                mealSchedules.append(newMealSchedule)
            }
        } catch {
            print("DEBUG: Error retrieving meal schedule data... \(error).")
        }
        return mealSchedules
    }
    
    // MARK: - Add Meal Schedule
    public func addMealSchedule(pet_id: UUID, mealScheduleEntity: MealSchedule) async {
        let ref = Database.database().reference()
        guard let id = user?.uid
        else { return }
        
        do {
            let encodedMealSchedule = try Database.Encoder().encode(mealScheduleEntity)
            try await ref.child("root/users").child(id).child("pets").child(pet_id.uuidString).child("mealSchedules").child(mealScheduleEntity.id.uuidString).setValue(encodedMealSchedule)
        } catch {
            print("DEBUG: Error adding meal schedule to database.")
        }
    }
    
    // MARK: - Delete Meal Schedule
    public func deleteMealSchedule(at offset: IndexSet.Element?, mealScheduleList: [MealSchedule], pet_id: UUID) async {
        let ref = Database.database().reference()
        guard let offset,
        let id = user?.uid else { return }
        let index = offset as Int
        
        // give it the list of pets before removal
        // use it to find the index of the pet and grab its id
        let mealScheduleForDeletion = mealScheduleList[index]
        // send id into firebase for deletion
        let nodeToDelete = ref.child("root/users").child(id).child("pets").child(pet_id.uuidString).child("mealSchedules").child(mealScheduleForDeletion.id.uuidString)
        
        do {
            try await nodeToDelete.removeValue()
            print("DEBUG: Meal schedule deleted successfully!")
        } catch {
            print("DEBUG: Error deleting meal schedule from database.")
        }
    }
    
    // MARK: - Retrieve Medications
    public func retrieveMedications(pet_id: UUID) async -> [Medication] {
        let user = Auth.auth().currentUser
        let databaseReference = Database.database().reference()
        var medications = [Medication]()
        guard let user else { return [] }

        do {
            let snapshot = try await databaseReference.child("root/users").child(user.uid).child("pets").child(pet_id.uuidString).child("medications").getData()

            let medicationDictionary = snapshot.value as? [String: Any]

            guard let medicationDictionary else { return [] }
            for medication in medicationDictionary {
                let convertedMedication = medication.value as? [String: Any]

                guard let convertedMedication else { return [] }
                let newMedication = Medication(id: UUID(uuidString: convertedMedication["id"] as? String ?? "") ?? UUID(),
                                               medName: convertedMedication["medName"] as? String ?? "",
                                               dosage: convertedMedication["dosage"] as? String ?? "",
                                               frequency: convertedMedication["frequency"] as? String ?? "",
                                               startDate: convertedMedication["startDate"] as? Date ?? Date.now,
                                               endDate: convertedMedication["endDate"] as? Date ?? Date.now)

                medications.append(newMedication)
            }
        } catch {
            print("DEBUG: Error retrieving medication data... \(error).")
        }
        return medications
    }
    
    // MARK: - Add Medication
    public func addMedication(pet_id: UUID, medicationEntity: Medication) async {
        let ref = Database.database().reference()
        guard let id = user?.uid
        else { return }
        
        do {
            let encodedMedication = try Database.Encoder().encode(medicationEntity)
            try await ref.child("root/users").child(id).child("pets").child(pet_id.uuidString).child("medications").child(medicationEntity.id.uuidString).setValue(encodedMedication)
        } catch {
            print("DEBUG: Error adding medication to database.")
        }
    }
    
    // MARK: - Delete Medication
    public func deleteMedication(at offset: IndexSet.Element?, medicationList: [Medication], pet_id: UUID) async {
        let ref = Database.database().reference()
        guard let offset,
        let id = user?.uid else { return }
        let index = offset as Int
        
        // give it the list of pets before removal
        // use it to find the index of the pet and grab its id
        let medicationForDeletion = medicationList[index]
        // send id into firebase for deletion
        let nodeToDelete = ref.child("root/users").child(id).child("pets").child(pet_id.uuidString).child("medications").child(medicationForDeletion.id.uuidString)
        
        do {
            try await nodeToDelete.removeValue()
            print("DEBUG: Medication deleted successfully!")
        } catch {
            print("DEBUG: Error deleting medication from database.")
        }
    }
    
    // MARK: - Retrieve Vet Appointments
    public func retrieveVetAppointments(pet_id: UUID) async -> [VetAppointment] {
        let user = Auth.auth().currentUser
        let databaseReference = Database.database().reference()
        var vetAppointments = [VetAppointment]()
        guard let user else { return [] }

        do {
            let snapshot = try await databaseReference.child("root/users").child(user.uid).child("pets").child(pet_id.uuidString).child("vetAppointments").getData()

            let vetAppointmentsDictionary = snapshot.value as? [String: Any]

            guard let vetAppointmentsDictionary else { return [] }
            for vetAppointment in vetAppointmentsDictionary {
                let convertedVetAppointment = vetAppointment.value as? [String: Any]

                guard let convertedVetAppointment else { return [] }
                let newVetAppointment = VetAppointment(id: UUID(uuidString: convertedVetAppointment["id"] as? String ?? "") ?? UUID(),
                                                       appointmentName: convertedVetAppointment["appointmentName"] as? String ?? "",
                                                       dateAndTime: convertedVetAppointment["dateAndTime"] as? Date ?? Date.now)

                vetAppointments.append(newVetAppointment)
            }
        } catch {
            print("DEBUG: Error retrieving vet appointment data... \(error).")
        }
        return vetAppointments
    }
    
    // MARK: - Add Vet Appointment
    public func addVetAppointment(pet_id: UUID, vetAppointmentEntity: VetAppointment) async {
        let ref = Database.database().reference()
        guard let id = user?.uid
        else { return }
        
        do {
            let encodedVetAppointment = try Database.Encoder().encode(vetAppointmentEntity)
            try await ref.child("root/users").child(id).child("pets").child(pet_id.uuidString).child("vetAppointments").child(vetAppointmentEntity.id.uuidString).setValue(encodedVetAppointment)
        } catch {
            print("DEBUG: Error adding vet appointment to database.")
        }
    }
    
    // MARK: - Delete Vet Appointment
    public func deleteVetAppointment(at offset: IndexSet.Element?, vetAppointmentList: [VetAppointment], pet_id: UUID) async {
        let ref = Database.database().reference()
        guard let offset,
        let id = user?.uid else { return }
        let index = offset as Int
        
        // give it the list of pets before removal
        // use it to find the index of the pet and grab its id
        let vetAppointmentForDeletion = vetAppointmentList[index]
        // send id into firebase for deletion
        let nodeToDelete = ref.child("root/users").child(id).child("pets").child(pet_id.uuidString).child("vetAppointments").child(vetAppointmentForDeletion.id.uuidString)
        
        do {
            try await nodeToDelete.removeValue()
            print("DEBUG: Vet Appointment deleted successfully!")
        } catch {
            print("DEBUG: Error deleting vet appointment from database.")
        }
    }
    
    // MARK: - Retrieve Vaccines
    public func retrieveVaccines(pet_id: UUID) async -> [Vaccine] {
        let user = Auth.auth().currentUser
        let databaseReference = Database.database().reference()
        var vaccines = [Vaccine]()
        guard let user else { return [] }

        do {
            let snapshot = try await databaseReference.child("root/users").child(user.uid).child("pets").child(pet_id.uuidString).child("vaccines").getData()

            let vaccinesDictionary = snapshot.value as? [String: Any]

            guard let vaccinesDictionary else { return [] }
            for vaccine in vaccinesDictionary {
                let convertedVaccine = vaccine.value as? [String: Any]

                guard let convertedVaccine else { return [] }
                let newVaccine = Vaccine(id: UUID(uuidString: convertedVaccine["id"] as? String ?? "") ?? UUID(),
                                                       vaccineName: convertedVaccine["vaccineName"] as? String ?? "",
                                                       dateAdministered: convertedVaccine["dateAdministered"] as? Date ?? Date.now)

                vaccines.append(newVaccine)
            }
        } catch {
            print("DEBUG: Error retrieving vaccine data... \(error).")
        }
        return vaccines
    }
    
    // MARK: - Add Vaccine
    public func addVaccine(pet_id: UUID, vaccineEntity: Vaccine) async {
        let ref = Database.database().reference()
        guard let id = user?.uid
        else { return }
        
        do {
            let encodedVaccine = try Database.Encoder().encode(vaccineEntity)
            try await ref.child("root/users").child(id).child("pets").child(pet_id.uuidString).child("vaccines").child(vaccineEntity.id.uuidString).setValue(encodedVaccine)
        } catch {
            print("DEBUG: Error adding vaccine to database.")
        }
    }
    
    // MARK: - Delete Vaccine
    public func deleteVaccine(at offset: IndexSet.Element?, vaccineList: [Vaccine], pet_id: UUID) async {
        let ref = Database.database().reference()
        guard let offset,
        let id = user?.uid else { return }
        let index = offset as Int
        
        // give it the list of pets before removal
        // use it to find the index of the pet and grab its id
        let vaccineForDeletion = vaccineList[index]
        // send id into firebase for deletion
        let nodeToDelete = ref.child("root/users").child(id).child("pets").child(pet_id.uuidString).child("vaccines").child(vaccineForDeletion.id.uuidString)
        
        do {
            try await nodeToDelete.removeValue()
            print("DEBUG: Vaccine deleted successfully!")
        } catch {
            print("DEBUG: Error deleting vaccine from database.")
        }
    }
}
