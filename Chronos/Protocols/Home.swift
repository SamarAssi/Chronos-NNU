//
//  Home.swift
//  Chronos
//
//  Created by Samar Assi on 20/04/2024.
//

import Foundation
import SwiftUI

protocol Home: ObservableObject {
    var activities: [String] { get set }
    var isShowProfileHeader: Bool { get set }

    func calculateVerticalContentOffset(_ proxy: GeometryProxy) -> CGFloat
    func adjustShowCalendarState<T: Comparable & Equatable>(from oldVal: T, to newVal: T)
}
