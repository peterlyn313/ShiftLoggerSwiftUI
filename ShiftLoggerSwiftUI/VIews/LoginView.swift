//
//  LoginView.swift
//  ShiftLoggerSwiftUI
//
//  Created by Peter Lyn on 6/13/21.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var loginVM: LoginViewModel
    
    @State private var showAdmin = false
 
    
    var body: some View {
        
        ZStack {
            VStack {
                Text("ShiftLogger")
                    .font(.system(.title, design: .rounded))
                    .foregroundColor(.primary)
                Form {
                    if loginVM.isRegister {
                        TextField("First Name", text: $loginVM.firstName)
                            .padding()
                            .frame(height: 55)
                        TextField("Last Name", text: $loginVM.lastName)
                            .padding()
                            .frame(height: 55)
                    }
                    TextField("Email", text: $loginVM.email)
                        .padding()
                        .frame(height: 55)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $loginVM.password)
                        .padding()
                        .frame(height: 55)
                        .autocapitalization(.none)
                    if loginVM.isRegister{
                        SecureField("Confirm Password", text: $loginVM.confirmPassword)
                            .padding()
                            .frame(height: 55)
                            .autocapitalization(.none)
                    }
                    if loginVM.isRegister && showAdmin {
                        TextField("Enter Admin code", text: $loginVM.adminCode)
                            .padding()
                            .frame(height: 55)
                            .autocapitalization(.none)
                        
                    }
                    Button(action: {
                        loginVM.showProgess.toggle()
                        loginVM.isRegister ? loginVM.register() :
                            loginVM.login()
                    }, label: {
                        Text(loginVM.isRegister ? "Register" : "Login")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    })
                    Button(loginVM.isRegister ? "Already Registered? Login here." : "New? Register here.") {
                        loginVM.clearFields()
                        withAnimation {
                            loginVM.isRegister.toggle()
                        }
                        
                    }
                    if loginVM.isRegister {
                        Button(action: {
                            withAnimation {
                                showAdmin.toggle()
                            }
                            
                        }, label: {
                            Text("Admin User?")
                        })
                    }
                    
                }
                .padding(.top, 10.0)
                .alert(isPresented: $loginVM.showAlert) {
                    Alert(title: Text("Invalid Fields"), message: Text(loginVM.fieldInvalidMessage), dismissButton: .default(Text("OK")))
                }
                .fullScreenCover(isPresented: $loginVM.isLoggedIn, content: {
                    MainView()
                })
            }.navigationBarHidden(true)
            .opacity(loginVM.showProgess ? 0 : 1)
            
            ProgressView()
                .opacity(loginVM.showProgess ? 1 : 0)
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
                .environmentObject(LoginViewModel())
        }
    }
}
