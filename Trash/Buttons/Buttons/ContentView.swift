//
//  ContentView.swift
//  Buttons
//
//  Created by Nicholas Balestrino on 11/17/19.
//  Copyright © 2019 Misc. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var totalclick: Int = 0
    
   var body: some View {
        VStack {
            Text("\(totalclick)")
            Button(action: {self.totalclick = self.totalclick + 1}) {
            Text("Increment Total")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
