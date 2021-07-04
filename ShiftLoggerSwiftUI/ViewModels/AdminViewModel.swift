//
//  AdminViewModel.swift
//  ShiftLoggerSwiftUI
//
//  Created by Peter Lyn on 6/22/21.
//

import Foundation
import Combine

class AdminViewModel: ObservableObject {
    let dateService = DateService.instance
    let adminService = AdminService.instance
    @Published var startDate = Date()
    @Published var endDate = Date()
    @Published var reportData: [ReportModel] = []
    @Published var uniqueProviders:[User] = []
    @Published var allProviders: [User] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    func addSubscribers() {
        adminService.$reportData
            .sink { downloaded in
                self.reportData = downloaded
                self.generateUniqueProviders()
            }
            .store(in: &cancellables)
        
        adminService.$allProviders
            .sink { providers in
                self.allProviders = providers
            }
            .store(in: &cancellables)
    }

    
    func getReport(token: String, start: Date, end: Date) {
        let formattedStart = dateService.getDateForApi(date: start)
        let formattedEnd = dateService.getDateForApi(date: end)
        adminService.generateReport(token: token, start: formattedStart, end: formattedEnd)
    }
    
    func generateUniqueProviders() {
        let providers: [User] = reportData.map { $0.provider }
      let unsortedProviders =  Array(Set(providers))
        DispatchQueue.main.async {
            self.uniqueProviders = unsortedProviders.sorted{ $0.lastName < $1.lastName }
        }
    }
    
    func getAllProviders(token: String) {
        adminService.getAllUsers(token: token)
    }
    
    func deleteUser(token: String, userId: String) {
        adminService.deleteUser(token: token, userId: userId)
    }
    
    func updateUser(token: String, userId: String, firstName: String, lastName: String, email: String) {
        adminService.updateUser(token: token, userId: userId, firstName: firstName, lastName: lastName, email: email)
    }
  
    
}
