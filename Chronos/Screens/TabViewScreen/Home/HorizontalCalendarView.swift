//
//  HorizontalCalendarView.swift
//  Chronos
//
//  Created by Samar Assi on 13/04/2024.
//

import SwiftUI

struct HorizontalCalendarView: View {
    @ObservedObject var mainViewModel: MainViewModel
    
    var startDate: Date
    var endDate: Date
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Date.generateDates(from: startDate, to: endDate), id: \.self) { date in
                        CalendarItemView(
                            mainViewModel: mainViewModel,
                            date: date
                        )
                        .onAppear {
                            if Date.isSameDay(date, as: Date()) {
                                withAnimation {
                                    proxy.scrollTo(date, anchor: .center)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HorizontalCalendarView(
        mainViewModel: MainViewModel(),
        startDate: Date(),
        endDate: Date()
    )
}
