//
//  AvailabilityListView.swift
//  Chronos
//
//  Created by Samar Assi on 24/05/2024.
//

import SwiftUI

struct AvailabilityListView: View {
    @StateObject private var availabilityListModel = AvailabilityListModel()
    
    var body: some View {
        VStack(
            alignment: .leading
        ) {
            if availabilityListModel.isLoading {
                CustomProgressView()
            } else {
                titleView
                if let response = availabilityListModel.response {
                    if response.requests.isEmpty {
                        noRequestView
                    } else {
                        requestsListView(response: response)
                    }
                }
            }
        }
        .onAppear {
            availabilityListModel.handleAvailabilityRequests()
        }
    }
}

extension AvailabilityListView {
    var titleView: some View {
        Text(LocalizedStringKey("Requests List"))
            .font(
                .system(
                    size: 22,
                    weight: .bold,
                    design: .rounded
                )
            )
            .padding(.horizontal, 22)
            .padding(.top)
    }
    
    var imageView: some View {
        Image(.SAMAR_911)
            .resizable()
            .scaledToFit()
            .frame(width: 220, height: 220)
    }
    
    var noRequestsMessageView: some View {
        Text(LocalizedStringKey("No requests to see here"))
            .font(.system(size: 15, weight: .bold, design: .rounded))
    }
    
    var noRequestView: some View {
        VStack(
            spacing: 0
        ) {
            imageView
            noRequestsMessageView
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .center
        )
        .offset(y: -50)
        .shadow(radius: 10, x: 0, y: 5)
    }
    
    private func requestsListView(
        response: AvailabilityRequestsListResponse
    ) -> some View {
        List(
            response.requests,
            id: \.self
        ) { request in
            AvailabilityRowView(
                date: Date(timeIntervalSince1970: request.date),
                name: request.employeeName
            )
            .listRowSeparator(.hidden)
        }
        .listStyle(PlainListStyle())
        .scrollIndicators(.hidden)
    }
}

#Preview {
    AvailabilityListView()
}
