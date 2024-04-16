//
//  CalendarItemView.swift
//  Chronos
//
//  Created by Samar Assi on 13/04/2024.
//

import SwiftUI

struct CalendarItemView: View {
    @ObservedObject var mainViewModel: MainViewModel
    var date: Date
    
    var itemColor: Color {
        mainViewModel.selectedDate == date ?
        Color.white :
        Color.black
    }
    
    var body: some View {
        VStack(spacing: 5) {
            Text("\(date.day)")
                .font(.title3)
                .fontWeight(.bold)
            
            Text(mainViewModel.getDay(date.weekday))
                .font(.system(size: 14))
        }
        .foregroundStyle(itemColor)
        .frame(width: 80, height: 80)
        .background(mainViewModel.cardBackground(date: date))
        .onTapGesture {
            mainViewModel.selectedDate = date
        }
        .onAppear {
            mainViewModel.setSelectedDate(date: date)
        }
    }
}

#Preview {
    CalendarItemView(
        mainViewModel: MainViewModel(),
        date: Date()
    )
}
