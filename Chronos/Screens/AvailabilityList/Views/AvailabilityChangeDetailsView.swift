//
//  AvailabilityChangeDetailsView.swift
//  Chronos
//
//  Created by Samar Assi on 23/05/2024.
//

import SwiftUI

struct AvailabilityChangeDetailsView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var weekdayModel = WeekdayModel()
    @ObservedObject var availabilityListModel: AvailabilityListModel
    
    @State private var buttons: [AvailabilityButtonModel] = AvailabilityButtonModel.data
    @State private var showingAlert = false
    @State var currentAction = 0
    
    @State private var showSheet = false
    @State private var showConflictAlert = false

    var date: Date
    var index: Int
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter.string(from: date)
    }
    
    var body: some View {
        NavigationStack {
            contentView
        }
        .alert("Comment", isPresented: $showingAlert) {
            TextField("Comment (optional)", text: $availabilityListModel.comment)
            Button("Submit", action: handleAction)
                .foregroundStyle(Color.green)
            Button("Cancel", role: .cancel) {}
                .foregroundStyle(Color.black)
        } message: {
            Text("Would you like to submit a comment with your action?")
        }
        .alert("Conflict", isPresented: $showConflictAlert) {
            Button("OK", role: .cancel) {}
                .foregroundStyle(Color.black)
        } message: {
            Text("There is a conflict with the availability changes, Please resolve all conflicts first")
        }
        .onAppear {
            availabilityListModel.handleAvailabilityChangesResponse(
                at: index
            )
            weekdayModel.getData()
        }
    }
    
    private var contentView: some View {
        VStack(
            alignment: .leading,
            spacing: 0
        ) {
            List {
                newAvailabilityView
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 10, trailing: 0))
                    .listRowSeparator(.hidden)
                
                middleDivider
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 10, trailing: 0))
                    .listRowSeparator(.hidden)
                
                oldAvailabilityView
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 10, trailing: 0))
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .listRowSeparator(.hidden)
            
            Divider()
            requestDateView
            buttonsView
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                cancelButtonView
            }
            
            ToolbarItem(placement: .topBarLeading) {
                titleView
            }
        }
        .fontDesign(.rounded)
        .sheet(isPresented: $showSheet) {
            
            
            let conlicts = availabilityListModel.availabilityChangesResponse?.conflicts ?? []
            let warnings = availabilityListModel.availabilityChangesResponse?.warnings ?? []
            
            ConfictsView(conflicts: conlicts, warnings: warnings)
        }
    }
    
    func handleAction() {
        if currentAction == 0 {
            availabilityListModel.handleRejectionResponse(at: index)
        } else if currentAction == 1 {
            availabilityListModel.handleApprovalResponse(at: index)
        }
        dismiss.callAsFunction()
    }
}

extension AvailabilityChangeDetailsView {
    
    var titleView: some View {
        Text(LocalizedStringKey("Availability Change Details"))
            .font(.title3)
            .fontWeight(.bold)
            .padding(.leading)
    }
    
    var newAvailabilityView: some View {
        VStack(
            alignment: .leading,
            spacing: 0
        ) {
            ForEach(
                weekdayModel.selectedIndices,
                id: \.self
            ) { index in
                
                if let availabilityChangeResponse = availabilityListModel.availabilityChangesResponse {
                    
                    availabilityTime(
                        availabilityChangeResponse.newAvailability,
                        forDay: weekdayModel.weekdays[index].dayTitle,
                        isNew: true
                    )
                    .listRowSeparator(.hidden)
                }
            }
        }
        .padding(.horizontal, 30)
        .padding(.top)
    }
    
    var oldAvailabilityView: some View {
        VStack(
            alignment: .leading
        ) {
            Text(LocalizedStringKey("Current Availability"))
                .font(.system(size: 16))
                .foregroundStyle(Color.gray)
            
            VStack(
                alignment: .leading,
                spacing: 0
            ) {
                ForEach(
                    weekdayModel.selectedIndices,
                    id: \.self
                ) { index in
                    
                    if let availabilityChangeResponse = availabilityListModel.availabilityChangesResponse {
                        
                        availabilityTime(
                            availabilityChangeResponse.oldAvailability,
                            forDay: weekdayModel.weekdays[index].dayTitle,
                            isNew: false
                        )
                        .listRowSeparator(.hidden)
                    }
                    
                }
            }
        }
        .padding(.horizontal, 30)
        .padding(.bottom)
    }
    
    var requestDateView: some View {
        Text(
            LocalizedStringKey("Request submitted on \(formattedDate)")
        )
        .frame(maxWidth: .infinity, alignment: .center)
        .font(.system(size: 15, weight: .bold))
        .padding(.vertical, 8)
        .padding(.bottom, 8)
    }
    
    var cancelButtonView: some View {
        Image(systemName: "xmark")
            .scaleEffect(0.8)
            .onTapGesture {
                dismiss.callAsFunction()
            }
    }
    
    var buttonsView: some View {
        HStack {
            ForEach(
                buttons.indices,
                id: \.self
            ) { specificIndex in
                
                MainButton(
                    isLoading: .constant(false),
                    isEnable: .constant(true),
                    buttonText: buttons[specificIndex].text,
                    backgroundColor: buttons[specificIndex].backgroundColor,
                    action: {
                        self.currentAction = specificIndex

                        if !(availabilityListModel.availabilityChangesResponse?.conflicts.isEmpty ?? true) && specificIndex == 1 {
                            self.showConflictAlert.toggle()
                        } else {
                            self.showingAlert.toggle()
                        }
                    }
                )
                .shadow(radius: 2, x: 0, y: 2)
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    var middleDivider: some View {
        let conlictsCount = availabilityListModel.availabilityChangesResponse?.conflicts.count ?? 0
        let warningsCount = availabilityListModel.availabilityChangesResponse?.warnings.count ?? 0
        
        return ZStack {
            Divider()
            
            Button(action: {
                showSheet.toggle()
            }) {
                HStack {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text("\(conlictsCount)")
                    }
                    HStack {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.yellow)
                        Text("\(warningsCount)")
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(.lightGray)
            .cornerRadius(25)
        }
    }
}

extension AvailabilityChangeDetailsView {
    
    private func availabilityTime(
        _ availabilities: Availabilities,
        forDay day: String,
        isNew: Bool
    ) -> some View {
        HStack {
            Text(day)
                .font(.system(size: 16, weight: .bold))
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            availabilityForDay(
                availabilities,
                dayName: day,
                isNew: isNew
            )
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func availabilityForDay(
        _ availabilities: Availabilities,
        dayName: String,
        isNew: Bool
    ) -> some View {
        Group {
            switch dayName {
            case "Mon":
                setAvailability(
                    forDay: availabilities.monday,
                    isNew: isNew,
                    dayName: dayName
                )
                
            case "Tue":
                setAvailability(
                    forDay: availabilities.tuesday,
                    isNew: isNew,
                    dayName: dayName
                )
                
            case "Wed":
                setAvailability(
                    forDay: availabilities.wednesday,
                    isNew: isNew,
                    dayName: dayName
                )
                
            case "Thu":
                setAvailability(
                    forDay: availabilities.thursday,
                    isNew: isNew,
                    dayName: dayName
                )
                
            case "Fri":
                setAvailability(
                    forDay: availabilities.friday,
                    isNew: isNew,
                    dayName: dayName
                )
                
            case "Sat":
                setAvailability(
                    forDay: availabilities.saturday,
                    isNew: isNew,
                    dayName: dayName
                )
                
            case "Sun":
                setAvailability(
                    forDay: availabilities.sunday,
                    isNew: isNew,
                    dayName: dayName
                )
                
            default:
                Text("-")
            }
        }
    }
    
    private func setAvailability(
        forDay day: Day?,
        isNew: Bool,
        dayName: String
    ) -> some View {
        VStack {
            if let day = day,
               let isNotAvailable = day.isNotAvailable,
               let isAvailableAllDay = day.isAvailableAllDay,
               let start = day.start,
               let end = day.end {
                
                if isNotAvailable {
                    Text(LocalizedStringKey("Not Available"))
                } else if !isAvailableAllDay {
                    Text(
                        start.stringTime
                        + " - " +
                        end.stringTime
                    )
                } else if isAvailableAllDay {
                    Text(LocalizedStringKey("All Day"))
                }
            }
        }
        .foregroundColor(
            setChangesColor(
                isNew: isNew,
                forDay: dayName
            )
        )
        .font(.subheadline)
    }
    
    private func setChangesColor(isNew: Bool, forDay dayName: String) -> Color {
        isNew && hasChanged(
            oldAvailabilities: availabilityListModel.availabilityChangesResponse!.oldAvailability,
            newAvailabilities: availabilityListModel.availabilityChangesResponse!.newAvailability,
            forDay: dayName
        ) ?
        Color.red :
        Color.primary
    }
    
    private func hasChanged(
        oldAvailabilities: Availabilities,
        newAvailabilities: Availabilities,
        forDay day: String
    ) -> Bool {
        switch day {
        case "Mon":
            return oldAvailabilities.monday != newAvailabilities.monday
            
        case "Tue":
            return oldAvailabilities.tuesday != newAvailabilities.tuesday
            
        case "Wed":
            return oldAvailabilities.wednesday != newAvailabilities.wednesday
            
        case "Thu":
            return oldAvailabilities.thursday != newAvailabilities.thursday
            
        case "Fri":
            return oldAvailabilities.friday != newAvailabilities.friday
            
        case "Sat":
            return oldAvailabilities.saturday != newAvailabilities.saturday
            
        case "Sun":
            return oldAvailabilities.sunday != newAvailabilities.sunday
            
        default:
            return false
        }
    }
}

#Preview {
    AvailabilityChangeDetailsView(
        availabilityListModel: AvailabilityListModel(),
        date: Date(),
        index: 0
    )
}


extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xff0000) >> 16) / 255
        let green = Double((rgbValue & 0x00ff00) >> 8) / 255
        let blue = Double(rgbValue & 0x0000ff) / 255
        let opacity = Double((rgbValue & 0xff000000) >> 24) / 255
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
