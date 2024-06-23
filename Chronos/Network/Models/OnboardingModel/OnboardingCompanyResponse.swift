//
//  OnboardingCompanyResponse.swift
//  Chronos
//
//  Created by Samar Assi on 22/06/2024.
//

import Foundation

struct OnboardingCompanyResponse: Codable, Hashable {
    let companyName: String
    let about: String
    let latitude: Double
    let longitude: Double
    let allowedRadius: Double
    let ignoreCheckInLocation: Bool
}
