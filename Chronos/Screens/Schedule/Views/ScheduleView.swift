//
//  ScheduleView.swift
//  Chronos
//
//  Created by Samar Assi on 19/06/2024.
//

import SwiftUI

struct ScheduleView: View {
    
    @State var showCreateEventView = false
    @State private var showAIFeature = false
    @State private var buttonAnimation = false
    @State private var addButtonClicked = false

    @ObservedObject var viewModel = ScheduleViewModel()
    
    var body: some View {
        contentView
            .sheet(isPresented: $showCreateEventView) {
                //CreateShiftView(selectedDate: $viewModel.selectedDate)
            }
            .sheet(isPresented: $showAIFeature) {
                ShiftsSuggestionsView()
            }
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
                    if isManager() {
                        HStack {
                            Spacer()
                            FloatingActionButton
                        }
                    }
                }
                .sheet(isPresented: $showCreateEventView) {
                   // CreateShiftView(selectedDate: $viewModel.selectedDate)
                }
        }
        .fontDesign(.rounded)
    }

    private var aiButton: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.5)) {
                withAnimation(.default) {
                    showAIFeature.toggle()
                }
            }
        }) {
            GifImageView("aiButton")
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .shadow(radius: 10)
                .scaleEffect(buttonAnimation ? 1.2 : 1.0)
                .animation(
                    .easeInOut(duration: 0.6)
                    .repeatForever(autoreverses: true)
                    .delay(0.2),
                    value: buttonAnimation
                )
                .onAppear {
                    buttonAnimation = true
                }
                .shadow(radius: 2)
                .padding()
        }
    }


    private var TitleView: some View {
        HStack {
            Text("Schedule")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.theme)
                .padding()
            Spacer()
            if isManager() {
                aiButton
            }
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
                    Text(LocalizedStringKey("Select a date"))
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
                    Text(LocalizedStringKey("No shifts available"))
                        .foregroundColor(.theme)
                        .padding()
                        .frame(maxHeight: .infinity)
                } else {
                    List(viewModel.shifts) { event in
                        ShiftRowView(model: event)
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
            
            VStack(
                alignment: .leading,
                spacing: 5
            ) {
                Text(model.title)
                    .font(.system(size: 15, weight: .semibold))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                HStack(spacing: 2) {
                    Text(LocalizedStringKey("Start: "))
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black)
                    Text("\(model.startTime)")
                        .font(.system(size: 13))
                        .foregroundColor(.black)
                }
                
                HStack(spacing: 2) {
                    Text(LocalizedStringKey("End: "))
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black)
                    Text("\(model.endTime)")
                        .font(.system(size: 13))
                        .foregroundColor(.black)
                }
            }
            .padding(10)
            
            Spacer()

            Image(systemName: "xmark")
                .font(.subheadline)
                .onTapGesture {
                    deleteShift(id: model.id)
                }
                .padding()
                .frame(maxHeight: .infinity, alignment: .top)
        }
        .background(model.backgroundColor.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private func deleteShift(id: String) {
        viewModel.handleShiftDeletion(id: id)
    }
    
    private func isManager() -> Bool {
        let employeeType = UserDefaultManager.employeeType ?? 0
        return employeeType == 1
    }
}

#Preview {
    ScheduleView()
}

extension AnyTransition {
    static var aiViewAnimation: AnyTransition {
        AnyTransition.scale(scale: 0.1, anchor: .bottomLeading)
            .combined(with: .asymmetric(insertion: .opacity, removal: .opacity))
    }
}
