//
//  AcronymManager.swift
//  Chronos
//
//  Created by Samar Assi on 23/06/2024.
//

import SwiftUI

class AcronymManager {
    
    private var employeeColor: [String: Color] = [:]
    
    func getAcronymAndColor(name: String?, id: String) -> (String, Color) {
        let backgroundColor: Color
        if let color = employeeColor[id] {
            backgroundColor = color
        } else {
            let color = getRandomColor()
            employeeColor[id] = color
            backgroundColor = color
        }
        
        let initials = getInitials(from: name)
        
        return (initials, backgroundColor)
    }
    
    func resetColors() {
        employeeColor = [:]
    }
    
    func getInitials(from name: String?) -> String {
        let formatter = PersonNameComponentsFormatter()
        guard let name = name,
              let components = formatter.personNameComponents(from: name) else {
            return "--"
        }
        
        formatter.style = .abbreviated
        return formatter.string(from: components)
    }
    
    func getRandomColor() -> Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)

        return Color(red: red, green: green, blue: blue)
    }
}
