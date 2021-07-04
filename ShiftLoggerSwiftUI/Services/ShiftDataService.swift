//
//  ShiftDataService.swift
//  ShiftLoggerSwiftUI
//
//  Created by Peter Lyn on 7/1/21.
//

import Foundation
import Combine


class ShiftDataService {
    
    static let instance = ShiftDataService()
    private var cancellables = Set<AnyCancellable>()
    @Published var shiftData: [ShiftModel] = []

    
    private init() {}
    

    func getShifts(token: String, start: Date, end: Date) {
        guard let url = URL(string: "https://salty-oasis-56584.herokuapp.com/shifts/allshifts") else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fixedStart = dateFormatter.string(from: start)
        let fixedEnd = dateFormatter.string(from: end)
        let body = ["start": fixedStart, "end": fixedEnd]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(body)
        
        NetWorkingManager.download(request: request)
            .decode(type: [ShiftModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetWorkingManager.handleCompletion) { [weak self] shiftResponse in
                self?.shiftData = shiftResponse
            }
            .store(in: &cancellables)
    }
    
    func addShift(token: String, date: String, shift: String, hours: Double) {
        guard let url = URL(string: "https://salty-oasis-56584.herokuapp.com/shifts") else { return }
        let body = ["date": date, "shift": shift, "hours": String(format: "%.1f", hours)]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(body)
        NetWorkingManager.download(request: request)
            .decode(type: ShiftModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetWorkingManager.handleCompletion) { receivedShift in
                print(receivedShift)
            }
            .store(in: &cancellables)
    }
    
    func editShift(token: String, date: String, shiftId: String, shift: String, hours: Double) {
        guard let url = URL(string: "https://salty-oasis-56584.herokuapp.com/shifts/\(shiftId)") else { return }
        let body = ["date": date, "shift": shift, "hours": String(format: "%.1f", hours)]
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(body)
        NetWorkingManager.download(request: request)
            .decode(type: ShiftModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetWorkingManager.handleCompletion) { shift in
                print(shift)
            }
            .store(in: &cancellables)

    }
    
    func deleteShift(token: String, shiftId: String) {
        guard let url = URL(string: "https://salty-oasis-56584.herokuapp.com/shifts/\(shiftId)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        NetWorkingManager.download(request: request)
            .decode(type: [String: String].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetWorkingManager.handleCompletion) { object in
                print(object)
            }
            .store(in: &cancellables)
    }
}
