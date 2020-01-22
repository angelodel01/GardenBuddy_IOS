//
//  ViewController.swift
//  DynamoDemo
//
//  Created by Angelo De Laurentis on 1/22/20.
//  Copyright © 2020 Angelo De Laurentis. All rights reserved.
//

import Foundation
import UIKit
import AWSDynamoDB

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func putBtn(){
        createMes();
    }
    
    func createMes() {
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()

        // Create data object using data models you downloaded from Mobile Hub
        let TGB: TestGardenBuddyV1 = TestGardenBuddyV1()
        var mes = Set<String>();
        mes.insert("Hello this is the garden buddy app");
        TGB._message = mes;
        TGB._userId = "thisismyid";

        //Save a new item
        dynamoDbObjectMapper.save(TGB, completionHandler: {
         (error: Error?) -> Void in

             if let error = error {
                 print("Amazon DynamoDB Save Error: \(error)")
                 return
             }
             print("An item was saved.")
         })
    }


}

