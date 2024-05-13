//
//  OnboardingView.swift
//  Chronos
//
//  Created by Samar Assi on 05/05/2024.
//

import SwiftUI

struct OnboardingView: View {
    @State private var selectedPosition: Position?
    @State private var radioButtons: [RadioButtonModel] = []
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
        NavigationView {
            VStack(alignment: .leading, spacing: 15) {
                headerSectionView

                Image(.join)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 280)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical)

                positionSelectionView

                Spacer()

                NavigationLinkView(
                    buttonText: LocalizedStringKey("Next"),
                    backgroundColor: nextButtonBackgroundColor,
                    destination: destinationView
                )
                .disabled(isNextButtonDisabled)
            }
            .fontDesign(.rounded)
            .padding(.horizontal, 30)
            .padding(.vertical, 20)
            .onAppear {
                setRadioButtons()
            }
        }
    }
}

extension OnboardingView {
    var headerSectionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(LocalizedStringKey("Enroll to Chronos"))
                .font(.title2)
                .fontWeight(.bold)

            Text(LocalizedStringKey("Select your role:"))
                .foregroundStyle(Color.gray)
        }
    }

    var positionSelectionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(radioButtons.indices, id: \.self) { index in
                RadioButtonView(
                    isSelected: Binding(
                        get: {
                            radioButtons[index].tag == selectedPosition
                        },
                        set: { newValue in
                            if newValue {
                                selectedPosition = radioButtons[index].tag
                            }
                        }
                    ),
                    label: radioButtons[index].label,
                    details: radioButtons[index].details
                )
            }
        }
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

    private func setRadioButtons() {
        radioButtons = [
            RadioButtonModel(
                tag: .manager,
                label: LocalizedStringKey("Manager"),
                details: LocalizedStringKey("Manage your team effortlessly")
            ),
            RadioButtonModel(
                tag: .employee,
                label: LocalizedStringKey("Employee"),
                details: LocalizedStringKey("Join your team tody")
            )
        ]
    }
}

#Preview {
    OnboardingView(showFullScreen: .constant(false))
}
