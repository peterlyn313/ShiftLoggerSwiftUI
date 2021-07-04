//
//  ShiftModel.swift
//  ShiftLoggerSwiftUI
//
//  Created by Peter Lyn on 6/15/21.
//

import Foundation

struct ShiftModel: Codable, Identifiable {
    var _id: String
    var date: String
    var shift: String
    var hours: Double
    var provider: String
    var id: String { return _id }
    
    var formattedDate: String {
        DateFormatter().shortDateFromText(text: date)
    }
    
    var formattedHours: String {
        String(format: "%.1f", hours)
    }
}

struct ReportModel: Codable, Identifiable {
    var _id: String
    var date: String
    var shift: String
    var hours: Double
    var provider: User
    var id: String { return _id }
    var formattedDate: String {
        DateFormatter().shortDateFromText(text: date)
    }
    
    var formattedHours: String {
        String(format: "%.1f", hours)
    }
  
}


