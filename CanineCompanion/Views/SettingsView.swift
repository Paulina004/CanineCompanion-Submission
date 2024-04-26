//
//  SettingsView.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 3/30/24.
//

import SwiftUI



struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var showingAboutScreen = false
    @State private var showingDeleteAlert = false
    @State private var showingLogoutAlert = false
    @State private var showingAddPetAlert = false
    @State private var showingEditPasswordView = false
    @State private var showingAddPetView = false
    @State private var showingDeletePetView = false
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var settingsViewModel: SettingsViewModel
    let firebaseTools = FirebaseTools()
    // for segmented picker
    let sexOptions = ["Male", "Female"]
    @State var pets: [Pet] = []
    
    public init(settingsViewModel: SettingsViewModel) {
        self.settingsViewModel = settingsViewModel
    }
    
    
    var body: some View {
        if let user = authViewModel.currentUser {
            ZStack {
                Color(hex: 0xFFB63C)
                    .edgesIgnoringSafeArea(.all)
                List {
                    // MARK: - Account Header
                    Section {
                        HStack {
                            Text(user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 72, height: 72)
                                .background(Color(hex: 0xA05A8B))
                                .clipShape(Circle())
                            VStack(alignment: .leading, spacing:4) {
                                Text(user.fullName)
                                    .font(.subheadline)
                                    .fontWeight(.black)
                                    .foregroundColor(.white)
                                    .padding(.top, 4)
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(Color(.white))
                            }
                        }
                        .padding(10)
                    }
                    .listRowBackground(
                        Rectangle()
                            .foregroundColor(Color(hex: 0x6A2956))
                            .cornerRadius(20)
                            .padding(5)
                    )
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color(.white))
                    
                    // MARK: - Account
                    Section("Account") {
                        //edit password
                        Button(action: {
                            showingEditPasswordView.toggle()
                        }, label: {
                            SettingsRowView(imageName: "lock.circle.fill", title: "Edit Password", tintColor: Color(.systemTeal))
                        })
                        .fullScreenCover(isPresented: $showingEditPasswordView) {
                            EditPasswordView
                        }
                        //sign out
                        Button(action: {
                            showingLogoutAlert.toggle()
                        }, label: {
                            SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: Color(.blue))
                        })
                        .alert(isPresented: $showingLogoutAlert) {
                            Alert(
                                title: Text("Are you sure you want to sign out of your account?"),
                                primaryButton: .destructive(Text("Yes")) {
                                    authViewModel.signOut()
                                },
                                secondaryButton: .cancel(Text("No"))
                            )
                        }
                        // delete account
                        Button(action: {
                            showingDeleteAlert.toggle()
                        }, label: {
                            SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: Color(.red))
                        })
                        .alert(isPresented: $showingDeleteAlert) {
                            Alert(
                                title: Text("Are you sure you want to delete your account?"),
                                primaryButton: .destructive(Text("Yes")) {
                                    authViewModel.deleteAccount()
                                },
                                secondaryButton: .cancel(Text("No"))
                            )
                        }
                    }
                    .listRowBackground(
                        Capsule()
                            .foregroundColor(Color(.systemGray5))
                            .padding(4)
                    )
                    .listRowSeparator(.hidden)
                    .foregroundColor(Color(.black))
                    .fontWeight(.bold)
                    
                    // MARK: - Pets
                    Section("Pets") {
                        
                            Button {
                                showingAddPetView.toggle()
                            } label: {
                                SettingsRowView(imageName: "dog.circle.fill", title: "Add Pet", tintColor: Color(.systemGreen))
                            }
                            .fullScreenCover(isPresented: $showingAddPetView) {
                                AddPetView
                            }
                            
                            Button {
                                showingDeletePetView.toggle()
                            } label: {
                                SettingsRowView(imageName: "trash.circle.fill", title: "Delete Pet", tintColor: Color(.red))
                            }
                            .fullScreenCover(isPresented: $showingDeletePetView) {
                                DeletePetView(viewModel: SettingsViewModel())
                            }
                        
                    }
                    .listRowBackground(
                        Capsule()
                            .foregroundColor(Color(.systemGray5))
                            .padding(4)
                    )
                    .listRowSeparator(.hidden)
                    .foregroundColor(Color(.black))
                    .fontWeight(.bold)
                    
                    
                    // MARK: - General
                    Section("General") {
//                        Toggle(isOn: $notificationsEnabled) {
//                            HStack {
//                                SettingsRowView(imageName: "bell.fill", title:"Enable Notifications", tintColor: .orange)
//                            }
//                        }
                        Button(action: {
                            showingAboutScreen.toggle()
                        }, label: {
                            SettingsRowView(imageName: "info.circle.fill", title: "About", tintColor: Color(.lightGray))
                        })
                        .fullScreenCover(isPresented: $showingAboutScreen) {
                            AboutView
                        }
                    }
                    .listRowBackground(
                        Capsule()
                            .foregroundColor(Color(.systemGray5))
                            .padding(4)
                    )
                    .listRowSeparator(.hidden)
                    .foregroundColor(Color(.black))
                    .fontWeight(.bold)
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
                .padding()
                .background(Color(.white))
            }
        }
    }
    
    // MARK: - About View
    var AboutView: some View {
        NavigationView {
            Form {
                Section(header: Text("App Info").fontWeight(.semibold).foregroundColor(.black)) {
                    HStack {
                        Text("Version:")
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                            .fontWeight(.none)
                    }
                    HStack {
                        Text("Developed by:")
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("Paulina DeVito, Jenna Leali, Rawan Alhindi, Jamar Andrade, Marty Cheng")
                            .foregroundColor(.secondary)
                            .fontWeight(.none)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section(header: Text("Credits").fontWeight(.semibold).foregroundColor(.black)) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Dog images and vectors used within this app are credited to Terdpongvector / Freepik.")
                            .fixedSize(horizontal: false, vertical: true)
                            .fontWeight(.none)
                            .foregroundColor(.black)
                        Link(destination: URL(string: "http://www.freepik.com")!) {
                            HStack {
                                Image(systemName: "link") // added an icon
                                Text("Designed by Terdpongvector / Freepik")
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(Color(hex: 0xFFB63C))
                        }
                    }
                }
                
                Section(header: Text("License").fontWeight(.semibold).foregroundColor(.black)) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Images are used under the terms described by Freepik's standard licensing agreement. For full terms, visit Freepik's website.")
                            .fixedSize(horizontal: false, vertical: true)
                            .fontWeight(.none)
                            .foregroundColor(.black)
                        Link(destination: URL(string: "http://www.freepik.com/terms_of_use")!) {
                            HStack {
                                Image(systemName: "doc.text") // added an icon
                                Text("Freepik Terms of Use")
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(Color(hex: 0xFFB63C))
                        }
                    }
                }
            }
            .navigationTitle("About")
            .navigationBarItems(leading: Button("Dismiss") {
                showingAboutScreen = false
            })
            .foregroundColor(Color(hex: 0xFFB63C))
        }
        .fontWeight(.none)
    }
    
    // MARK: - Edit Password View
    var EditPasswordView: some View {
        NavigationView {
            Form {
                Text("You must re-authenticate yourself by signing out and logging in again to change your password.")
                    .font(.footnote)
                    .fontWeight(.semibold)
                Section {
                    SecureField("Enter New Password", text: $newPassword)
                    SecureField("Confirm New Password", text: $confirmPassword)
                    Button("Save") {
                         if formIsValid {
                             authViewModel.editPassword(for: newPassword)
                             showingEditPasswordView = false
                         }
                    }
                }
            }
            .navigationTitle("Edit Password")
            .navigationBarItems(leading: Button("Dismiss") {
                showingEditPasswordView = false
            })
            .foregroundColor(Color(hex: 0xFFB63C))
        }
        .fontWeight(.none)
    }
    
    
    var AddPetView: some View {
        
        NavigationView {
            Form {
                TextField("Name", text: $settingsViewModel.name)
                    .foregroundColor(Color.black)
                    .fontWeight(.regular)
                TextField("Breed", text: $settingsViewModel.breed)
                    .foregroundColor(Color.black)
                    .fontWeight(.regular)
                DatePicker(selection: $settingsViewModel.birthday, in: ...Date.now, displayedComponents: .date) {
                    Text("Birthday")
                }
                .foregroundColor(Color.black)
                .fontWeight(.regular)
                HStack {
                    Text("Age (Calculated Automatically)")
                        .foregroundColor(Color.black)
                        .fontWeight(.regular)
                    Spacer()
                    Text("\($settingsViewModel.age.wrappedValue)")
                        .foregroundColor(Color.black)
                        .fontWeight(.regular)
                }
                Picker(selection: $settingsViewModel.sex, label: Text("Sex")) {
                    ForEach(sexOptions, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .foregroundColor(Color.black)
                .fontWeight(.regular)
                TextField("Weight (in lbs)", text: $settingsViewModel.weight)
                    .foregroundColor(Color.black)
                    .fontWeight(.regular)
                    .keyboardType(.decimalPad)  // ensures the answer is a double
                
                
                Button("Save") {
                    Task {
                        let firebaseTools = FirebaseTools()
                        pets = await firebaseTools.retrievePets()
                        print("DEBUG: Pets count is \(pets.count).")
                        var petLimitMet = pets.count > 15
                        print("DEBUG: PetLimitMet is \(petLimitMet).")
                        if petLimitMet {
                            showingAddPetAlert = true
                        } else {
                            let firebaseTools = FirebaseTools(name: settingsViewModel.name,
                                                              breed: settingsViewModel.breed,
                                                              birthday: settingsViewModel.birthday,
                                                              age: settingsViewModel.age,
                                                              sex: settingsViewModel.sex,
                                                              weight: settingsViewModel.weight)
                            Task { @MainActor in
                                await firebaseTools.addPet()
                            }
                            settingsViewModel.name = ""
                            settingsViewModel.breed = ""
                            settingsViewModel.birthday = Date.now
                            settingsViewModel.sex = ""
                            settingsViewModel.weight = ""
                            showingAddPetView = false
                        }
                    }
                }
                .disabled(settingsViewModel.name.isEmpty ||
                          settingsViewModel.breed.isEmpty ||
                          settingsViewModel.sex.isEmpty ||
                          settingsViewModel.weight.isEmpty)
                .alert(isPresented: $showingAddPetAlert) {
                    Alert(title: Text("Pet Limit Exceeded"),
                          message: Text("You have reached the maximum limit of pets. You cannot register more than 15 pets per account."),
                          dismissButton: .default(Text("OK")))
                }
                .foregroundColor(Color(hex: 0xFFB63C))
            }
            .navigationTitle("Add Pet")
            .navigationBarItems(leading: Button("Dismiss") {
                showingAddPetView = false
            })
            .foregroundColor(Color(hex: 0xFFB63C))
        }
    }
    
    
    // MARK: -
}



extension SettingsView: AuthFormProtocol {
    var formIsValid: Bool {
        return !newPassword.isEmpty
        && !confirmPassword.isEmpty
        && newPassword == confirmPassword
        && newPassword.count > 5
        && confirmPassword.count > 5
    }
}



// MARK: - Delete Pet View
struct DeletePetView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            if !viewModel.pets.isEmpty {
                List {
                    Section("Swipe left to remove a pet from your account.") {
                        ForEach(viewModel.pets, id: \.id) { pet in
                            HStack {
                                Text(pet.name)
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listRowInsets(.init())
                    .padding()
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
                .background(Color(.systemGray5))
            } else {
                Spacer()
                Text("You don't have any pets to delete.")
            }
            Spacer()
            Button("Cancel") {
                dismiss()
            }
            .padding()
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        Task { @MainActor in
            await FirebaseTools().deletePet(at: offsets.first, petsList: viewModel.pets)
            viewModel.pets.remove(atOffsets: offsets)
        }
    }
}



//#Preview {
//    SettingsView()
//}
