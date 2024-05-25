//
//  AvailabilityView.swift
//  Chronos
//
//  Created by Samar Assi on 15/05/2024.
//

import SwiftUI

struct AvailabilityView: View {
    @State private var weekdayModel = WeekdayModel()
    @State private var showDetailsView = false
    @State var response: AvailabilityResponse?
    
    @StateObject private var availabilityModel = AvailabilityModel()
    
    var body: some View {
        VStack(
            alignment: .leading
        ) {
            titleView
            WeekdaysView(weekdayModel: weekdayModel)
            schedulingView
            sendRequestButtonView
        }
        .fontDesign(.rounded)
        .fullScreenCover(isPresented: $showDetailsView) {
            AvailabilityChangeDetailsView()
        }
        .task {
            do {
                response = try await performAvailabilityRequest()
            } catch let error {
                print(error)
            }
        }
    }
    
    private func performAvailabilityRequest() async throws -> AvailabilityResponse {
        return try await AuthenticationClient.availability()
    }
}

extension AvailabilityView {
    var titleView: some View {
        Text(LocalizedStringKey("Availability"))
            .font(.title2)
            .fontWeight(.bold)
            .padding(.horizontal)
    }
    
    var schedulingView: some View {
        Group {
            if weekdayModel.selectedIndices.isEmpty {
                Text(LocalizedStringKey("You're unavailable for all days"))
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .center
                    )
                    .foregroundStyle(Color.gray)
            } else {
                if weekdayModel.selectedIndices.count > 0 {
                    HStack(spacing: 25) {
                        Text(LocalizedStringKey("START TIME"))
                            .padding(.trailing, 6)
                        Text(LocalizedStringKey("END TIME"))
                            .padding(.leading, 6)
                    }
                    .padding(.top, 8)
                    .padding(.trailing)
                    .font(.system(size: 14))
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
                List(
                    weekdayModel.selectedIndices,
                    id: \.self
                ) { index in
                    schedule(index: index)
                        .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
                .scrollIndicators(.hidden)
            }
        }
    }
    
    var sendRequestButtonView: some View {
        MainButton(
            isLoading: .constant(false),
            buttonText: LocalizedStringKey("Send Request"),
            backgroundColor: Color.theme,
            action: {
                showDetailsView.toggle()
            }
        )
        .padding()
    }
}

extension AvailabilityView {
    private func datePickerView(index: Int) -> some View {
        HStack(
            spacing: 10
        ) {
            if let response = response {
//                DatePicker(
//                    "Start Time",
//                    selection: ,
//                    displayedComponents: .hourAndMinute
//                )
//                .labelsHidden()
//                .frame(width: 50)
                Image(systemName: "arrow.right")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.theme)
                    .frame(width: 50)
//                DatePicker(
//                    "End Time",
//                    selection:  ,
//                    displayedComponents: .hourAndMinute
//                )
//                .labelsHidden()
//                .frame(width: 50)
            }
        }
    }
    
    private func schedule(index: Int) -> some View {
        HStack {
            if let response = response {
                Text(weekdayModel.weekdays[index].dayTitle)
                    .frame(width: 40, alignment: .leading)
                
                Divider()
                datePickerView(index: index)
                    .frame(width: 220)
                Divider()
                
//                Toggle(
//                    isOn:
//                ) {
//                    Text("")
//                }
//                .labelsHidden()
//                .tint(Color.theme)
//                .onChange(of: ) {
//                    // handleToggleChange
//                }
//                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}


#Preview {
    AvailabilityView()
}
