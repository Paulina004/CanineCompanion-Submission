//
//  MealScheduleRowView.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/3/24.
//

import SwiftUI

struct MealScheduleRowView: View {
    @ObservedObject var viewModel: MealScheduleRowViewModel
    
    var body: some View {
        
        HStack(spacing: 12) {
            ZStack {
                Rectangle()
                    .fill(Color(hex: 0xFE5C12))
                    .frame(width: 60)
                    .cornerRadius(radius: 15, corners: [.topRight, .bottomRight])
                Image(systemName: "fork.knife")
                    .imageScale(.medium)
                    .font(.title)
                    .padding(10)
                    .foregroundColor(Color(.white))
            }
            VStack(alignment: .leading) {
                Text(viewModel.mealSchedule.foodType)
                    .font(.headline)
                    .foregroundColor(Color.black)
                Text(viewModel.mealSchedule.specialInstructions)
                    .font(.footnote)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(viewModel.mealSchedule.foodAmount)
                    .font(.subheadline)
                    .foregroundColor(Color.black)
                Text("\(formattedTime(from: viewModel.mealSchedule.mealTime))")
            }
            .padding(10)
        }
        .frame(height: 60)
        .background(Color(hex: 0xFE5C12).opacity(0.5))
        .cornerRadius(15)
    }
    
    func formattedTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}



//#Preview {
//    MealScheduleRowView(mealTime: Date.now, foodType: "Breakfast", foodAmount: "2 cups", specialInstructions: "Very important.")
//}
