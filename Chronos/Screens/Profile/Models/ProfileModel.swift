//
//  ProfileModel.swift
//  Chronos
//
//  Created by Samar Assi on 22/06/2024.
//

import Foundation

class ProfileModel: ObservableObject {
    
    @Published var onboardingCompanyResponse: OnboardingCompanyResponse?
    @Published var updateCompanyRulesResponse: UpdateCompanyRulesResponse?
    
    @Published var isOn: Bool = true
    @Published var isLoading = false
    @Published var isLoadingView = false
    
    @MainActor
    func getCompanyLocation() {
        showLoadingView()
        
        Task {
            do {
                onboardingCompanyResponse = try await OnboardingClient.getCompanyLocation()
                if let onbaordingCompanyResponse = onboardingCompanyResponse {
                    isOn = onbaordingCompanyResponse.ignoreCheckInLocation
                }
                hideLoadingView()
            } catch let error {
                print(error)
                hideLoadingView()
            }
        }
    }
    
    @MainActor
    func updateCompanyRules(
        companyName: String,
        about: String,
        latitude: Double,
        longitude: Double,
        allowedRadius: Double,
        ignoreCheckInLocation: Bool
    ) {
        showLoading()
        
        Task {
            do {
                updateCompanyRulesResponse = try await OnboardingClient.updateCompanyRules(
                    companyName: companyName,
                    about: about,
                    latitude: latitude,
                    longitude: longitude,
                    allowedRadius: allowedRadius,
                    ignoreCheckInLocation: ignoreCheckInLocation
                )
                hideLoading()
            } catch let error {
                print(error)
                hideLoading()
            }
        }
    }
    
    private func showLoading() {
        isLoading = true
    }
    
    private func hideLoading() {
        isLoading = false
    }
    
    private func showLoadingView() {
        isLoadingView = true
    }
    
    private func hideLoadingView() {
        isLoadingView = false
    }
}
