import SwiftUI

struct SuggestedShiftsView: View {
    @Environment(\.dismiss) var dismiss
    @State var uiModels: [ShiftRowUI] = []
    @State var isSubmitting = false
    let hourWidth = 100.0
   private let shifts: [Shift]
    @State private var selectedShift: ShiftRowUI?
    
    init(shifts: [Shift]) {
        self.shifts = shifts
        
        let acronymManager = AcronymManager()
        self.uiModels = shifts.compactMap { shift in
            
            let name = shift.employeeName
            let id = shift.employeeID
            let (initials, backgroundColor) = acronymManager.getAcronymAndColor(name: name, id: id ?? "")
            
            let startTime = shift.startTime?.stringTime ?? "--"
            let endTime = shift.endTime?.stringTime ?? "--"
            
            let jobDescription = shift.jobDescription?.trimmingCharacters(in: .whitespacesAndNewlines)
            let titleString: String = (jobDescription?.isEmpty == false ? jobDescription : name) ?? "--"
            
            return ShiftRowUI(
                id: shift.id ?? "",
                employeeID: shift.employeeID ?? "",
                initials: initials,
                employeeName: shift.employeeName ?? "",
                role: shift.role ?? "Developer",
                title: titleString,
                startTime: shift.startTime?.date ?? Date(),
                endTime: shift.endTime?.date ?? Date(),
                backgroundColor: backgroundColor,
                isNew: shift.isNew ?? false
            )
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                scrollableCalendarView
                    .padding(.top)
                Divider()
                    .padding(.bottom)
                buttonsView
            }
            
            if isSubmitting {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .theme))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.2))
                    .ignoresSafeArea()
                    .animation(.easeInOut, value: isSubmitting)
            }
        }
        .navigationTitle("Suggested Shifts")
    }
    
    var scrollableCalendarView: some View {
        ScrollView(.vertical) {
            ScrollView(.horizontal) {
                ZStack(alignment: .topLeading) {
                    VStack {
                        hoursView
                        
                    }
                    shiftsListView
                }
            }
        }
    }
    
    var hoursView: some View {
        HStack(spacing: 0) {
            ForEach(0..<25) { hour in
                VStack {
                    Text(hour < 12 ? "AM" : "PM")
                        .font(.caption2)
                    Text("\(hour % 12 == 0 ? 12 : hour % 12)")
                        .font(.caption)
                        .padding(.vertical, 10)
                    
                    
                    Color.gray.opacity(0.5)
                        .frame(width: 1)
                        .frame(height: UIScreen.main.bounds.height)
                    
                }
                .frame(width: hourWidth)
            }
        }
    }
    
    var shiftsListView: some View {
        VStack(
            alignment: .leading,
            spacing: 0
        ) {
            ForEach(uiModels) { shift in
                shiftCell(shift: shift)
            }
            .padding(.leading, hourWidth / 2)
        }
    }
    
    private var buttonsView: some View {
        HStack {
            buttonView(
                title: "REJECT",
                backgroundColor: .red,
                action: {
                    dismiss.callAsFunction()
                }
            )
            
            buttonView(
                title: "APPROVE",
                backgroundColor: .theme,
                action: {
                    acceptShifts()
                }
            )
        }
        .padding(.horizontal)
    }
    
    private func buttonView(
        title: String,
        backgroundColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
        } label: {
            Text(title)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .bold))
                .padding(.vertical, 15)
                .background(backgroundColor.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    func acceptShifts() {
        isSubmitting = true
        Task {
            do {
                let shifts = try await ScheduleClient.createShifts(shifts: Shifts(shifts: shifts))
                print(shifts)
            } catch {
                print(error)
            }
            
            await MainActor.run {
                isSubmitting = false
                dismiss.callAsFunction()
            }
        }
    }
    
    private func shiftCell(shift: ShiftRowUI) -> some View {
        VStack(alignment: .leading) {
            Text(shift.employeeName)
            Text(shift.role)
            Text(formattedDate(shift.startTime))
            Text(formattedDate(shift.endTime))
        }
        .font(.caption)
        .frame(maxHeight: 80, alignment: .leading)
        .frame(
            width: max(
                0,
                calculateShiftWidth(
                    startTime: shift.startTime,
                    endTime: shift.endTime
                ) - 19
            ),
            alignment: .leading
        )
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(shift.backgroundColor.opacity(0.5))
        )
        .padding(.top, 66)
        .offset(x: calculateOffsetX(startTime: shift.startTime))
        .onTapGesture {
            selectedShift = shift
        }
    }
    
    private func calculateShiftWidth(startTime: Date, endTime: Date) -> CGFloat {
        let duration = endTime.timeIntervalSince(startTime)
        let width = CGFloat(duration / 3600) * hourWidth
        return width
    }
    
    private func calculateOffsetX(startTime: Date) -> Double {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: startTime)
        let minute = calendar.component(.minute, from: startTime)
        let offset = (Double(hour) + Double(minute) / 60) * hourWidth
        return offset
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    let shifts: [Shift] = []
     return NavigationStack {
         SuggestedShiftsView(shifts: shifts)
     }
}


extension Int {
    func timeAndDate(in timeZone: TimeZone? = nil) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a 'on' MMMM dd"
        
        // Set the timezone if provided, otherwise use the date's original timezone
        formatter.timeZone = timeZone ?? TimeZone(secondsFromGMT: 0)
        
        return formatter.string(from: date)
    }
}
