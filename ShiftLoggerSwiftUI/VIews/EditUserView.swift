//
//  EditUserView.swift
//  ShiftLoggerSwiftUI
//
//  Created by Peter Lyn on 6/23/21.
//

import SwiftUI

struct EditUserView: View {
    @EnvironmentObject var loginVM: LoginViewModel
    @ObservedObject var adminVM: AdminViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var userId: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    
    
    var body: some View {
        VStack {
            Form {
                TextField("First Name", text: $firstName)
                    .padding()
                    .frame(height: 55)
                TextField("Last Name", text: $lastName)
                    .padding()
                    .frame(height: 55)
                
                TextField("Email", text: $email)
                    .padding()
                    .frame(height: 55)
                    .autocapitalization(.none)
            }.frame(height: 150)
            Button(action: {
                adminVM.updateUser(token: loginVM.token, userId: userId, firstName: firstName, lastName: lastName, email: email)
                    presentationMode.wrappedValue.dismiss()
                
            }, label: {
                Text("Update")
                    .font(.title3)
                    .padding(10)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
            })
            Spacer()
        }
    }
}

struct EditUserView_Previews: PreviewProvider {
    static var previews: some View {
        EditUserView(adminVM: AdminViewModel())
    }
}
