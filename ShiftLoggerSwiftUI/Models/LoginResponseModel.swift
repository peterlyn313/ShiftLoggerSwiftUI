//
//  LoginResponseModel.swift
//  ShiftLoggerSwiftUI
//
//  Created by Peter Lyn on 6/13/21.
//

import Foundation

struct User: Codable, Identifiable, Hashable {
    var email: String
    var firstName: String
    var lastName: String
    var isActive: Bool
    var isAdmin: Bool
    var _id: String
    var id: String { return _id }
}

struct LoginResponse: Codable {
    var result: User
    var token: String
   
    
}
