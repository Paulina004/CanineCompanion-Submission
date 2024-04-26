//
//  MapView.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 3/27/24.
//

import MapKit
import SwiftUI
 

struct DogParksView: View {
    @StateObject private var viewModel = DogParksViewModel()
    @State private var address = ""
    @State private var selectedPark: DogPark? // To track the selected dog park for showing its address
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: false, annotationItems: viewModel.dogParks) { dogPark in
                MapAnnotation(coordinate: dogPark.coordinate) {
                    VStack {
                        Image(systemName: "pawprint.fill")
                            .foregroundColor(Color(hex: 0x6A2956))
                            .imageScale(.large)
                            .onTapGesture {
                                self.selectedPark = dogPark // Assign the selected dog park
                            }
                        Text(dogPark.name)
                            .fixedSize(horizontal: false, vertical: true)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: 0x6A2956))
                    }
                }
            }
            .ignoresSafeArea()
            
            VStack {
                AccountInputView(text: $address, placeholder: "1234 Main St, City, State, Zip")
                    .padding(.horizontal, -20)
                Button(action: {
                    viewModel.findDogParksByAddress(address: address)
                }) {
                    Text("Find Dog Parks")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.white)
                        .background(Color(hex: 0x6A2956))
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                }
                Spacer()
            }
            
            
            if viewModel.isLoading {
                ProgressView("Finding dog parks...")
            }
            // Display the selected dog park's address with a dismiss button
            if let selectedPark = selectedPark {
                VStack {
                    Spacer()
                    
                    VStack(spacing: 0) {
                        HStack {
                            Spacer()
                            Button(action: {
                                self.selectedPark = nil // Dismiss the details view
                            }) {
                                Image(systemName: "xmark.circle")
                                    .imageScale(.large)
                                    .foregroundColor(.red)
                            }
                            
                        }
                        .padding(5)
                        .padding(.bottom, 5)
                        .background(.white)
                        .cornerRadius(radius: 15, corners: [.topLeft, .topRight])
                        
                        if let address = selectedPark.address {
                            HStack(alignment: .center){
                                Text(address)
                                    
                            }
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color.white)
                            
                            if let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: "http://maps.apple.com/?q=\(encodedAddress)") {
                                Link(destination: url) {
                                    Text("Open in Maps")
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .padding()
                                        .background(Color.white)
                                        .foregroundColor(.blue)
                                        .cornerRadius(radius: 15, corners: [.bottomLeft, .bottomRight])
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    class DogParksViewModel: ObservableObject {
        @Published var region = MKCoordinateRegion()
        @Published var dogParks: [DogPark] = []
        @Published var isLoading = false
        
        func findDogParksByAddress(address: String) {
            let geocoder = CLGeocoder()
            isLoading = true
            geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
                guard let self = self, let placemark = placemarks?.first, let coordinate = placemark.location?.coordinate else {
                    self?.isLoading = false
                    return
                }
                self.zoomToLocation(coordinate)
                self.findDogParks(near: coordinate)
            }
        }
        
        private func zoomToLocation(_ coordinate: CLLocationCoordinate2D) {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            region = MKCoordinateRegion(center: coordinate, span: span)
        }
        
        private func findDogParks(near coordinate: CLLocationCoordinate2D) {
            isLoading = true
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = "dog park"
            let searchRegion = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            request.region = searchRegion
            
            let search = MKLocalSearch(request: request)
            search.start { [weak self] response, _ in
                guard let self = self, let response = response else {
                    self?.isLoading = false
                    return
                }
                
                self.dogParks = response.mapItems.compactMap { item in
                    let name = item.name ?? "Unknown"
                    let coordinate = item.placemark.coordinate
                    // Constructing a more complete address string
                    let addressComponents = [
                        item.placemark.subThoroughfare, // Street number
                        item.placemark.thoroughfare,    // Street name
                        item.placemark.locality,        // City
                        item.placemark.administrativeArea, // State
                        item.placemark.postalCode       // ZIP code
                    ]
                    let address = addressComponents.compactMap { $0 }.joined(separator: ", ")
                    return DogPark(name: name, coordinate: coordinate, address: address.isEmpty ? nil : address)
                }
                self.isLoading = false
            }
        }
    }
    
    struct DogPark: Identifiable {
        let id = UUID()
        let name: String
        let coordinate: CLLocationCoordinate2D
        var address: String? // Added address property
    }
}
 
    extension Color {
        init(hex: String) {
            let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            var int = UInt64()
            Scanner(string: hex).scanHexInt64(&int)
            let a, r, g, b: UInt64
            switch hex.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (255, 0, 0, 0)
            }
            
            self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue:  Double(b) / 255, opacity: Double(a) / 255)
        }
    }
 

#Preview {
    DogParksView()
}
