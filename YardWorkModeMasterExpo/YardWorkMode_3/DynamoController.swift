//
//  DynamoController.swift
//  CalendarApp
//
//  Created by Angelo De Laurentis on 2/22/20.
//  Copyright © 2020 Richard Topchii. All rights reserved.
//

import Foundation
import AWSDynamoDB

func dynamoPut(uid:String){
    let sched: schedules = schedules()
    sched._sched = Schedule.Master!.convertToJSON()
//    print("About to send:\n\(sched._sched!)")
    sched._uid = uid;
    createTableEntry(sched: sched);
}
func dynamoGet(){
    getTableEntry(key: "100")
}

func createTableEntry(sched: schedules) {
//    print("                 TRYING TO CREATE TABLE ENTRY")
    let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
    //Save a new item
    dynamoDbObjectMapper.save(sched, completionHandler: {
     (error: Error?) -> Void in
         if let error = error {
             print("Amazon DynamoDB Save Error: \(error)")
             return
         }
         print("An item was saved.")
     })
}

func getTableEntry(key : String){
    // 1) Configure the query
    let queryExpression = AWSDynamoDBQueryExpression()
     queryExpression.keyConditionExpression = "#uid = :uid"
    queryExpression.expressionAttributeNames = [
        "#uid" : "uid"
    ]

    queryExpression.expressionAttributeValues = [
        ":uid" : key
    ]
    // 2) Make the query
    let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()

    dynamoDbObjectMapper.query(schedules.self, expression: queryExpression) { (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
        if error != nil {
            print("The request failed. Error: \(String(describing: error))")
        }
        if output != nil {
            for sched in output!.items {
                let curr = sched as? schedules
                let resp = curr!._sched!
//                print("response : \(resp)")
                processResp(resp: resp)
//                print("parsed into object : ", Schedule.Master!.sun[0].trigger_type)
            }
        }
    }
}
