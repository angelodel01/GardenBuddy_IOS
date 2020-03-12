//
//  YardWorkZone.swift
//  MasterV1Back
//
//  Created by Angelo De Laurentis on 1/27/20.
//  Copyright © 2020 Angelo De Laurentis. All rights reserved.
//
import Foundation
import UIKit

class YardWorkZone {
    var zone_num: Int?
    var duration: Int?
    
    init(zone_num: Int, duration: Int){
        self.zone_num = zone_num;
        self.duration = duration;
    }
    
    static func convertToYardWorkZone(text: String) -> YardWorkZone? {
        if let data = text.data(using: .utf8) {
            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let ywz: YardWorkZone = YardWorkZone(zone_num: dict!["zone_num"] as! Int, duration: dict!["duration"] as! Int)
                return ywz
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    
    func convertToJSONString() -> String{
        let jsonObject: [String: Int?] = [
            "zone_num": self.zone_num,
            "duration": self.duration
        ]
        let valid = JSONSerialization.isValidJSONObject(jsonObject) // true
        if (!valid){
            print("ERROR can't parse YardWorkZone data")
        }else{
            print("Success");
        }
        let dic = jsonObject
        var jsonString = ""
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(dic) {
            jsonString = String(data: jsonData, encoding: .utf8) as! String
        }
        return jsonString;
    }
    
}

