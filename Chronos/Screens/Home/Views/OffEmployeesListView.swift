//
//  OffEmployeesListView.swift
//  Chronos
//
//  Created by Samar Assi on 30/06/2024.
//

import SwiftUI

struct OffEmployeesListView: View {
    
    var offEmployees: [TimeOffRequestRowUIModel]
    
    var body: some View {
        VStack(
            alignment: .leading
        ) {
            titleView
            Divider()
            offEmployeeListView
        }
        .fontDesign(.rounded)
    }
}

extension OffEmployeesListView {
    
    var titleView: some View {
        Text(LocalizedStringKey("Who's Out"))
            .font(.title2)
            .fontWeight(.bold)
            .padding(.horizontal, 22)
            .padding(.top)
    }
    
    var offEmployeeListView: some View {
        List(offEmployees) { offEmployee in
            OffEmployeeRowView(rowModel: offEmployee)
                .shadow(color: Color.blackAndWhite.opacity(0.3), radius: 1)
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
        }
        .listStyle(PlainListStyle())
        .scrollIndicators(.hidden)
    }
}

#Preview {
    OffEmployeesListView(
        offEmployees: [
            TimeOffRequestRowUIModel(
                id: "",
                initials: "SA",
                username: "SamarAssi",
                startDate: Date(),
                endDate: Date(),
                backgroundColor: Color.green
            )
        ]
    )
}
