//
//  ExtenstionForEncodable.swift
//  Chronos
//
//  Created by Samar Assi on 24/06/2024.
//

import Foundation

extension Encodable {
    func encodeToDictionary() -> [String: Any] {
        let encoder = JSONEncoder()
        guard let json = try? encoder.encode(self),
              let dict = try? JSONSerialization.jsonObject(
                with: json,
                options: []) as? [String: Any]
        else {
            return [:]
        }
        return dict
    }
}
