//
//  TimeOffRequestsList.swift
//  Chronos
//
//  Created by Bassam Hillo on 27/06/2024.
//

import SwiftUI

struct TimeOffRequestsList: View {

    @State var isLoading = false
    @State private var selectedCategory: TimeOffStatus = .Pending

    @State var timeOffRequests: [TimeOffRequest] = []

    var filteredRequests: [TimeOffRequest] {
        return timeOffRequests.filter { $0.status == selectedCategory.rawValue }
    }

    enum TimeOffStatus: Int, CaseIterable {
        case Pending = 0
        case Approved = 1
        case Rejected = 2

        var title: String {
            switch self {
            case .Pending:
                return "Pending"
            case .Approved:
                return "Approved"
            case .Rejected:
                return "Rejected"
            }
        }
    }

    var body: some View {
        contentView
            .navigationTitle("Time Off Requests")
            .onAppear {
                isLoading = true
                Task {
                    do {
                        let response = try await RTOClient.getTimeOffRequests()
                        self.timeOffRequests = response.timeOffRequests ?? []
                    } catch {
                        print(error)
                    }
                    isLoading = false
                }
            }
    }

    @ViewBuilder
    private var contentView: some View {
        if isLoading {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .theme))
        } else {
            listView
        }
    }

    @ViewBuilder
    private var listView: some View {
        VStack {
            Picker("Category", selection: $selectedCategory) {
                ForEach(TimeOffStatus.allCases, id: \.self) {
                    Text($0.title)
                }
            }
            .pickerStyle(.palette)

            if filteredRequests.isEmpty {
                Text("No requests found")
                    .font(.system(size: 16))
                    .foregroundColor(.theme)
                    .frame(maxHeight: .infinity)
            } else {
                List(filteredRequests, id: \.id) { item in
                    requestRow(request: item)
                }
                .listStyle(.plain)
            }
        }
        .padding()
    }

    @ViewBuilder
    func requestRow(request: TimeOffRequest) -> some View {
        VStack(spacing: 0) {
            HStack {
                Circle()
                    .foregroundColor(
                        AcronymManager().getAcronymAndColor(
                            name: request.username,
                            id: request.id ?? ""
                        ).1
                    )
                    .frame(
                        width: 40,
                        height: 40
                    )
                    .overlay(
                        Text(
                            AcronymManager().getAcronymAndColor(
                                name: request.username,
                                id: request.id ?? ""
                            ).0
                        )
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    )

                VStack(alignment: .leading, spacing: 8) {
                    Text(request.username ?? "--")
                        .font(.system(size: 16, weight: .semibold))
                    HStack {
                        Text(request.startDate?.dateString() ?? "--")
                            .font(.system(size: 14))

                        Text(" - ")
                            .font(.system(size: 14))

                        Text(request.endDate?.dateString() ?? "--")
                            .font(.system(size: 14))
                    }
                }
                .padding(.trailing, 22)
            }
        }
        .fontDesign(.rounded)
    }
}

#Preview {
    NavigationStack {
        TimeOffRequestsList()
    }
}
