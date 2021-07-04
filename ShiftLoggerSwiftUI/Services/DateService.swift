//
//  DateService.swift
//  ShiftLoggerSwiftUI
//
//  Created by Peter Lyn on 6/17/21.
//

import Foundation

class DateService {
    
    static let instance = DateService()
    
    private init() {}
    
    let calendar = Calendar.current
    
    func getDateFromNav(nav: Int) -> Date? {
        let components = calendar.dateComponents([.year, .month], from: Date())
        guard let startOfMonth = calendar.date(from: components) else { return nil }
      var comps = DateComponents()
        comps.month = nav
        return calendar.date(byAdding: comps, to: startOfMonth)
    }
    
    func getPaddingDayCount(from dateForCal: Date) -> Int {
        let monthForCal = calendar.component(.month, from: dateForCal)
        let yearForCal = calendar.component(.year, from: dateForCal)
        
        return startDayIndex(month: monthForCal, year: yearForCal) - 1
    }
    
    func getCalArrayLength(for dateForCal: Date) -> Int? {        
        let monthForCal = calendar.component(.month, from: dateForCal)
        let yearForCal = calendar.component(.year, from: dateForCal)
        
        let startDayCount = getPaddingDayCount(from: dateForCal)
        guard let daysInMonth = getDaysInMonth(month: monthForCal, year: yearForCal) else { return nil }
        
        return startDayCount + daysInMonth
            
    }
    
    func getDisplayDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    func getMonth(from date: Date) -> Int {
        return calendar.component(.month, from: date)
    }
    
    func getYear(from date: Date) -> Int {
        return calendar.component(.year, from: date)
    }
    
    func getCurrentDay() -> Int {
        return calendar.component(.day, from: Date())
    }
 
    func startDayIndex(month: Int, year: Int) -> Int {
        var startComps = DateComponents()
        startComps.day = 1
        startComps.month = month
        startComps.year = year
        let startDate = calendar.date(from: startComps)!
        return calendar.component(.weekday, from: startDate)
    }
    
    
    func getDaysInMonth(month: Int, year: Int) -> Int? {
            var startComps = DateComponents()
            startComps.day = 1
            startComps.month = month
            startComps.year = year

            var endComps = DateComponents()
            endComps.day = 1
            endComps.month = month == 12 ? 1 : month + 1
            endComps.year = month == 12 ? year + 1 : year

            
            let startDate = calendar.date(from: startComps)!
            let endDate = calendar.date(from:endComps)!

            
            let diff = calendar.dateComponents([Calendar.Component.day], from: startDate, to: endDate)

            return diff.day
        }
    
    func getDateForApi(date: Date) -> String {
        let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func dayToHighlight(activeDate: Date) -> Int {
         let currentMonth = getMonth(from: Date())
         let currentYear = getYear(from: Date())
         let activeMonth = getMonth(from: activeDate)
         let activeYear  = getYear(from: activeDate)
         return currentMonth == activeMonth && currentYear == activeYear ? getCurrentDay() : 1
        
     }
    
    func shortDateStringFromDayAndDate(day: Int, date: Date) -> String {
        let calendar = Calendar.current
        var comps = DateComponents()
        comps.day = day
        comps.month = calendar.component(.month, from: date)
        comps.year = calendar.component(.year, from: date)
        guard let dateClicked = calendar.date(from: comps) else { return "Error getting date."}
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let dateClickedString = formatter.string(from: dateClicked)
        return formatter.shortDateFromText(text: dateClickedString)
    }
    
    
}
