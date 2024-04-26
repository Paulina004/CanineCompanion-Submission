//
//  MedicationsRowView.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/3/24.
//

import SwiftUI

struct MedicationRowView: View {
    @ObservedObject var viewModel: MedicationRowViewModel
    
    
    var body: some View {
        
        HStack(spacing: 12) {
            ZStack {
                Rectangle()
                    .fill(Color(hex: 0xFFB63C))
                    .frame(width: 60)
                    .cornerRadius(radius: 15, corners: [.topRight, .bottomRight])
                Image(systemName: "pills.fill")
                    .imageScale(.medium)
                    .font(.title)
                    .padding(10)
                    .foregroundColor(Color(.white))
            }
            VStack(alignment: .leading) {
                Text(viewModel.medication.medName)
                    .font(.headline)
                    .foregroundColor(Color.black)
                Text("\(formattedTime(from: viewModel.medication.startDate)) - \(formattedTime(from: viewModel.medication.endDate))")
                    .font(.footnote)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(viewModel.medication.dosage)
                    .font(.subheadline)
                    .foregroundColor(Color.black)
                Text("\(viewModel.medication.frequency)")
            }
            .padding(10)
        }
        .frame(height: 60)
        .background(Color(hex: 0xFFB63C).opacity(0.5))
        .cornerRadius(15)
    }
    
    func formattedTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}



//#Preview {
//    MedicationRowView(medName: "Heart Worm", dosage: "1 Tablet", frequency: "Monthly", startDate: Date.now, endDate: Date.now)
//}
