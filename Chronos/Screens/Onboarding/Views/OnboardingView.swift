//
//  OnboardingView.swift
//  Chronos
//
//  Created by Samar Assi on 05/05/2024.
//

import SwiftUI

struct OnboardingView: View {
    @State private var selectedPosition: Position?
    @State private var isSelected = false
    @State private var radioButtons: [RadioButtonModel] = RadioButtonModel.data

    @Binding var showFullScreen: Bool

    var isNextButtonDisabled: Bool {
        selectedPosition == nil ?
        true :
        false
    }

    var nextButtonBackgroundColor: Color {
        selectedPosition == nil ?
        Color.theme.opacity(0.5) :
        Color.theme
    }

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 15
        ) {
            headerSectionView
            imageView
            positionSelectionView
            Spacer()
            nextButtonView
        }
        .fontDesign(.rounded)
        .padding(.horizontal, 30)
        .padding(.vertical, 20)
    }
}

extension OnboardingView {
    var headerSectionView: some View {
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            Text(LocalizedStringKey("Enroll to Chronos"))
                .font(.title2)
                .fontWeight(.bold)

            Text(LocalizedStringKey("Select your role:"))
                .foregroundStyle(Color.gray)
        }
    }

    var imageView: some View {
        Image(.join)
            .resizable()
            .scaledToFit()
            .frame(height: 280)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical)
    }

    var positionSelectionView: some View {
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            ForEach(radioButtons) { radioButton in
                RadioButtonView(
                    isSelected: radioButton.tag == selectedPosition,
                    label: radioButton.label,
                    details: radioButton.details
                )
                .onTapGesture {
                    selectedPosition = radioButton.tag
                }
            }
        }
    }

    var nextButtonView: some View {
        NavigationLink {
            destinationView
                .navigationBarBackButtonHidden(true)
        } label: {
            Text(LocalizedStringKey("Next"))
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .background(nextButtonBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .disabled(isNextButtonDisabled)
    }

    var destinationView: some View {
        VStack {
            if selectedPosition == .manager {
                ManagerView(showFullScreen: $showFullScreen)
            } else {
                EmployeeView(showFullScreen: $showFullScreen)
            }
        }
    }
}

#Preview {
    OnboardingView(showFullScreen: .constant(false))
}
