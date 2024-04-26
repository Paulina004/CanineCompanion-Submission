//
//  PetHomeView.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/1/24.
//

import SwiftUI


// MARK: - Global Variable
var width = UIScreen.main.bounds.width

// MARK: - Struct for Carousel Content
struct Tutorial: Hashable, Identifiable {
    var id: Self { self }
    let title: String
    let text: String
}

// MARK: - Home View
struct PetHomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var settingsViewModel: SettingsViewModel
    @ObservedObject var carouselViewModel: CarouselViewModel
    let firebaseTools = FirebaseTools()
    @State var pets: [Pet] = []
    @State private var petsWereFetched: Bool = false
    
    public init(settingsViewModel: SettingsViewModel, carouselViewModel: CarouselViewModel) {
        self.settingsViewModel = settingsViewModel
        self.carouselViewModel = carouselViewModel
    }
    
    var body: some View {
        if let user = authViewModel.currentUser {
            NavigationView {
                VStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Welcome,")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text(user.fullName)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: 0x6A2956))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)
                    .padding(.horizontal, 30)
                    ZStack {
                        ForEach(carouselViewModel.cards.indices.reversed(), id: \.self) { index in
                            HStack {
                                CardView(carouselViewModel: carouselViewModel, card: carouselViewModel.cards[index])
                                    .frame(width: getCardWidth(index: index), height: getCardHeight(index: index))
                                    .offset(x: getCardOffset(index: index))
                                    .rotationEffect(.init(degrees: getCardRotation(index: index)))
                                Spacer(minLength: 0)
                            }
                            .frame(height: 300)
                            .contentShape(Rectangle())
                            .offset(x: carouselViewModel.cards[index].offset)
                            .gesture(DragGesture(minimumDistance: 0)
                                .onChanged({ value in
                                    onChanged(value: value, index: index)
                                }).onEnded({ value in
                                    onEnded(value: value, index: index)
                                })
                            )
                        }
                    }
                    .padding(.top, 25)
                    .padding(.horizontal, 30)
                    Button(action: resetViews, label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(hex: 0xFFB63C))
                            .clipShape(Circle())
                    })
                    .padding(.top, 10)
                    VStack(spacing: 5) {
                        Text("Your Pets")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(Color(.gray))
                            .padding(.top, 10)
                            .padding(.horizontal, 20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        List(pets) { pet in
                            NavigationLink(destination: PetDetailView(viewModel: PetDetailsViewModel(pet: pet, activities: [], mealSchedules: [], medications: [], vetAppointments: [], vaccines: []))) {
                                Text(pet.name)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .padding(10)
                            }
                            .listRowBackground(
                                Capsule()
                                    .fill(Color(.systemGray5))
                                    .padding(4)
                            )
                            .listRowSeparator(.hidden)
                            .foregroundColor(Color(.black))
                            .fontWeight(.black)
                        }
                        .listStyle(PlainListStyle())
                        .scrollContentBackground(.hidden)
                        .onAppear(perform: {
                            print("DEBUG: PetsWereFetched is \(petsWereFetched).")
                            if !petsWereFetched {
                                Task { @MainActor in
                                    self.pets = await firebaseTools.retrievePets()
                                }
                                petsWereFetched = true
                                print("DEBUG: PetsWereFetched is \(petsWereFetched).")
                            }
                        })
                    }
                    .padding(.horizontal, 20)
                    
                    Text("")
                }
                .background(Color(.white))
            }
            .tint(Color(.white))
        }
    }
    
    
    // MARK: - Functions for Carousel View
    func resetViews() {
        for index in carouselViewModel.cards.indices {
            withAnimation(.spring()) {
                carouselViewModel.cards[index].offset = 0
                carouselViewModel.swipedCard = 0
            }
        }
    }
    func getCardHeight(index: Int) -> CGFloat {
        let height: CGFloat = 300
        // for first three cards...
        let cardHeight = index - carouselViewModel.swipedCard <= 2 ? CGFloat(index - carouselViewModel.swipedCard) * 35 : 70
        return height - cardHeight
    }
    func getCardWidth(index: Int) -> CGFloat {
        let boxWidth = UIScreen.main.bounds.width - 60 - 60
        // for first three cards...
        //let cardWidth = index <= 2 ? CGFloat(index) * 30 : 60
        return boxWidth
    }
    func getCardOffset(index: Int) -> CGFloat {
        return index - carouselViewModel.swipedCard <= 2 ? CGFloat(index - carouselViewModel.swipedCard) * 30 : 60
    }
    func getCardRotation(index: Int) -> Double {
        let boxWidth = Double(width / 3)
        let offset = Double(carouselViewModel.cards[index].offset)
        let angle: Double = 5
        return (offset / boxWidth) * angle
    }
    func onChanged(value: DragGesture.Value, index: Int) {
        //only left swipe...
        if value.translation.width < 0 {
            carouselViewModel.cards[index].offset = value.translation.width
        }
    }
    func onEnded(value: DragGesture.Value, index: Int) {
        withAnimation {
            if -value.translation.width > width / 3 {
                carouselViewModel.cards[index].offset = -width
                carouselViewModel.swipedCard += 1
            }
            else {
                carouselViewModel.cards[index].offset = 0
            }
        }
    }
}


// MARK: - Details Screen About One Pet in the List of Pets
struct PetDetailView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel: PetDetailsViewModel
    @State var isPickerVisible = false
    // for the sheet form views
    @State var showingActivitySheetView: Bool = false
    @State var showingMealScheduleSheetView: Bool = false
    @State var showingMedicineSheetView: Bool = false
    @State var showingVetAppointmentSheetView: Bool = false
    @State var showingVaccineSheetView: Bool = false
    @State var showingPetImagePopover: Bool = false
    // for notifications
    @State var mealScheduleNotificationEnabled: Bool = false
    @State var showingAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    // for segmented picker
    let foodTypeOptions = ["Breakfast", "Lunch", "Dinner"]
  
    
    var body: some View {
        List {
            
            // MARK: - Title Section
            Section {
                ZStack {
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: 130)
                        .foregroundColor(Color(hex: 0x6A2956))
                        .cornerRadius(radius: 60, corners: [.bottomLeft, .bottomRight])
                        .background(.white)
                    HStack {
                        Button {
                            self.showingPetImagePopover.toggle()
                        } label: {
                            Image(viewModel.selectedImg)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                                .padding(.trailing, 20)
                        }
                        .popover(isPresented: $showingPetImagePopover) {
                            if #available(iOS 16.4, *) {
                                ImgPicker
                                    .presentationCompactAdaptation(.popover)
                                    .onChange(of: viewModel.selectedImg) { newValue in
                                        Task { @MainActor in
                                            viewModel.selectedImg = newValue
                                            await viewModel.firebaseTools.updatePetImg(pet_id: viewModel.pet.id, img: viewModel.selectedImg)
                                        }
                                    }
                            } else {
                                ImgPicker
                                    .onChange(of: viewModel.selectedImg) { newValue in
                                        Task { @MainActor in
                                            await viewModel.firebaseTools.updatePetImg(pet_id: viewModel.pet.id, img: viewModel.selectedImg)
                                        }
                                    }
                            }
                        }

                        VStack(alignment: .leading) {
                            Text("\(viewModel.pet.name)")
                                .font(.title)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                            Text("\(viewModel.pet.breed)")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 30)
                }
            }
            .listRowInsets(.init())
            .listRowSeparator(.hidden)
            
            // MARK: - Info Section
            Section {
                Text("Info")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        HorizontalPetInfoScrollItemView(imageName: "pawprint.fill", title: "Name", petInfoData: "\(viewModel.pet.name)", color: Color(hex: 0xFFB63C))
                        HorizontalPetInfoScrollItemView(imageName: "dog.fill", title: "Breed", petInfoData: "\(viewModel.pet.breed)", color: Color(hex: 0xFE5C12))
                        HorizontalPetInfoScrollItemView(imageName: "birthday.cake.fill", title: "Birthday", petInfoData: "\(formattedDate(viewModel.pet.birthday))", color: Color(hex: 0x7975F7))
                        HorizontalPetInfoScrollItemView(imageName: "123.rectangle.fill", title: "Age", petInfoData: "\(viewModel.pet.age) years old", color: Color(hex: 0xFFB63C))
                        HorizontalPetInfoScrollItemView(imageName: "info.circle.fill", title: "Sex", petInfoData: "\(viewModel.pet.sex)", color: Color(hex: 0xFE5C12))
                        HorizontalPetInfoScrollItemView(imageName: "scalemass.fill", title: "Weight", petInfoData: "\(viewModel.pet.weight) lbs", color: Color(hex: 0x7975F7))
                    }
                }
            }
            .listRowSeparator(.hidden)
            
            // MARK: - Activities Section
            HStack {
                Text("Activities")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                Spacer()
                Button(action: {
                    showingActivitySheetView.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .padding(.bottom, -4)
                })
                .buttonStyle(BorderlessButtonStyle())
                .fullScreenCover(isPresented: $showingActivitySheetView) {
                    ActivitySheetView
                }
            }
            .listRowSeparator(.hidden)
            Section {
                if !viewModel.pet.activities.isEmpty {
                    ActivityView(viewModel: ActivityViewModel(pet: viewModel.pet, activities: $viewModel.activities))
                }
            }
            .listRowInsets(.init())
            .padding(.horizontal, 20)
            .padding(.vertical, 4)
            .listRowSeparator(.hidden)
            
            // MARK: - Meal Schedule Section
            HStack {
                Text("Meal Schedule")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                Spacer()
                Button(action: {
                    showingMealScheduleSheetView.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .padding(.bottom, -4)
                })
                .buttonStyle(BorderlessButtonStyle())
                .fullScreenCover(isPresented: $showingMealScheduleSheetView) {
                    MealScheduleSheetView
                }
            }
            .listRowSeparator(.hidden)
            Section {
                if !viewModel.pet.mealSchedule.isEmpty {
                    MealScheduleView(viewModel: MealScheduleViewModel(pet: viewModel.pet, mealSchedules: $viewModel.mealSchedules))
                }
            }
            .listRowInsets(.init())
            .padding(.horizontal, 20)
            .padding(.vertical, 4)
            .listRowSeparator(.hidden)
            
            // MARK: - Medications Section
            HStack {
                Text("Medications")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                Spacer()
                Button(action: {
                    showingMedicineSheetView.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .padding(.bottom, -4)
                })
                .buttonStyle(BorderlessButtonStyle())
                .fullScreenCover(isPresented: $showingMedicineSheetView) {
                    MedicationSheetView
                }
            }
            .listRowSeparator(.hidden)
            Section {
                if !viewModel.medications.isEmpty {
                    MedicationView(viewModel: MedicationViewModel(pet: viewModel.pet, medications: $viewModel.medications))
                }
            }
            .listRowInsets(.init())
            .padding(.horizontal, 20)
            .padding(.vertical, 4)
            .listRowSeparator(.hidden)
            
            // MARK: - Vet Appointment Section
            HStack {
                Text("Vet Appointments")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                Spacer()
                Button(action: {
                    showingVetAppointmentSheetView.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .padding(.bottom, -4)
                })
                .buttonStyle(BorderlessButtonStyle())
                .fullScreenCover(isPresented: $showingVetAppointmentSheetView) {
                    VetAppointmentSheetView
                }
            }
            .listRowSeparator(.hidden)
            Section {
                if !viewModel.pet.vetAppointments.isEmpty {
                    VetAppointmentView(viewModel: VetAppointmentViewModel(pet: viewModel.pet, vetAppointments: $viewModel.vetAppointments))
                }
            }
            .listRowInsets(.init())
            .padding(.horizontal, 20)
            .padding(.vertical, 4)
            .listRowSeparator(.hidden)
            
            // MARK: - Vaccine Section
            HStack {
                Text("Vaccine Records")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                Spacer()
                Button(action: {
                    showingVaccineSheetView.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .padding(.bottom, -4)
                })
                .buttonStyle(BorderlessButtonStyle())
                .fullScreenCover(isPresented: $showingVaccineSheetView) {
                    VaccineSheetView
                }
            }
            .listRowSeparator(.hidden)
            Section {
                if !viewModel.pet.vaccines.isEmpty {
                    VaccineView(viewModel: VaccineViewModel(pet: viewModel.pet, vaccines: $viewModel.vaccines))
                }
            }
            .listRowInsets(.init())
            .padding(.horizontal, 20)
            .padding(.vertical, 4)
            .listRowSeparator(.hidden)
            
            
            Text("If you don't see an item appear right after you added it, exit this screen and then re-enter it. You will see your new item upon doing this!")
                .font(.footnote)
                .fontWeight(.regular)
                .italic()
                .foregroundColor(Color(.systemGray2))
                .padding(.top, 20)
                .listRowSeparator(.hidden)
            
            //using this sort of like a spacer just to make some room at the bottom of the list
            Text("")
        }
        .frame(height: .infinity)
        .listStyle(PlainListStyle())
        .background(Color(hex: 0x6A2956))
        //.scrollContentBackground(.hidden)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }


    // MARK: - Image Picker View
    var ImgPicker: some View {
        Picker(selection: $viewModel.selectedImg, label: Text("Select Image")) {
            ForEach(viewModel.img, id: \.self) { imageName in
               Text(imageName).tag(imageName)
           }
       }
       .pickerStyle(WheelPickerStyle())
       .padding()
    }
    
    //MARK: - Activity Form Sheet
    var ActivitySheetView: some View {
        NavigationView {
            Form {
                TextField("Activity Name", text: $viewModel.activityName)
                    .foregroundColor(Color.black)
                Button("Save") {
                    Task { @MainActor in
                        await viewModel.addActivity(pet_id: viewModel.pet.id, activityName: viewModel.activityName)
                        viewModel.activityName = ""
                    }
                    showingActivitySheetView = false
                }
                .disabled(viewModel.activityName.isEmpty)
                .foregroundColor(Color(hex: 0xFFB63C))
            }
            .navigationTitle("Add Item")
            .navigationBarItems(leading: Button("Dismiss") {
                showingActivitySheetView = false
            })
            .foregroundColor(Color(hex: 0xFFB63C))
        }
    }
    
    //MARK: - Meal Schedule Form Sheet
    var MealScheduleSheetView: some View {
        NavigationView {
            Form {
                DatePicker("Meal Time", selection: $viewModel.mealTime, displayedComponents: [.hourAndMinute])
                    .foregroundColor(Color.black)
                Picker(selection: $viewModel.foodType, label: Text("Food Type")) {
                    ForEach(foodTypeOptions, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .foregroundColor(Color.black)
                TextField("Food Amount", text: $viewModel.foodAmount)
                    .foregroundColor(Color.black)
                TextField("Special Instructions (Optional)", text: $viewModel.specialInstructions)
                    .foregroundColor(Color.black)
                Toggle(isOn: $mealScheduleNotificationEnabled) {
                    Text("Enable feeding time reminder for this item?")
                        .foregroundColor(Color.black)
                }
                .toggleStyle(SwitchToggleStyle(tint: .green))
                Button("Save") {
                    Task { @MainActor in
                        await viewModel.addMealSchedule(pet_id: viewModel.pet.id, mealTime: viewModel.mealTime, foodType: viewModel.foodType, foodAmount: viewModel.foodAmount, specialInstructions: viewModel.specialInstructions)
                        if (mealScheduleNotificationEnabled) {
                            scheduleNotification(time: viewModel.mealTime, title: "Meal Time", body: "It's time to feed your pet!")
                        }
                        viewModel.mealTime = Date.now
                        viewModel.foodType = ""
                        viewModel.foodAmount = ""
                        viewModel.specialInstructions = ""
                    }
                    showingMealScheduleSheetView = false
                }
                .disabled(viewModel.foodType.isEmpty ||
                          viewModel.foodAmount.isEmpty) 
                .foregroundColor(Color(hex: 0xFFB63C))
            }
            .navigationTitle("Add Item")
            .navigationBarItems(leading: Button("Dismiss") {
                showingMealScheduleSheetView = false
            })
            .foregroundColor(Color(hex: 0xFFB63C))
        }
    }
    
    //MARK: - Medication Form Sheet
    var MedicationSheetView: some View {
        NavigationView {
            Form {
                TextField("Medication Name", text: $viewModel.medName)
                    .foregroundColor(Color.black)
                TextField("Dosage", text: $viewModel.dosage)
                    .foregroundColor(Color.black)
                TextField("Frequency", text: $viewModel.frequency)
                    .foregroundColor(Color.black)
                DatePicker("Start Date", selection: $viewModel.startDate, displayedComponents: [.date])
                    .foregroundColor(Color.black)
                DatePicker("End Date", selection: $viewModel.endDate, displayedComponents: [.date])
                    .foregroundColor(Color.black)
                Button("Save") {
                    Task { @MainActor in
                        await viewModel.addMedication(pet_id: viewModel.pet.id, medName: viewModel.medName, dosage: viewModel.dosage, frequency: viewModel.frequency, startDate: viewModel.startDate, endDate: viewModel.endDate)
                        viewModel.medName = ""
                        viewModel.dosage = ""
                        viewModel.frequency = ""
                        viewModel.startDate = Date.now
                        viewModel.endDate = Date.now
                    }
                    showingMedicineSheetView = false
                }
                .disabled(viewModel.medName.isEmpty ||
                          viewModel.dosage.isEmpty ||
                          viewModel.frequency.isEmpty)
                .foregroundColor(Color(hex: 0xFFB63C))
            }
            .navigationTitle("Add Item")
            .navigationBarItems(leading: Button("Dismiss") {
                showingMedicineSheetView = false
            })
            .foregroundColor(Color(hex: 0xFFB63C))
        }
    }
    
    //MARK: - Vet Appointment Form Sheet
    var VetAppointmentSheetView: some View {
        NavigationView {
            Form {
                TextField("Appointment Name", text: $viewModel.appointmentName)
                    .foregroundColor(Color.black)
                DatePicker("Date & Time", selection: $viewModel.dateAndTime, displayedComponents: [.date, .hourAndMinute])
                    .foregroundColor(Color.black)
                Button("Save") {
                    Task { @MainActor in
                        await viewModel.addVetAppointment(pet_id: viewModel.pet.id, appointmentName: viewModel.appointmentName, dateAndTime: viewModel.dateAndTime)
                        viewModel.appointmentName = ""
                        viewModel.dateAndTime = Date.now
                    }
                    showingVetAppointmentSheetView = false
                }
                .disabled(viewModel.appointmentName.isEmpty)
                .foregroundColor(Color(hex: 0xFFB63C))
            }
            .navigationTitle("Add Item")
            .navigationBarItems(leading: Button("Dismiss") {
                showingVetAppointmentSheetView = false
            })
            .foregroundColor(Color(hex: 0xFFB63C))
        }
    }
    
    //MARK: - Vaccine Form Sheet
    var VaccineSheetView: some View {
        NavigationView {
            Form {
                TextField("Vaccine Name", text: $viewModel.vaccineName)
                    .foregroundColor(Color.black)
                DatePicker("Date Administered", selection: $viewModel.dateAdministered, displayedComponents: [.date, .hourAndMinute])
                    .foregroundColor(Color.black)
                Button("Save") {
                    Task { @MainActor in
                        await viewModel.addVaccine(pet_id: viewModel.pet.id, vaccineName: viewModel.vaccineName, dateAdministered: viewModel.dateAdministered)
                        viewModel.vaccineName = ""
                        viewModel.dateAdministered = Date.now
                    }
                    showingVaccineSheetView = false
                }
                .disabled(viewModel.vaccineName.isEmpty)
                .foregroundColor(Color(hex: 0xFFB63C))
            }
            .navigationTitle("Add Item")
            .navigationBarItems(leading: Button("Dismiss") {
                showingVaccineSheetView = false
            })
            .foregroundColor(Color(hex: 0xFFB63C))
        }
    }
    
    // MARK: - Date Formatter
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // MARK: - Schedule Notification
    func scheduleNotification(time: Date, title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        print(Calendar.current.dateComponents([.hour, .minute], from: time))
 
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
        dateComponents.second = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
 
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
 
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Notification did not set.")
                    alertTitle = "Error"
                    alertMessage = "Failed to set reminder. Contact support if this issue persists."
                    showingAlert = true
                }
            } else {
                DispatchQueue.main.async {
                    print("Notification was set.")
                    alertTitle = "Reminder Set"
                    alertMessage = "Your reminder has been set for \(time.formatted(date: .omitted, time: .shortened))!"
                    showingAlert = true
                }
            }
        }
    }
}


// MARK: - Notification Manager
class NotificationManager {
    static let shared = NotificationManager()
 
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission denied with error \(error.localizedDescription).")
            }
        }
    }
}


//MARK: - Activity Rows
struct ActivityView: View {
    @ObservedObject var viewModel: ActivityViewModel
    
    var body: some View {
        ForEach(viewModel.activities) { activity in
            ActivityRowView(viewModel: ActivityRowViewModel(pet: viewModel.pet, activity: activity))
        }
        .onDelete(perform: deleteItems)
    }
    
    private func deleteItems(at offsets: IndexSet) {
        Task { @MainActor in
            await FirebaseTools().deleteActivity(at: offsets.first, activityList: viewModel.activities, pet_id: viewModel.pet.id)
            viewModel.activities.remove(atOffsets: offsets)
        }
    }
}

//MARK: - Meal Schedule Rows
struct MealScheduleView: View {
    @ObservedObject var viewModel: MealScheduleViewModel
    
    var body: some View {
        ForEach(viewModel.mealSchedules) { mealSchedule in
            MealScheduleRowView(viewModel: MealScheduleRowViewModel(pet: viewModel.pet, mealSchedule: mealSchedule))
        }
        .onDelete(perform: deleteItems)
    }
    
    private func deleteItems(at offsets: IndexSet) {
        Task { @MainActor in
            await FirebaseTools().deleteMealSchedule(at: offsets.first, mealScheduleList: viewModel.mealSchedules, pet_id: viewModel.pet.id)
            viewModel.mealSchedules.remove(atOffsets: offsets)
        }
    }
}

//MARK: - Medication Rows
struct MedicationView: View {
    @ObservedObject var viewModel: MedicationViewModel
    
    var body: some View {
        ForEach(viewModel.medications) { medication in
            MedicationRowView(viewModel: MedicationRowViewModel(pet: viewModel.pet, medication: medication))
        }
        .onDelete(perform: deleteItems)
    }
    
    private func deleteItems(at offsets: IndexSet) {
        Task { @MainActor in
            await FirebaseTools().deleteMedication(at: offsets.first, medicationList: viewModel.medications, pet_id: viewModel.pet.id)
            viewModel.medications.remove(atOffsets: offsets)
        }
    }
}

//MARK: - Vet Appointment Rows
struct VetAppointmentView: View {
    @ObservedObject var viewModel: VetAppointmentViewModel
    
    var body: some View {
        ForEach(viewModel.vetAppointments) { vetAppointment in
            VetAppointmentRowView(viewModel: VetAppointmentRowViewModel(pet: viewModel.pet, vetAppointment: vetAppointment))
        }
        .onDelete(perform: deleteItems)
    }
    
    private func deleteItems(at offsets: IndexSet) {
        Task { @MainActor in
            await FirebaseTools().deleteVetAppointment(at: offsets.first, vetAppointmentList: viewModel.vetAppointments, pet_id: viewModel.pet.id)
            viewModel.vetAppointments.remove(atOffsets: offsets)
        }
    }
}

//MARK: - Vaccine Rows
struct VaccineView: View {
    @ObservedObject var viewModel: VaccineViewModel
    
    var body: some View {
        ForEach(viewModel.vaccines) { vaccine in
            VaccineRowView(viewModel: VaccineRowViewModel(pet: viewModel.pet, vaccine: vaccine))
        }
        .onDelete(perform: deleteItems)
    }
    
    private func deleteItems(at offsets: IndexSet) {
        Task { @MainActor in
            await FirebaseTools().deleteVaccine(at: offsets.first, vaccineList: viewModel.vaccines, pet_id: viewModel.pet.id)
            viewModel.vaccines.remove(atOffsets: offsets)
        }
    }
}




//#Preview {
//    PetHomeView(settingsViewModel: SettingsViewModel())
//}
