 import Foundation
 import UIKit
 import AWSDynamoDB
 import CalendarKit
 import DateToolsSwift
 
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
 enum TYPE : Int{
    typealias RawValue = Int
    case W = 0
    case USR = 1
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
//            print("Success");
        }
        return jsonObject
    }
}
 
enum TRIGGER_TYPE: Int{
    case MID = 0
    case SR = 1
    case SS = 2

}

class GB_Event{
    var zone_num: Int
    var trigger_type: TRIGGER_TYPE
    var time_offset : Int
    var duration : Int
    var mods : [Mod]
    var uuid : UUID
    
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
        self.uuid = UUID()
    }
//    func addMod(startDate: Date, endDate: Date){
//        let offset: Int = 0;
//        let mod : Mod = Mod(  date: ISO8601DateFormatter().string(from: startDate),
//                              time_offset: offset,
//                              duration: 3600,
//                              type: TYPE.USR
//                            )
//        self.mods.append(mod);
//    }
    
    static func getMidNightOffset(date: Date)-> Int{
        let cal = Calendar(identifier: .gregorian)
        let midNight = cal.startOfDay(for: date)
        let difference = Calendar.current.dateComponents([.second], from: midNight, to: date)
        return difference.second!;
    }

    func getStartTime(_ date: Date)-> Date{
        let cal = Calendar(identifier: .gregorian)
        var midNight = cal.startOfDay(for: date)
        var m_time_offset:Int = 0
        for m in mods{
            m_time_offset += m.time_offset;
        }
        midNight = midNight.addingTimeInterval(TimeInterval(self.time_offset + m_time_offset))
        return midNight
    }

    func getEndTime(_ start: Date)-> Date{
        let dateFormatter = ISO8601DateFormatter()
        var m_dur = -1
        for m in mods{
            let isoDate = m.date//"2016-04-14T10:44:00+0000"
            let m_date = dateFormatter.date(from:isoDate)!
            if (start == m_date){
                m_dur = m.duration
            }
        }
        if (m_dur >= 0){
            return start.addingTimeInterval(TimeInterval(m_dur))
        }
        return start.addingTimeInterval(TimeInterval(self.duration))
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
//            print("Success");
        }
        return jsonObject
    }
    
}
 
class Schedule{
    var sun: [GB_Event]
    var mon: [GB_Event]
    var tue: [GB_Event]
    var wed: [GB_Event]
    var thu: [GB_Event]
    var fri: [GB_Event]
    var sat: [GB_Event]
    static var Master: Schedule?
    static var Display: [Int: [EventDescriptor]]?
    
//    static func masterUpdate(){
//        let sched:schedules = schedules();
//        sched._sched = Schedule.Master?.convertToJSON();
//        print("                             ABOUT TO SEND \(String(describing: sched._sched))")
//        sched._uid = "100";
//        createTableEntry(sched: sched);
//    }
    
    func setDay(date: Int, new_list :[GB_Event]){
        switch date{
            case 1:
                Schedule.Master!.mon = new_list
            case 2:
                Schedule.Master!.tue = new_list
            case 3:
                Schedule.Master!.wed = new_list
            case 4:
                Schedule.Master!.thu = new_list
            case 5:
                Schedule.Master!.fri = new_list
            case 6:
                Schedule.Master!.sat = new_list
            default:
                Schedule.Master!.sun = new_list
        }
    }
    
    func addGBEvent(new:GB_Event, date:Date){
        var weekday = Calendar.current.component(.weekday, from: date)
        weekday -= 1;//remove eventually and re-implement
        switch weekday{
            case 1:
                Schedule.Master!.mon.append(new)
            case 2:
                Schedule.Master!.tue.append(new)
            case 3:
                Schedule.Master!.wed.append(new)
            case 4:
                Schedule.Master!.thu.append(new)
            case 5:
                Schedule.Master!.fri.append(new)
            case 6:
                Schedule.Master!.sat.append(new)
            default:
                Schedule.Master!.sun.append(new)
        }
        print("                 Events for today \(self.getDay(day: weekday))")
        Schedule.Display![weekday] = nil;
        let mod:Mod = Mod(date: ISO8601DateFormatter().string(from: Date()), time_offset: 0, duration: 0, type: TYPE.USR)
        new.mods = [mod]
        dynamoPut(uid: "100")
//        Schedule.masterUpdate();
    }
    /*populates the static "Display" variable given a date, this is meant to be called for each date, if the day has already been populated in the Display variable it won't regenerate it.
     the Display variable is reset everytime we receive a new schedule.
     */
    func translateToDisplay(_ date: Date)-> [EventDescriptor]{
        var weekday = Calendar.current.component(.weekday, from: date)
        weekday -= 1;//remove eventually and re-implement
        print("                     translate thinks the week day is :\(weekday)")
        print("                     date is :\(date.format(with: "yyyy-MM-dd HH:mm"))")
        if(Schedule.Display![weekday] != nil){
            print("GOTTEN FROM SAVED DISPLAY")
            return Schedule.Display![weekday]!
        }
        print("CALCULATED NEW DISPLAY")
        var disp_events = [Event]()
        
        let day = getDay(day: weekday)
        for curr in day{
            //each curr is a GB_Event
            let new:Event = Event();
            new.startDate = curr.getStartTime(date);
            new.endDate = curr.getEndTime(new.startDate)
            var info:[String] = ["Zone Number Active : \(curr.zone_num)", "Trigger Type : \(curr.trigger_type.rawValue)"]
            info.append("\(new.startDate.format(with: "HH:mm")) - \(new.endDate.format(with: "HH:mm"))");
            info.append(curr.uuid.uuidString)
            print("creating event ID : \(curr.uuid.uuidString)")
            new.text = info.reduce("", {$0 + $1 + "\n"})
            new.color = UIColor.darkGray
            new.backgroundColor = UIColor(red: 0, green: 0.749, blue: 0, alpha: 1.0)
            disp_events.append(new)
        }
        Schedule.Display![weekday] = disp_events
        return disp_events
    }
    
    static func updateEvent(startDate: Date, endDate: Date, eventInfo: Event){
        print("inside updateEvent");
        let eventlst = eventInfo.text.split(separator: "\n")
        let Events = Schedule.Master!.getDay(day: Calendar.current.component(.weekday, from: startDate) - 1)
        var local_list:[GB_Event] = []
        for ev in Events{
            if (ev.uuid.uuidString == eventlst[eventlst.endIndex - 1]) {
                ev.time_offset = GB_Event.getMidNightOffset(date: startDate)
            }
            local_list.append(ev)
        }
        Schedule.Master!.setDay(date: Calendar.current.component(.weekday, from: startDate) - 1, new_list: local_list)
//        Schedule.masterUpdate()
        dynamoPut(uid: "100")
    }
    
    func getDay(day :Int)-> [GB_Event]{
        switch day{
            case 1:
                return Schedule.Master!.mon
            case 2:
                return Schedule.Master!.tue
            case 3:
                return Schedule.Master!.wed
            case 4:
                return Schedule.Master!.thu
            case 5:
                return Schedule.Master!.fri
            case 6:
                return Schedule.Master!.sat
            default:
                return Schedule.Master!.sun
        }
    }
    

    init(
        sun: [GB_Event],
        mon: [GB_Event],
        tue: [GB_Event],
        wed: [GB_Event],
        thu: [GB_Event],
        fri: [GB_Event],
        sat: [GB_Event]
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
//            print("Success");
        }
        return jsonObject
    }
    
}

 
func processResp(resp: [String: [[String: Any]]]){
     let s: [GB_Event] = buildEventList(day: "sun", data:resp)
     let m: [GB_Event] = buildEventList(day: "mon", data:resp)
     let t: [GB_Event] = buildEventList(day: "tue", data:resp)
     let w: [GB_Event] = buildEventList(day: "wed", data:resp)
     let th: [GB_Event] = buildEventList(day: "thu", data:resp)
     let fr: [GB_Event] = buildEventList(day: "fri", data:resp)
     let st: [GB_Event] = buildEventList(day: "sat", data:resp)
     Schedule.Master = Schedule(sun:s, mon: m, tue:t, wed:w, thu:th, fri:fr, sat:st)
     Schedule.Display = [Int: [EventDescriptor]]()
 }
func buildEventList(day: String, data: [String: [[String: Any]]])-> [GB_Event]{
     var list:[GB_Event] = []
     for e in (data[day])!{
        var m_list:[Mod] = []
        for m in (e["mods"] as? [[String: Any]])!{
            let typ:TYPE = TYPE(rawValue: m["type"] as! Int)!
             m_list.append(Mod(date: m["date"] as! String, time_offset: m["time_offset"] as! Int, duration: m["duration"] as! Int, type: typ))
         }
        let trig_type:TRIGGER_TYPE = TRIGGER_TYPE(rawValue: e["trigger_type"] as! Int)!
         let curr: GB_Event = GB_Event(zone_num: e["zone_num"] as! Int, trigger_type: trig_type, time_offset: e["time_offset"] as! Int, duration: e["duration"] as! Int, mods: m_list)
         list.append(curr)
     }
     return list
 }
