//
//  SwipeToUnlockView.swift
//  Chronos
//
//  Created by Samar Assi on 10/04/2024.
//

import SwiftUI

struct SwipeToUnlockView: View {

    @EnvironmentObject var locationManager: LocationManager
    @ObservedObject var homeModel: HomeModel

    @State private var response: CheckInOutResponse?
    @State private var currentDragOffsetX: CGFloat = 0

    @Binding var isCheckedIn: Bool
    @Binding var selectedDate: Date
    @Binding var isInvalidCheckInOut: Bool

    var width: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(swipeButtonColor)
                .frame(maxWidth: width)
                .frame(height: 60)

            Text(getSwipeButtonText())
                .foregroundStyle(Color.white)
        }
        .overlay(overlayContentView, alignment: .leading)
    }
}

extension SwipeToUnlockView {

    var overlayContentView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .frame(width: 50, height: 50)

            Image(systemName: "arrow.right")
                .foregroundStyle(swipeButtonColor)
        }
        .padding(.leading, 5)
        .offset(x: setSwipeButtonLimintation())
        .gesture(
            DragGesture()
                .onChanged(handleDragChanged)
                .onEnded { _ in
                        handleDragEnded()
                }
        )
    }

    var swipeButtonColor: LinearGradient {
        isCheckedIn ?
        LinearGradient(
            colors: [Color.red, Color.red.opacity(0.5)],
            startPoint: .top,
            endPoint: .bottomTrailing
        ) :
        LinearGradient(
            colors: [Color.theme, Color.theme.opacity(0.5)],
            startPoint: .top,
            endPoint: .bottomTrailing
        )
    }
}

extension SwipeToUnlockView {

    private func setSwipeButtonLimintation() -> CGFloat {
        return min(
            max(currentDragOffsetX, 0),
            UIScreen.main.bounds.width - getRemainderOfHalfScreen() - 60
        )
    }

    private func getSwipeButtonText() -> String {
        isCheckedIn ?
        "Swipe to Check Out" :
        "Swipe to Check In"
    }

    private func handleDragChanged(value: DragGesture.Value) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            currentDragOffsetX = value.translation.width
        }
    }

    private func handleDragEnded() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            if currentDragOffsetX >= UIScreen.main.bounds.width - getRemainderOfHalfScreen() - 60 {
                isCheckedIn.toggle()
                if let location = locationManager.location {
                    homeModel.handleCheckInOutResponse(
                        location: location,
                        selectedDate: selectedDate
                    ) { success in
                        isInvalidCheckInOut = success
                    }
                }
                
                if let checkInOutResponse = homeModel.checkInOutResponse {
                    if checkInOutResponse.checkInStatus == 1 {
                        isCheckedIn = true
                    } else {
                        isCheckedIn = false
                    }
                }
            }

            currentDragOffsetX = 0
        }
    }

    private func getRemainderOfHalfScreen() -> CGFloat {
        return UIScreen.main.bounds.size.width - width
    }

//    private func handleCheckInOutResponse() {
//        Task {
//            do {
//                if let location = locationManager.location {
//                    let currentLatitude = location.coordinate.latitude
//                    let currentLongitude = location.coordinate.longitude
//
//                    response = try await performCheckInOutRequest(
//                        currentLatitude: currentLatitude,
//                        currentLongitude: currentLongitude
//                    )
//
//                    homeModel.handleDashboardResponse(
//                        selectedDate: selectedDate,
//                        employeeId: ""
//                    )
//                }
//            } catch let error {
//                print(error)
//            }
//            if let response = response {
//                if response.checkInStatus == 1 {
//                    isCheckedIn = true
//                } else {
//                    isCheckedIn = false
//                }
//            }
//        }
//    }
//    
//    private func performCheckInOutRequest(
//        currentLatitude: Double,
//        currentLongitude: Double
//    ) async throws -> CheckInOutResponse {
//        return try await DashboardClient.updateCheckInOut(
//            currentLatitude: currentLatitude,
//            currentLongitude: currentLongitude
//        )
//    }
}

#Preview {
    SwipeToUnlockView(
        homeModel: HomeModel(),
        isCheckedIn: .constant(false),
        selectedDate: .constant(Date()),
        isInvalidCheckInOut: .constant(false),
        width: UIScreen.main.bounds.width
    )
    .environmentObject(LocationManager())
}
