//
//  AddEditView.swift
//  ShiftLoggerSwiftUI
//
//  Created by Peter Lyn on 6/20/21.
//

import SwiftUI

struct AddEditView: View {
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var mainVM: MainViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var shiftId: String = ""
    @State var selectedShift: String = ""
    @State var hours: Double = 12.0
    @State var isEdit: Bool = false
    
    let step = 0.5
    let range = 1.0...24.0
    
    let options = [
       "STM A",
       "STM B",
       "STM C",
       "STM D",
       "STM E",
       "STM S",
       "STM N",
       "STM X",
       "STM Y",
       "STM O",
       "STM IMH",
     ]
    
    var hoursText:String {
        String(format: "%.1f", hours)
    }
    
    
    var body: some View {
        VStack {
            Form {
                    Picker(selection: $selectedShift, label: Text("Shift")) {
                        ForEach(options, id:\.self){ option in
                           Text(option)
                        }
                    }
                    Stepper(value: $hours,
                            in: range,
                            step: step) {
                        Text("Hours: \(hoursText)")
                    }
             
            }.frame(height: 150)
            Button(action: {
                isEdit ?  mainVM.editShift(token: loginVM.token, shiftId: shiftId, shift: selectedShift, hours: hours) :
                mainVM.addShift(token: loginVM.token, shift: selectedShift, hours: hours)
                    presentationMode.wrappedValue.dismiss()
                
            }, label: {
                Text(isEdit ? "Edit Shift" : "Add Shift")
                    .font(.title3)
                    .padding(10)
                    .background(isEdit ? Color.green : Color.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
            })
            Spacer()
        }
        .navigationTitle("\(mainVM.workingDateString)")
    }
}

struct AddEditView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditView().environmentObject(MainViewModel())
            .environmentObject(LoginViewModel())
    }
}
