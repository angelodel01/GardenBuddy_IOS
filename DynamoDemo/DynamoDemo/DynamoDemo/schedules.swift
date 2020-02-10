 import Foundation
 import UIKit
 import AWSDynamoDB
 
 class schedules: AWSDynamoDBObjectModel, AWSDynamoDBModeling {

      @objc var _uid: String?
      @objc var _sched: [String : [[String: Any]]]?


      class func dynamoDBTableName() -> String {
          return "schedules"
      }

      class func hashKeyAttribute() -> String {
          return "_uid"
      }

      override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
          return [
              "_uid" : "uid",
              "_sched" : "sched"
          ]
      }
}
 
//Mod structure definition
enum TYPE : String{
    case W
    case USR
}

class Mod{
    var date: String
    var time_offset: Int
    var duration: Int
    var type: TYPE
    
    init(
        date: String,
        time_offset: Int,
        duration: Int,
        type: TYPE
    ){
        self.date = date
        self.time_offset = time_offset
        self.duration = duration
        self.type = type
    }

    func convertToJSON() -> [String: Any]{
        let jsonObject : [String : Any] = [
            "date": self.date,
            "time_offset": self.time_offset,
            "duration": self.duration,
            "type": self.type.rawValue
            ]
        let valid = JSONSerialization.isValidJSONObject(jsonObject) // true
        if (!valid){
            print("ERROR can't parse mod data")
        }else{
            print("Success");
        }
        return jsonObject
    }
}
 
enum TRIGGER_TYPE: Int{
    case MID = 0
    case SR = 1
    case SS = 2

}

class Event{
    var zone_num: Int
    var trigger_type: TRIGGER_TYPE
    var time_offset : Int
    var duration : Int
    var mods : [Mod]
    
    init(
        zone_num: Int,
        trigger_type: TRIGGER_TYPE,
        time_offset : Int,
        duration : Int,
        mods : [Mod]
    ){
        self.zone_num = zone_num
        self.trigger_type = trigger_type
        self.time_offset = time_offset
        self.duration = duration
        self.mods = mods
    }
    
    
    func convertToJSON() -> [String: Any]{
        var mod_lst:[[String: Any]] = []
        for m in self.mods{
            mod_lst.append(m.convertToJSON())
        }
        let jsonObject : [String : Any] = [
            "zone_num": self.zone_num,
            "trigger_type": self.trigger_type.rawValue,
            "time_offset": self.time_offset,
            "duration": self.duration,
            "mods": mod_lst
            ]
        let valid = JSONSerialization.isValidJSONObject(jsonObject) // true
        if (!valid){
            print("ERROR can't parse mod data")
        }else{
            print("Success");
        }
        return jsonObject
    }
    
}
 
class Schedule{
    var sun: [Event]
    var mon: [Event]
    var tue: [Event]
    var wed: [Event]
    var thu: [Event]
    var fri: [Event]
    var sat: [Event]
    static var Master: Schedule?

    init(
        sun: [Event],
        mon: [Event],
        tue: [Event],
        wed: [Event],
        thu: [Event],
        fri: [Event],
        sat: [Event]
    ){
        self.sun = sun
        self.mon = mon
        self.tue = tue
        self.wed = wed
        self.thu = thu
        self.fri = fri
        self.sat = sat
    }
    
    func convertToJSON() -> [String: [[String: Any]] ]{
        var sun_lst:[[String: Any]] = []
        for e in self.sun{
            sun_lst.append(e.convertToJSON())
        }
        var mon_lst:[[String: Any]] = []
        for e in self.mon{
            mon_lst.append(e.convertToJSON())
        }
        var tue_lst:[[String: Any]] = []
        for e in self.tue{
            tue_lst.append(e.convertToJSON())
        }
        var wed_lst:[[String: Any]] = []
        for e in self.wed{
            wed_lst.append(e.convertToJSON())
        }
        var thu_lst:[[String: Any]] = []
        for e in self.thu{
            thu_lst.append(e.convertToJSON())
        }
        var fri_lst:[[String: Any]] = []
        for e in self.fri{
            fri_lst.append(e.convertToJSON())
        }
        var sat_lst:[[String: Any]] = []
        for e in self.sat{
            sat_lst.append(e.convertToJSON())
        }
        let jsonObject : [String : [[String: Any]]] = [
            "sun": sun_lst,
            "mon": mon_lst,
            "tue": tue_lst,
            "wed": wed_lst,
            "thu": thu_lst,
            "fri": fri_lst,
            "sat": sat_lst
            ]
        let valid = JSONSerialization.isValidJSONObject(jsonObject) // true
        if (!valid){
            print("ERROR can't parse mod data")
        }else{
            print("Success");
        }
        return jsonObject
    }
    
}

 
func processResp(resp: [String: [[String: Any]]]){
     let s: [Event] = buildEventList(day: "sun", data:resp)
     let m: [Event] = buildEventList(day: "mon", data:resp)
     let t: [Event] = buildEventList(day: "tue", data:resp)
     let w: [Event] = buildEventList(day: "wed", data:resp)
     let th: [Event] = buildEventList(day: "thu", data:resp)
     let fr: [Event] = buildEventList(day: "fri", data:resp)
     let st: [Event] = buildEventList(day: "sat", data:resp)
     Schedule.Master = Schedule(sun:s, mon: m, tue:t, wed:w, thu:th, fri:fr, sat:st)
 }
func buildEventList(day: String, data: [String: [[String: Any]]])-> [Event]{
     var list:[Event] = []
     for e in (data[day])!{
         var m_list:[Mod] = []
        for m in (e["mods"] as? [[String: Any]])!{
            let typ:TYPE = TYPE(rawValue: m["type"] as! String)!
             m_list.append(Mod(date: m["date"] as! String, time_offset: m["time_offset"] as! Int, duration: m["duration"] as! Int, type: typ))
         }
        let trig_type:TRIGGER_TYPE = TRIGGER_TYPE(rawValue: e["trigger_type"] as! Int)!
         let curr: Event = Event(zone_num: e["zone_num"] as! Int, trigger_type: trig_type, time_offset: e["time_offset"] as! Int, duration: e["duration"] as! Int, mods: m_list)
         list.append(curr)
     }
     return list
 }
