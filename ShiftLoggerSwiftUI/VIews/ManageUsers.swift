//
//  ManageUsers.swift
//  ShiftLoggerSwiftUI
//
//  Created by Peter Lyn on 6/22/21.
//

import SwiftUI

struct ManageUsers: View {
    @EnvironmentObject var loginVM: LoginViewModel
    @ObservedObject var adminVM: AdminViewModel
    var body: some View {
        VStack{
            List {
                ForEach(adminVM.allProviders){ provider in
                    NavigationLink(
                        destination: EditUserView(adminVM: adminVM, userId: provider._id, firstName: provider.firstName, lastName: provider.lastName, email: provider.email),
                        label: {
                            Text("\(provider.lastName), \(provider.firstName)")
                        })
                     
                }.onDelete(perform: onDelete)
            }.onAppear { adminVM.getAllProviders(token: loginVM.token) }
        }
    }
    
    private func onDelete(offsets: IndexSet) {
        guard let indexToDelete = offsets.first else { return }
        let userToDelete = adminVM.allProviders[indexToDelete]
        let userId = userToDelete.id
        adminVM.allProviders.remove(atOffsets: offsets)
        adminVM.deleteUser(token: loginVM.token, userId: userId)
    }
}

struct ManageUsers_Previews: PreviewProvider {
    static var previews: some View {
        ManageUsers(adminVM: AdminViewModel())
    }
}
