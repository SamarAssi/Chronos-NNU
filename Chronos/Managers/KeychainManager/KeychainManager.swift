//
//  KeychainManager.swift
//  Chronos
//
//  Created by Samar Assi on 05/05/2024.
//

import Foundation
import KeychainSwift

final class KeychainManager: ObservableObject {

    static let shared = KeychainManager()
    let keychain: KeychainSwift

    init() {
        keychain = KeychainSwift()
        keychain.synchronizable = true
    }

    func save(_ value: String, key: String) {
        keychain.set(value, forKey: key)
    }

    func fetch(key: String) -> String? {
        keychain.get(key)
    }

    func delete(key: String) -> Bool {
        return keychain.delete(key)
    }
}
