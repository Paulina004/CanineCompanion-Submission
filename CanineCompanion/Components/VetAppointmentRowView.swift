//
//  VetAppointmentsRowView.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/3/24.
//

import SwiftUI

struct VetAppointmentRowView: View {
    @ObservedObject var viewModel: VetAppointmentRowViewModel
    
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Rectangle()
                    .fill(Color(hex: 0x7975F7))
                    .frame(width: 60)
                    .cornerRadius(radius: 15, corners: [.topRight, .bottomRight])
                Image(systemName: "heart.text.square.fill")
                    .imageScale(.medium)
                    .font(.title)
                    .padding(10)
                    .foregroundColor(Color(.white))
            }
            VStack(alignment: .leading) {
                Text(viewModel.vetAppointment.appointmentName)
                    .font(.headline)
                    .foregroundColor(Color.black)
                Text("\(formattedTime(from: viewModel.vetAppointment.dateAndTime))")
            }
            Spacer()
        }
        .frame(height: 60)
        .background(Color(hex: 0x7975F7).opacity(0.5))
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
//    VetAppointmentRowView(appointmentName: "Meeting w/ Dr. Smith", dateAndTime: Date.now)
//}
