//
//  ReportView.swift
//  ShiftLoggerSwiftUI
//
//  Created by Peter Lyn on 6/22/21.
//

import SwiftUI

struct ReportView: View {
    @ObservedObject var adminVM: AdminViewModel
    
    var body: some View {
        VStack {
            ForEach(adminVM.uniqueProviders) { provider in
                List {
                    Section(header: Text("\(provider.lastName), \(provider.firstName)")) {
                        ForEach(adminVM.reportData) { shift in
                            if shift.provider._id == provider._id {
                                HStack {
                                    Text(shift.formattedDate)
                                    Spacer()
                                    Text(shift.shift)
                                    Spacer()
                                    Text(shift.formattedHours)
                                }.font(.subheadline)
                                .padding()
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView(adminVM: AdminViewModel())
    }
}
