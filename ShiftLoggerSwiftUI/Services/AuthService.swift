//
//  Webservice.swift
//  ShiftLoggerSwiftUI
//
//  Created by Peter Lyn on 6/13/21.
//

import Foundation
import Combine

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

enum AuthenticationError: Error {
    case invalidCredentials
    case custom(errorMessage: String)
}

class AuthService {
    static let instance = AuthService()
    @Published var fieldInvalidMessage = ""
    @Published var isLoggedIn = false
    @Published var token: String = ""
    @Published var user: User = User(email: "", firstName: "", lastName: "", isActive: true, isAdmin: false, _id: "")
    private var cancellables = Set<AnyCancellable>()
    
    private init() {}
    
    func login (email: String, password: String) {
        guard let url = URL(string: "https://salty-oasis-56584.herokuapp.com/user/login") else { return }
        let body = ["email": email, "password": password]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        NetWorkingManager.download(request: request)
            .decode(type: LoginResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: self.handleCompletion) { [weak self] loginResponse in
                self?.token = loginResponse.token
                self?.user = loginResponse.result
                self?.isLoggedIn = true
            }
            .store(in: &cancellables)
    }
    
    
    func register(firstName: String,
                  lastName: String,
                  email: String,
                  password: String,
                  confirmPassword: String,
                  adminCode: String
                  ) {
        
        guard let url = URL(string: "https://salty-oasis-56584.herokuapp.com/user/register") else { return  }
        
         let body = ["firstName": firstName,
                          "lastName": lastName,
                          "email": email,
                          "password": password,
                          "confirmPassword": confirmPassword,
                          "adminCode": adminCode
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        NetWorkingManager.download(request: request)
            .decode(type: LoginResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: self.handleCompletion) { [weak self] loginResponse in
                self?.token = loginResponse.token
                self?.user = loginResponse.result
                self?.isLoggedIn = true
            }
            .store(in: &cancellables)
    
    }
    
    
    func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            self.fieldInvalidMessage = error.localizedDescription
            print(error.localizedDescription)
        }
    }

    
}
