//
//  VaccineRowView.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/9/24.
//


import SwiftUI

struct VaccineRowView: View {
    @ObservedObject var viewModel: VaccineRowViewModel
    
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Rectangle()
                    .fill(Color(hex: 0xFE5C12))
                    .frame(width: 60)
                    .cornerRadius(radius: 15, corners: [.topRight, .bottomRight])
                Image(systemName: "syringe.fill")
                    .imageScale(.medium)
                    .font(.title)
                    .padding(10)
                    .foregroundColor(Color(.white))
            }
            VStack(alignment: .leading) {
                Text(viewModel.vaccine.vaccineName)
                    .font(.headline)
                    .foregroundColor(Color.black)
                Text("\(formattedTime(from: viewModel.vaccine.dateAdministered))")
            }
            Spacer()
        }
        .frame(height: 60)
        .background(Color(hex: 0xFE5C12).opacity(0.5))
        .cornerRadius(15)
    }
    
    func formattedTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}


//#Preview {
//    VaccineRowView(vaccineName: "Rabies", dateAdministered: Date.now)
//}
