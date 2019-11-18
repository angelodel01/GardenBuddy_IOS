//
//  ContentView.swift
//  HelloWorld
//
//  Created by Angelo De Laurentis on 10/3/19.
//  Copyright © 2019 Angelo De Laurentis. All rights reserved.
//

import SwiftUI
import AWSCore
import AWSMobileClient
import AWSDynamoDB

struct ContentView: View {
    var body: some View {
//        Text("Hello World how are you");
        Button(action: {
            // your action here
            print("button clicked");
            let deviceid:String = (UIDevice.current.identifierForVendor?.uuidString)!
            let message:Set = ["mess"]
            let objectMapper = AWSDynamoDBObjectMapper.default()
            
            let itemToCreate:TestGardenBuddyV1 = TestGardenBuddyV1()
            itemToCreate._userId = deviceid
            itemToCreate._message = message
            
            objectMapper.save(itemToCreate, completionHandler:{(error : Error?) -> Void in
                if let error = error{
                    print("Amazon DynamoDB save error: \(error)")
                    return
                }
                print("User information updated")
            })
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
