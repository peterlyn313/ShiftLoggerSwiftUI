//
//  LoginViewModel.swift
//  ShiftLoggerSwiftUI
//
//  Created by Peter Lyn on 6/13/21.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var showProgess = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var confirmPassword: String = ""
    @Published var adminCode: String = ""
    @Published var isRegister = false
    @Published var showAlert = false
    @Published var fieldInvalidMessage = ""
    @Published var isLoggedIn = false
    @Published var token: String = ""
    @Published var user: User = User(email: "", firstName: "", lastName: "", isActive: true, isAdmin: false, _id: "")
    private var cancellables = Set<AnyCancellable>()
    
    
    
    let authService = AuthService.instance
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        authService.$isLoggedIn
            .combineLatest(authService.$token, authService.$user)
            .sink { [weak self] (logStatus, token, user) in
                self?.isLoggedIn = logStatus
                self?.token = token
                self?.user = user
            }
            .store(in: &cancellables)
        
        authService.$fieldInvalidMessage
            .sink { [weak self] returnedMessage in
                self?.fieldInvalidMessage = returnedMessage
            }
            .store(in: &cancellables)
    }
    
    
    func clearFields() {
        email = ""
        password = ""
        firstName = ""
        lastName = ""
        confirmPassword = ""
        adminCode = ""
    }
    
    func login() {
        if email.count < 3 {
            fieldInvalidMessage = "email is invalid"
            showAlert = true
            return
        }
        
        if password.count < 6 {
            fieldInvalidMessage = "password is invalid"
            showAlert = true
            return
        }
        
        authService.login(email: email, password: password)
    }
    
    func register() {
        if firstName.count < 1 {
            fieldInvalidMessage = "First name is required"
            showAlert = true
            return
        }
        
        if lastName.count < 6 {
            fieldInvalidMessage = "Last name is required"
            showAlert = true
            return
        }
        
        
        if email.count < 3 {
            fieldInvalidMessage = "email is invalid"
            showAlert = true
            return
        }
        
        if password.count < 6 {
            fieldInvalidMessage = "password is invalid"
            showAlert = true
            return
        }
        
        if password != confirmPassword {
            fieldInvalidMessage = "passwords do not match"
            showAlert = true
            return
        }
        

        
        authService.register(firstName: firstName, lastName: lastName, email: email, password: password, confirmPassword: confirmPassword, adminCode: adminCode)
    }
    
    
    func logout() {
        authService.user = User(email: "", firstName: "", lastName: "", isActive: true, isAdmin: false, _id: "")
        authService.isLoggedIn = false
        authService.token = ""
        showProgess = false
        clearFields()
    }
    
}
