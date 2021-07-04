//
//  DayView.swift
//  ShiftLoggerSwiftUI
//
//  Created by Peter Lyn on 6/18/21.
//

import SwiftUI

struct DayView: View {
    var dayNum: Int
    var dayArray: [Int]
    var selected: Int
    var isCurrentDay: Bool
    
    var body: some View {
        VStack {
            Text("\(dayNum)")
                .padding(2)
                .shadow(radius: 2)
            Circle()
                .frame(width: 2, height: 2)
                .padding(.bottom, 2)
                .foregroundColor(.blue)
                .opacity(dayArray.contains(dayNum) ? 1 : 0)
            
        }
        .frame(minWidth: 25)
        .background(isCurrentDay ? Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)): Color.clear)
        .border(selected == dayNum ?  Color.blue : Color.clear)
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DayView(dayNum: 1, dayArray: [1,2,3], selected: 1, isCurrentDay: true)
                .previewLayout(.sizeThatFits)
         
        }
    }
}
