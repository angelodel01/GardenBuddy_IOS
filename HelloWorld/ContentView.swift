//
//  ContentView.swift
//  HelloWorld
//
//  Created by Angelo De Laurentis on 10/3/19.
//  Copyright © 2019 Angelo De Laurentis. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        Text("Hello World how are you");
        Button(action: {
            // your action here
            print("button clicked");
        }) {
            Text("Button title");
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
