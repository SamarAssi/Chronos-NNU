//
//  AvailabilityChangeDetailsView.swift
//  Chronos
//
//  Created by Samar Assi on 23/05/2024.
//

import SwiftUI

struct AvailabilityChangeDetailsView: View {
    @State private var date = Date()
    @State private var buttons: [AvailabilityButtonModel] = AvailabilityButtonModel.data
    @Environment(\.dismiss) var dismiss

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter.string(from: date)
    }
    
    var body: some View {
        NavigationStack {
            VStack(
                spacing: 15
            ) {
                Divider()
                Spacer()
                middleDivider
                Spacer()
                Divider()
                Text(LocalizedStringKey("Request submitted on \(formattedDate)"))
                    .padding(.top, 2)
                buttonsView
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    backButtonView
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    titleView
                }
            }
            .fontDesign(.rounded)
        }
    }
}

extension AvailabilityChangeDetailsView {
    var backButtonView: some View {
        Image(systemName: "lessthan")
            .scaleEffect(0.6)
            .scaleEffect(x: 1, y: 2)
            .onTapGesture {
                dismiss.callAsFunction()
            }
    }
    
    var titleView: some View {
        Text(LocalizedStringKey("Availability Change Details"))
            .font(.title3)
            .fontWeight(.bold)
            .padding(.leading)
    }

    var buttonsView: some View {
        HStack {
            ForEach(buttons) { button in
                MainButton(
                    isLoading: .constant(false),
                    buttonText: button.text,
                    backgroundColor: button.backgroundColor,
                    action: {
                        
                    }
                )
                .shadow(radius: 2, x: 0, y: 2)
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    var middleDivider: some View {
        ZStack {
            Divider()
            Circle()
                .fill(Color.white)
                .frame(width: 60)
                .shadow(radius: 1)
                .overlay {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 50)
                        .overlay {
                            Image(systemName: "clock")
                                .font(.system(size: 30))
                                .foregroundStyle(Color.white)
                        }
                }
        }
    }
}

#Preview {
    AvailabilityChangeDetailsView()
}
