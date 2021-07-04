//
//  AdminView.swift
//  ShiftLoggerSwiftUI
//
//  Created by Peter Lyn on 6/22/21.
//

import SwiftUI

struct AdminView: View {
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var mainVM: MainViewModel
    @StateObject var adminVM = AdminViewModel()
    @State private var showReport = false
    @State private var showUsers = false
    @State private var startPickerOpen = false
    @State private var endPickerOpen = false

    
    var body: some View {
        VStack {
            Form {
                DatePicker("Start Date", selection: $adminVM.startDate, displayedComponents: .date)
                DatePicker("End Date", selection: $adminVM.endDate, displayedComponents: .date)
            }.frame(height: 200)
            Button(action: {
                adminVM.getReport(token: loginVM.token, start: adminVM.startDate, end: adminVM.endDate)
                showReport.toggle()
                
            }, label: {
                Text("Generate Report")
                    .font(.title3)
                    .padding(10)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
            })
            Button(action: {
                adminVM.getAllProviders(token: loginVM.token)
                showUsers.toggle()
            }, label: {
                Text("Manage Users")
                    .font(.title3)
                    .padding(10)
                    .background(Color.green)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            })
            Spacer()
            
            NavigationLink(
                destination: ReportView(adminVM: adminVM),
                isActive: $showReport,
                label: {
                    Text("")
                })
            NavigationLink(
             destination: ManageUsers(adminVM: adminVM),
                isActive: $showUsers,
             label: {
                Text("")
             })
        }
        .navigationTitle("Admin Page")
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}
