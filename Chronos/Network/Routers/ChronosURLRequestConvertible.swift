//
//  ChronosURLRequestConvertible.swift
//  Chronos
//
//  Created by Samar Assi on 09/04/2024.
//

import Foundation
import Alamofire

protocol ChronosURLRequestConvertible: URLRequestConvertible {
    var URLString: String  { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
}
