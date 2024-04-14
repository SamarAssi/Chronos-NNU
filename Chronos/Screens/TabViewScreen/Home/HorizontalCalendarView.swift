//
//  HorizontalCalendarView.swift
//  Chronos
//
//  Created by Samar Assi on 13/04/2024.
//

import SwiftUI

struct HorizontalCalendarView: View {
    @State private var selectedDate: Date?
    
    var startDate: Date
    var endDate: Date
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Date.generateDates(from: startDate, to: endDate), id: \.self) { date in
                        CalendarItemView(selectedDate: $selectedDate, date: date)
                            .onAppear {
                                if Date.isSameDay(date, as: Date()) {
                                    withAnimation {
                                        proxy.scrollTo(date, anchor: .center)
                                    }
                                }
                            }
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    HorizontalCalendarView(startDate: Date(), endDate: Date())
}
