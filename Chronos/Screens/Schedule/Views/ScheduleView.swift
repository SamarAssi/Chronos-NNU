//
//  ScheduleView.swift
//  Chronos
//
//  Created by Bassam Hillo on 19/06/2024.
//

import SwiftUI

struct ScheduleView: View {

    @State var showCreateEventView = false
    @ObservedObject var viewModel = ScheduleViewModel()

    var body: some View {
        contentView
            .onAppear {
                Task {
                    await viewModel.getData()
                }
            }
    }

    private var contentView: some View {
        VStack(alignment: .leading) {
            TitleView
                CalendarDateView
                .safeAreaInset(edge: .bottom) {
                    if fetchEmployeeType() == 1 {
                        FloatingButton
                    }
                }
        }
        .sheet(isPresented: $showCreateEventView) {
            CreateShiftView(selectedDate: $viewModel.selectedDate)
        }
    }

    private var TitleView: some View {
        Text("Schedule")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.theme)
            .padding()
    }

    private var FloatingButton: some View {
        HStack {
            Spacer()
            FloatingActionButton
        }
    }

    private var FloatingActionButton: some View {
        Button(action: {
            showCreateEventView.toggle()
        }) {
            Circle()
                .foregroundColor(.theme)
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "plus")
                        .resizable()
                        .foregroundColor(.white)
                        .padding(14)
                )
                .padding()
        }
    }

    private var CalendarDateView: some View {
        VStack(spacing: 0) {
            DatePicker(
                selection: $viewModel.selectedDate,
                displayedComponents: [.date],
                label: {
                    Text("Select a date")
                        .foregroundColor(.theme)
                }
            )
            .datePickerStyle(.compact)
            .padding(.horizontal)
            .tint(Color.theme)

            Divider()
                .padding(.top)

            if viewModel.isLoading {
                ProgressView("Loading...")
                    .frame(maxHeight: .infinity)
            } else {
                if viewModel.shifts.isEmpty {
                    Text("No shifts available")
                        .foregroundColor(.theme)
                        .padding()
                        .frame(maxHeight: .infinity)
                } else {
                    List(viewModel.shifts) { event in
                        eventRow(model: event)
                            .listRowSeparator(.hidden)
                            .listRowInsets(
                                EdgeInsets(
                                    top: 16,
                                    leading: 18,
                                    bottom: 0,
                                    trailing: 18
                                )
                            )
                    }
                    .listStyle(.plain)
                }
            }
        }
    }

    private func eventRow(model: ShiftRowUIModel) -> some View {
        HStack(spacing: 5) {
            Circle()
                .foregroundColor(model.backgroundColor)
                .frame(width: 40, height: 40)
                .overlay(
                    Text(model.initials)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                )
                .padding(.leading, 15)

            VStack(alignment: .leading, spacing: 5) {
                Text(model.title)
                    .font(.system(size: 15, weight: .semibold))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .lineLimit(1)

                HStack(spacing: 2) {
                    Text("Start:")
                        .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.black)
                    Text("\(model.startTime)")
                        .font(.system(size: 13))
                        .foregroundColor(.black)
                }

                HStack(spacing: 2) {
                    Text("End: ")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black)
                    Text("\(model.endTime)")
                        .font(.system(size: 13))
                        .foregroundColor(.black)
                }
            }
            .padding(10)

            Spacer()
        }
        .background(model.backgroundColor.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private func fetchEmployeeType() -> Int {
        if let employeeType = KeychainManager.shared.fetch(
            key: KeychainKeys.employeeType.rawValue
        ) {
            return Int(employeeType) ?? -1
        }

        return -1
    }
}

#Preview {
    ScheduleView()
}
