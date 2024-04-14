//
//  ActivityCardView.swift
//  Chronos
//
//  Created by Samar Assi on 13/04/2024.
//

import SwiftUI

struct ActivityCardView: View {
    var icon: String
    var title: String
    var time: String
    var date: Date
    
    var body: some View {
        HStack {
            
        }
    }
}

#Preview {
    ActivityCardView(
        icon: "tray.and.arrow.down",
        title: "Check In",
        time: "10:00 am",
        date: Date()
    )
}
