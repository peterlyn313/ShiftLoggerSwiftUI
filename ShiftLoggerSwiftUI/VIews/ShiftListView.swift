//
//  ShiftListView.swift
//  ShiftLoggerSwiftUI
//
//  Created by Peter Lyn on 6/19/21.
//

import SwiftUI

struct ShiftListView: View {
    
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var mainVM: MainViewModel
    
    
    var body: some View {
        if mainVM.shiftsForDay.isEmpty {
            Text("No shifts").padding(100)
        } else {
                List {
                    HStack {
                        Text(mainVM.shiftsForDay.count > 1 ? "Shifts" : "Shift").font(.headline)
                        Text("for \(mainVM.workingDateString)").font(.headline)
                    }.padding(.vertical)
                    ForEach(mainVM.shiftsForDay) { shift in
                        HStack {
                            Text(shift.shift)
                            Spacer()
                            Text("\(shift.formattedHours) hours")
                            Spacer()
                            NavigationLink(
                                destination: AddEditView(shiftId: shift.id, selectedShift: shift.shift, hours: shift.hours, isEdit: true),
                                label: {
                                    
                                })
                        }
                    }.onDelete(perform: onDelete)
                    
                }.frame(height: 300)
                .listStyle(PlainListStyle())
        }
    }
    private func onDelete(offsets: IndexSet) {
        guard let indexToDelete = offsets.first else { return }
        let shiftToDelete = mainVM.shiftsForDay[indexToDelete]
        let shiftId = shiftToDelete.id
        mainVM.deleteShift(token: loginVM.token, shiftId: shiftId)
    }
}

struct ShiftListView_Previews: PreviewProvider {
    static var previews: some View {
        ShiftListView().environmentObject(LoginViewModel()).environmentObject(MainViewModel())
    }
}
