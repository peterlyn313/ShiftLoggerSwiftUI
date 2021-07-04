//
//  MainView.swift
//  ShiftLoggerSwiftUI
//
//  Created by Peter Lyn on 6/17/21.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var mainVM: MainViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var showAdmin = false
    
    
    
    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
        ]
        
        let days: [String] = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
        let activeMonth = mainVM.workingDate
        let displayDate = mainVM.getDisplayDate(date: activeMonth)
        let rangeForCal = mainVM.getRangeLengthForCal(date: activeMonth)
        let paddingDays = mainVM.getPaddingDays(date: activeMonth)
        let shiftsDayArray = mainVM.makeDayArray(shifts: mainVM.shiftData)
        
        
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(days, id: \.self) { day in
                            Text(day)
                        }
                        ForEach(1...rangeForCal, id: \.self) { num in
                            if num <= paddingDays {
                                Text(" ")
                            } else {
                                DayView(dayNum: (num - paddingDays), dayArray: shiftsDayArray, selected: mainVM.highlightedDay, isCurrentDay: mainVM.isCurrentDay(dayNum: num - paddingDays))
                                    .onTapGesture {
                                        mainVM.clickedDay = num - paddingDays
                                        mainVM.calcshiftsForDay()
                                    }
                            }
                        }
                    }.padding()
                    .border(Color.black)
                    
                    ShiftListView()
                    
                }.navigationTitle("\(displayDate)")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading:
                        HStack {
                            Button(action: {
                                mainVM.changeMonth(.decrease, token: loginVM.token)
                            }, label: {
                                Image(systemName: "chevron.left.circle.fill").font(.title)
                            }).padding(.trailing, 35)
                            NavigationLink(
                                destination: AddEditView(),
                                label: {
                                    Image(systemName: "plus").font(.title2)
                                })
                        },
                    trailing:
                        HStack {
                            Button("LogOut") {
                                loginVM.logout()
                                presentationMode.wrappedValue.dismiss()
                            }.padding(.trailing)
                            
                            Button(action: {
                                mainVM.changeMonth(.increase, token: loginVM.token)
                            }, label: {
                                Image(systemName: "chevron.right.circle.fill").font(.title)
                            })
                            
                            
                            
                        }
                )
                
                NavigationLink(
                    destination: AdminView(),
                    label: {
                        Text("Admin")
                            .padding(10)
                            .background(Color(#colorLiteral(red: 0.2922810316, green: 0.4576432705, blue: 1, alpha: 1)))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .opacity(loginVM.user.isAdmin ? 1 : 0)
                    }).disabled(!loginVM.user.isAdmin)
                
            }
        }.onAppear(perform: {
            mainVM.changeMonth(.noChange, token: loginVM.token)
        })
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(MainViewModel())
            .environmentObject(LoginViewModel())
    }
}


