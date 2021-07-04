//
//  MainViewModel.swift
//  ShiftLoggerSwiftUI
//
//  Created by Peter Lyn on 6/17/21.
//

import Foundation
import Combine


enum changeMonthMethod {
    case increase
    case decrease
    case noChange
}

class MainViewModel: ObservableObject {
    
    let dateService = DateService.instance
    let shiftDataService = ShiftDataService.instance
    @Published var shiftData: [ShiftModel] = []
    @Published var clickedDay: Int = 0
    @Published var shiftsForDay: [ShiftModel] = []
    private var cancellables = Set<AnyCancellable>()
    var workingDate: Date {
        guard let returnedDate = dateService.getDateFromNav(nav: monthIndex) else { return Date() }
        return returnedDate
    }
    
    var highlightedDay: Int {
        if clickedDay == 0 {
            return dateService.dayToHighlight(activeDate: workingDate)
        } else {
            return clickedDay
        }
    }
    
    var workingDateString: String {
        return dateService.shortDateStringFromDayAndDate(day: highlightedDay, date: workingDate)
    }
    

    
    private var monthIndex = 0
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        shiftDataService.$shiftData
            .sink { receivedShifts in
                self.shiftData = receivedShifts
                self.calcshiftsForDay()
            }
            .store(in: &cancellables)
    }
    
    func addShift(token: String, shift: String, hours: Double) {
        let dateString = DateFormatter().dateStringForAddEdit(from: workingDateString)
        shiftDataService.addShift(token: token, date: dateString, shift: shift, hours: hours)
        self.updateShifts(token)
    }
    
    func editShift(token: String, shiftId: String, shift: String, hours: Double) {
        let dateString = DateFormatter().dateStringForAddEdit(from: workingDateString)
        shiftDataService.editShift(token: token, date: dateString, shiftId: shiftId, shift: shift, hours: hours)
        self.updateShifts(token)
        
    }

    func deleteShift(token: String, shiftId: String) {
        shiftDataService.deleteShift(token: token, shiftId: shiftId)
        self.updateShifts(token)
    }
    
    func updateShifts(_ token: String){
            let updatedDate = workingDate
            let startOfMonth = updatedDate.startOfMonth
            let endOfMonth = updatedDate.endOfMonth
        shiftDataService.getShifts(token: token, start: startOfMonth, end: endOfMonth)
        self.calcshiftsForDay()
    }
       
    func calcshiftsForDay() {
        shiftsForDay = shiftData.filter { shift in
            shift.formattedDate == workingDateString
        }
    }
    
    
    func changeMonth(_ method: changeMonthMethod, token: String) {
        switch method {
        case .increase:
            monthIndex += 1
            clickedDay = 0
            updateShifts(token)
            
        case .decrease:
            monthIndex -= 1
            clickedDay = 0
            updateShifts(token)
            
        case .noChange:
            updateShifts(token)
           
        }
    }
       
    func getDisplayDate(date: Date) -> String {
        return dateService.getDisplayDate(date: date)
    }
    
    func getRangeLengthForCal(date: Date) -> Int {
        return dateService.getCalArrayLength(for: date) ?? 0
    }
    
    func getPaddingDays(date: Date) -> Int {
        return dateService.getPaddingDayCount(from: date)
    }
    
    func makeDayArray(shifts: [ShiftModel]) -> [Int] {
        shifts.map { shift in
            let shiftSplit = shift.formattedDate.split(separator: " ")
            let shiftDay = shiftSplit[1].split(separator: ",")
            return Int(shiftDay[0]) ?? 0
        }
    }
    
    func isCurrentDay(dayNum: Int) -> Bool {
        let currentMonth = dateService.getMonth(from: Date())
        let currentYear = dateService.getYear(from: Date())
        let activeMonth = dateService.getMonth(from: workingDate)
        let activeYear  = dateService.getYear(from: workingDate)
        let currentDay = dateService.getCurrentDay()
        return currentMonth == activeMonth && currentYear == activeYear && dayNum == currentDay
    }

    
    
}
