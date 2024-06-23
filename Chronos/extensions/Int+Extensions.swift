//
//  Int+Extensions.swift
//  Chronos
//
//  Created by Bassam Hillo on 23/06/2024.
//

import Foundation

extension Double {
    
    var date: Date {
        Date(timeIntervalSince1970: TimeInterval(self))
    }

    var stringTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date)
    }
}
