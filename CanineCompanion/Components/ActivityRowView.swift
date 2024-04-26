//
//  SwiftUIView.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/3/24.
//

import SwiftUI



struct ActivityRowView: View {
    @ObservedObject var viewModel: ActivityRowViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Rectangle()
                    .fill(Color(hex: 0x7975F7))
                    .frame(width: 60)
                    .cornerRadius(radius: 15, corners: [.topRight, .bottomRight])
                Image(systemName: "figure.run")
                    .imageScale(.medium)
                    .font(.title)
                    .padding(10)
                    .foregroundColor(Color(.white))
            }
            VStack(alignment: .leading) {
                Text(viewModel.activity.activityName)
                    .font(.headline)
                    .foregroundColor(Color.black)
            }
            Spacer()
            Image(systemName: viewModel.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(Color(hex: 0x7975F7))
                .onTapGesture {
                    Task { @MainActor in
                        await viewModel.updateIsCompletedState()
                    }
                }
                .padding(10)
        }
        .frame(height: 60)
        .background(Color(hex: 0x7975F7).opacity(0.5))
        .cornerRadius(15)
    }
}



//#Preview {
//    ActivityRowView(viewModel: ActivityRowViewModel(activityName: "Walking", isCompleted: false))
//}
