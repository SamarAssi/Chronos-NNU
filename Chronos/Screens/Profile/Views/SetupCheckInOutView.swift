//
//  SetupCheckInOutView.swift
//  Chronos
//
//  Created by Samar Assi on 22/06/2024.
//

import SwiftUI
import MapKit
import SimpleToast

struct SetupCheckInOutView: View {
    
    @StateObject private var profileModel = ProfileModel()
    @Environment(\.dismiss) var dismiss
    
    @State private var showLocationSelectionOptionsView = false
    @State private var textFieldModels = TextFieldModel.coordinateData
    @State private var radiusTextField = TextFieldModel.radiusData
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.33233141, longitude: -122.03121860),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    private let toastOptions = SimpleToastOptions(
        alignment: .top,
        hideAfter: 5,
        animation: .linear(duration: 0.3),
        modifierType: .slide,
        dismissOnTap: true
    )
    
    var isSaveButtonDisabled: Bool {
        return areEmptyFields()
    }
    
    var saveButtonBackgroundColor: Color {
        isSaveButtonDisabled ?
        Color.theme.opacity(0.5) :
        Color.theme
    }
    
    var body: some View {
        VStack {
            if profileModel.isLoadingView {
                CustomProgressView()
            } else {
                toggleView
                companyLocationInputsView
                saveButtonView
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButtonView
            }
            
            ToolbarItem(placement: .topBarLeading) {
                titleView
            }
        }
        .fontDesign(.rounded)
        .sheet(isPresented: $showLocationSelectionOptionsView) {
            LocationSelectionOptionsView(
                textFieldModels: $textFieldModels,
                region: $region,
                showLocationSelectionOptionsView: $showLocationSelectionOptionsView
            )
            .presentationDetents([.height(UIScreen.main.bounds.height / 3)])
        }
        .onAppear {
            profileModel.getCompanyLocation()
        }
        .simpleToast(isPresented: $profileModel.showToast, options: toastOptions) {
            ToastView(type: .success, message: "The saving process was completed successfully")
                .padding(.horizontal)
        }
    }
}

extension SetupCheckInOutView {
    
    var toggleView: some View {
        Toggle("Allow check in/out frome anywhere", isOn: $profileModel.isOn)
            .padding(.vertical)
    }
    
    var companyLocationInputsView: some View {
        VStack {
            if !profileModel.isOn {
                companyLocationView
                allowedRadiusView
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
    }
    
    var companyLocationView: some View {
        HStack {
            Text(LocalizedStringKey("Company Location"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .offset(y: 8)
            
            ForEach(textFieldModels) { textFieldModel in
                TextFieldView(textFieldModel: textFieldModel)
                    .frame(width: 80)
            }
            
            editButtonView
                .onAppear {
                    if let onboardingCompanyResponse = profileModel.onboardingCompanyResponse {
                        region.center.latitude = onboardingCompanyResponse.latitude
                        region.center.longitude = onboardingCompanyResponse.longitude
                    }
                }
        }
        .onAppear {
            if let onboardingCompanyResponse = profileModel.onboardingCompanyResponse {
                textFieldModels[0].text = String(onboardingCompanyResponse.latitude)
                textFieldModels[1].text = String(onboardingCompanyResponse.longitude)
            }
        }
    }
    
    var editButtonView: some View {
        Button {
            showLocationSelectionOptionsView.toggle()
        } label: {
            Image(systemName: "square.and.pencil")
                .foregroundStyle(Color.black)
        }
        .offset(y: 8)
    }
    
    var allowedRadiusView: some View {
        HStack {
            Text(LocalizedStringKey("Allowed radius in meters"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .offset(y: 8)
            
            TextFieldView(textFieldModel: radiusTextField)
                .frame(width: 80)
                .padding(.trailing, 28)
                .onAppear {
                    if let onboardingCompanyResponse = profileModel.onboardingCompanyResponse {
                        radiusTextField.text = String(onboardingCompanyResponse.allowedRadius)
                    }
                }
        }
    }
    
    var backButtonView: some View {
        Image(systemName: "chevron.left")
            .scaleEffect(0.9)
            .onTapGesture {
                dismiss.callAsFunction()
            }
    }
    
    var titleView: some View {
        Text(LocalizedStringKey("Setup check in/out"))
            .font(.title2)
            .fontWeight(.bold)
    }
    
    var saveButtonView: some View {
        MainButton(
            isLoading: $profileModel.isLoading, 
            isEnable: .constant(true),
            buttonText: "Save",
            backgroundColor: saveButtonBackgroundColor,
            action: {
                if let onboardingCompanyResponse = profileModel.onboardingCompanyResponse {
                    profileModel.updateCompanyRules(
                        companyName: onboardingCompanyResponse.companyName,
                        about: onboardingCompanyResponse.about,
                        latitude: Double(textFieldModels[0].text) ?? 0,
                        longitude: Double(textFieldModels[1].text) ?? 0,
                        allowedRadius: Double(radiusTextField.text) ?? 0,
                        ignoreCheckInLocation: profileModel.isOn
                    )
                }
            }
        )
        .disabled(isSaveButtonDisabled)
    }
    
    private func areEmptyFields() -> Bool {
        for textField in textFieldModels {
            if textField.text.isEmpty {
                return true
            }
        }
        
        if radiusTextField.text.isEmpty {
            return true
        }
        
        return false
    }
}

#Preview {
    SetupCheckInOutView()
}
