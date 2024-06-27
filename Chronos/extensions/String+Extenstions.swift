//
//  String+Extenstions.swift
//  Chronos
//
//  Created by Bassam Hillo on 27/06/2024.
//

import Foundation

extension String {
    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: self)
    }

    func timeAndDate() -> String {
        guard let date = date else { return "--" }
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a 'on' MMMM dd"
        return formatter.string(from: date)
    }

    var stringTime: String {
        guard let date = date else { return "--" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date)
    }
}
