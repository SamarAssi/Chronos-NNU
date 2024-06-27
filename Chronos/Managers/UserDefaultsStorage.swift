//
//  UserDefaultsStorage.swift
//  Chronos
//
//  Created by Bassam Hillo on 27/06/2024.
//

import Foundation

struct UserDefaultManager {
    @UserDefaultsStorage(key: .accessToken)
    static var accessToken: String?

    @UserDefaultsStorage(key: .companyInvitationId)
    static var companyInvitationId: String?

    @UserDefaultsStorage(key: .employeeType)
    static var employeeType: Int?

    @UserDefaultsStorage(key: .fullName)
    static var fullName: String?

    @UserDefaultsStorage(key: .firstName)
    static var firstName: String?

    @UserDefaultsStorage(key: .lastName)
    static var lastName: String?

    @UserDefaultsStorage(key: .phoneNumber)
    static var phoneNumber: String?

    static func clear() {
        accessToken = nil
        companyInvitationId = nil
        employeeType = nil
        fullName = nil
        firstName = nil
        lastName = nil
        phoneNumber = nil
    }
}


/// Enumeration defining keys used to store items in UserDefaults.
enum UserDefaultsKeys: String {
    case accessToken
    case companyInvitationId
    case employeeType
    case fullName
    case firstName
    case lastName
    case phoneNumber
}

/// A property wrapper for storing and retrieving values from UserDefaults.
@propertyWrapper
class UserDefaultsStorage<T: Codable> {

    // MARK: - Properties

    /// The key used to store and retrieve the value in UserDefaults.
    private let key: String

    /// user defaults storage instance
    private let storage: UserDefaults

    // MARK: - Initializer

    /// Initializes a new instance of `UserDefaultsStorage`.
    /// - Parameters:
    ///   - key: The key used to store and retrieve the value in UserDefaults.
    ///   - storage: The referance for user defaults storage to read and write at..
    init(key: UserDefaultsKeys,
         storage: UserDefaults = .standard) {
        self.key = key.rawValue
        self.storage = storage
    }

    // MARK: - Wrapped Value

    /// The property's value, retrieved from or stored to UserDefaults.
    var wrappedValue: T? {
        get {
            // Read value from UserDefaults
            if let data = UserDefaults.standard.data(forKey: key),
               let value = try? JSONDecoder().decode(T.self, from: data) {
                return value
            }

            return nil
        }
        set {
            // Set value to UserDefaults
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: key)
            }
        }
    }
}
