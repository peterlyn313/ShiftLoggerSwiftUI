//
//  DateFormatter.swift
//  SwiftUIShiftLog
//
//  Created by Peter Lyn on 5/2/20.
//  Copyright © 2020 Peter Lyn. All rights reserved.
//

import Foundation

extension DateFormatter {
    func shortDateFromText(text: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let dateFromString = formatter.date(from: text) {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateStyle = .medium
            return dateFormatter1.string(from: dateFromString)
        }
        return ""
    }
    
    func dateFromString(_ text: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter.date(from: text)
    }
    
    func dateStringForAddEdit(from startingString: String) -> String {
        let formatter = DateFormatter()
         formatter.dateFormat = "MMM dd, yyyy"
         guard let dateForShift =  formatter.date(from: startingString) else { return "Error making date String" }
         formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: dateForShift)
    }
}

