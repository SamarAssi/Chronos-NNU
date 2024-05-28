//
//  AvailabilityListView.swift
//  Chronos
//
//  Created by Samar Assi on 26/05/2024.
//

import SwiftUI
import SimpleToast

struct AvailabilityListView: View {

    @StateObject private var availabilityListModel = AvailabilityListModel()

    @State private var selectedRequest: AvailabilityRequestsListResponse.AvailabilityRequestsListDetails?
    @State private var index: Int?

    private let toastOptions = SimpleToastOptions(
        alignment: .top,
        hideAfter: 5,
        animation: .linear(duration: 0.3),
        modifierType: .slide,
        dismissOnTap: true
    )

    var body: some View {
        VStack(
            alignment: .leading
        ) {
            if availabilityListModel.isLoading {
                CustomProgressView()
            } else {
                titleView

                if let response = availabilityListModel.availabilityResponse {
                    if response.requests.isEmpty {
                        noRequestView
                    } else {
                        requestsListView(response: response)
                    }
                }
            }
        }
        .fullScreenCover(item: $selectedRequest) { request in
            AvailabilityChangeDetailsView(
                availabilityListModel: availabilityListModel,
                date: Date(timeIntervalSince1970: request.date / 1000),
                index: index ?? 0
            )
        }
        .onAppear {
            availabilityListModel.handleAvailabilityRequests()
        }
        .simpleToast(
            isPresented: $availabilityListModel.isApproved,
            options: toastOptions
        ) {
            ToastView(
                type: .success,
                message: LocalizedStringKey("The request is approved")
            )
            .padding(.horizontal, 18)
        }
        .simpleToast(
            isPresented: $availabilityListModel.isRejected,
            options: toastOptions
        ) {
            ToastView(
                type: .warning,
                message: LocalizedStringKey("The request is rejected")
            )
            .padding(.horizontal, 18)
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
            .font(
                .system(
                    size: 15,
                    weight: .bold,
                    design: .rounded
                )
            )
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
            response.requests.indices.reversed(),
            id: \.self
        ) { index in

            AvailabilityRowView(
                date: Date(timeIntervalSince1970: response.requests[index].date / 1000),
                name: response.requests[index].employeeName
            )
            .listRowSeparator(.hidden)
            .onTapGesture {
                self.index = index
                selectedRequest = response.requests[index]
            }

        }
        .listStyle(PlainListStyle())
        .scrollIndicators(.hidden)
    }
}

#Preview {
    AvailabilityListView()
}
