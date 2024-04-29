//
//  CoreDataManager.swift
//  Chronos
//
//  Created by Samar Assi on 27/04/2024.
//

import Foundation
import CoreData
import SwiftUI

final class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "AccessTokenContainer")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading core data. \(error)")
            } else {
                print("Successfully loaded core data")
            }
        }
    }

    func fetchAccessToken() -> [AccessTokenEntity]? {
        let request = NSFetchRequest<AccessTokenEntity>(entityName: "AccessTokenEntity")

        do {
            return try container.viewContext.fetch(request)
        } catch let error {
            print("Fetching error. \(error)")
            return nil
        }
    }

    func saveAccessToken() -> [AccessTokenEntity]? {
        do {
            try container.viewContext.save()
            return fetchAccessToken()
        } catch let error {
            print("Error saving. \(error)")
            return nil
        }
    }

    func addAccessToken(accessToken: String) -> [AccessTokenEntity]? {
        let newAccessToken = AccessTokenEntity(context: CoreDataManager.shared.container.viewContext)
        newAccessToken.accessToken = accessToken

        return saveAccessToken()
    }

    func deleteAccessToken(accessTokens: [AccessTokenEntity]) -> [AccessTokenEntity]? {
        var accessTokenArray = accessTokens
        accessTokenArray.removeAll()
        return saveAccessToken()
    }
}
