//
//  Pet.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/2/24.
//

import Foundation

public struct Pet: Identifiable, Codable {
    public var id = UUID()
    public var imgName: String = "icon1"
    public var name: String
    public var breed: String
    public var birthday: Date
    public var age: Int
    public var sex: String
    public var weight: Double
    public var activities: [Activity] = []
    public var mealSchedule: [MealSchedule] = []
    public var medications: [Medication] = []
    public var vetAppointments: [VetAppointment] = []
    public var vaccines: [Vaccine] = []
}


public struct MealSchedule: Identifiable, Codable {
    public var id = UUID()
    public var mealTime: Date
    public var foodType: String
    public var foodAmount: String
    public var specialInstructions: String = ""
}

public struct Activity: Identifiable, Codable {
    public var id = UUID()
    public var activityName: String
    public var isCompleted: Bool
}

public struct Medication: Identifiable, Codable {
    public var id = UUID()
    public var medName: String
    public var dosage: String
    public var frequency: String
    public var startDate: Date
    public var endDate: Date
}

public struct VetAppointment: Identifiable, Codable {
    public var id = UUID()
    public var appointmentName: String
    public var dateAndTime: Date
}

public struct Vaccine: Identifiable, Codable {
    public var id = UUID()
    public var vaccineName: String
    public var dateAdministered: Date
}

// for testing pet model for debugging
extension Pet {
    // January 1, 2021 is the test date for everything
    static var MOCK_PET_1 = Pet(
        name: "Buddy",
        breed: "Golden Retriever",
        birthday: Date(timeIntervalSince1970: 1609459200),
        age: 3,
        sex: "Male",
        weight: 25.5,
        activities: [
            Activity(activityName: "Walking", isCompleted: false),
            Activity(activityName: "Running", isCompleted: false)
        ],
        mealSchedule: [
            MealSchedule(mealTime: Date(timeIntervalSince1970: 1609459200), foodType: "Breakfast", foodAmount: "1 cup", specialInstructions: "Buddy loves breakfast!"),
            MealSchedule(mealTime: Date(timeIntervalSince1970: 1609459200), foodType: "Dinner", foodAmount: "1.5 cups", specialInstructions: "Buddy loves dinner!")
        ],
        medications: [
            Medication(medName: "Heartworm Prevention", dosage: "1 Tablet", frequency: "Monthly", startDate: Date(timeIntervalSince1970: 1609459200), endDate: Date(timeIntervalSince1970: 1609459200)),
            Medication(medName: "Flea and Tick Control", dosage: "2 Tablets", frequency: "Twice Daily", startDate: Date(timeIntervalSince1970: 1609459200), endDate: Date(timeIntervalSince1970: 1609459200))
        ],
        vetAppointments: [
            VetAppointment(appointmentName: "Meeting w/ Dr. Smith", dateAndTime: Date(timeIntervalSince1970: 1609459200)),
            VetAppointment(appointmentName: "Meeting w/ Dr. Grace", dateAndTime: Date(timeIntervalSince1970: 1609459200))
        ]
    )
    static var MOCK_PET_2 = Pet(
        name: "Doug",
        breed: "Poodle",
        birthday: Date(timeIntervalSince1970: 1609459200),
        age: 4,
        sex: "Male",
        weight: 30.0,
        activities: [
            Activity(activityName: "Walking", isCompleted: false),
            Activity(activityName: "Running", isCompleted: false)
        ],
        mealSchedule: [
            MealSchedule(mealTime: Date(timeIntervalSince1970: 1609459200), foodType: "Breakfast", foodAmount: "2 cups", specialInstructions: "Doug loves breakfast!"),
            MealSchedule(mealTime: Date(timeIntervalSince1970: 1609459200), foodType: "Dinner", foodAmount: "2 cups", specialInstructions: "Doug loves dinner!")
        ],
        medications: [
            Medication(medName: "Heartworm Prevention", dosage: "1 Tablet", frequency: "Monthly", startDate: Date(timeIntervalSince1970: 1609459200), endDate: Date(timeIntervalSince1970: 1609459200)),
            Medication(medName: "Flea and Tick Control", dosage: "2 Tablets", frequency: "Twice Daily", startDate: Date(timeIntervalSince1970: 1609459200), endDate: Date(timeIntervalSince1970: 1609459200))
        ],
        vetAppointments: [
            VetAppointment(appointmentName: "Meeting w/ Dr. Smith", dateAndTime: Date(timeIntervalSince1970: 1609459200)),
            VetAppointment(appointmentName: "Meeting w/ Dr. Grace", dateAndTime: Date(timeIntervalSince1970: 1609459200))
        ]
    )
}
