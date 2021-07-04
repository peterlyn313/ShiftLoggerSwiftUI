//
//  AdminServices.swift
//  ShiftLoggerSwiftUI
//
//  Created by Peter Lyn on 7/2/21.
//

import Foundation
import Combine

class AdminService {
    static let instance = AdminService()
    
    @Published var reportData: [ReportModel] = []
    @Published var uniqueProviders:[User] = []
    @Published var allProviders: [User] = []
    private var cancellables = Set<AnyCancellable>()
    
    private init() {}

    func generateReport(token: String, start: String, end: String) {

        guard let url = URL(string: "https://salty-oasis-56584.herokuapp.com/shifts/report") else { return }
        let body = ["start": start, "end": end]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(body)
        NetWorkingManager.download(request: request)
            .decode(type: [ReportModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetWorkingManager.handleCompletion) {[weak self] received in
                self?.reportData = received
            }
            .store(in: &cancellables)
    }
    
    func getAllUsers(token: String) {

        guard let url = URL(string: "https://salty-oasis-56584.herokuapp.com/user/allusers") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        NetWorkingManager.download(request: request)
            .decode(type: [User].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetWorkingManager.handleCompletion) {[weak self] users in
                self?.allProviders = users
            }
            .store(in: &cancellables)

    }
    
    func deleteUser(token: String, userId: String){

        guard let url = URL(string: "https://salty-oasis-56584.herokuapp.com/user/deleteUser/\(userId)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        NetWorkingManager.download(request: request)
            .decode(type: [String: String].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetWorkingManager.handleCompletion) { message in
                print(message)
            }
            .store(in: &cancellables)
    }
    
    func updateUser(token: String, userId: String, firstName: String, lastName: String, email: String){

        guard let url = URL(string: "https://salty-oasis-56584.herokuapp.com/user/updateUser/\(userId)") else { return }
        let body = ["firstName": firstName, "lastName": lastName, "email": email ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(body)
        NetWorkingManager.download(request: request)
            .decode(type: User.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetWorkingManager.handleCompletion) { user in
                print(user)
            }
            .store(in: &cancellables)
    }
}
