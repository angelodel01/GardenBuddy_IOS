//
//  PopUpView.swift
//  YardWorkMode_3
//
//  Created by Nicholas Balestrino on 2/12/20.
//  Copyright © 2020 Misc. All rights reserved.
//

import UIKit
import SwiftSocket

protocol PopUpViewDelegate: NSObjectProtocol {
    func zoneTimerUpdate(list: [Double])
    func currentStatusUpdate(type: String, num: Int)
}

class PopUpView: UIViewController {
    
    // TCP STUFF !!!
    let host = "192.168.43.78"    // 192.168.43.78 192.168.43.121
    let port = 7                  // 7
    var client: TCPClient?
    
    @IBOutlet weak var popupArea: UIView!
    
    @IBOutlet weak var connectOrNot: UILabel! //mqtt or tcp
    @IBOutlet weak var ZoneInput: UINavigationItem! //zone #
    
    @IBOutlet weak var CountdownTimer: UIDatePicker!
    var isTimerOn = false
    var timerValue: Double = 0
    var prevValue: Double = 0
    var zonetimes: [Double] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11] //list of all zone times
    var zoneNumb: String = ""
    var zoneInt: Int = 0

    
    var connectionStatus: String = "" //Connected/NotConnected
    var currentOnOff: String = "" //"Curren Status: On/Off
    var zoneName = "Idk zone"   //"Zone 1"
    
    weak var delegate: PopUpViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ZoneInput.title! = zoneName            //gets Zone from prev controller
        connectOrNot.text = connectionStatus    //gets status from prev
        
        //on this screen, toggle countdown
        isTimerOn.toggle()
        
        CountdownTimer.addTarget(self, action: #selector(PopUpView.countdownChanged(CountdownTimer:)), for: UIControl.Event.valueChanged)
        
        popupArea.layer.masksToBounds = true
        
        // TCP STUFF !!!
        client = TCPClient(address: host, port: Int32(port))
    }
        
    
    func getZoneForZoneTimes(string: String) -> String {
        var zoneFinal = ""
        if let index = string.firstIndex(of: " ") {
            let zoneNumbTemp = string[index...]
            zoneFinal = String(zoneNumbTemp)
        }
        return zoneFinal
    }
    
    @objc func countdownChanged(CountdownTimer:UIDatePicker) {
        let countdownFormat = NumberFormatter()
        countdownFormat.numberStyle = NumberFormatter.Style.none
    }
    
    @IBAction func turnOff(_ sender: Any) {
        timerValue = 0.0
        //print(timerValue)
        //print(zoneName)
        let zone_n = caseZone()
        if (connectionStatus == "Connected") {
            print("It's MQTT")
        }
        else {
            TCPconnection(zone_number: zone_n)
        }
        currentOnOff = "Current Status: Off"
        
        zoneNumb = getZoneForZoneTimes(string: zoneName)
        zoneNumb.removeFirst()
        zoneInt = Int(zoneNumb) ?? -1

        //put timervalue into array of zonetimes
        zonetimes[zoneInt-1] = timerValue
        //print(zonetimes)
        //print("")
        
        //send data back
        delegate?.currentStatusUpdate(type: currentOnOff, num: zoneInt)
        delegate?.zoneTimerUpdate(list: zonetimes)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmPopUp(_ sender: Any) {
        timerValue = CountdownTimer.countDownDuration
        //print(timerValue)
        //print(zoneName)     //zone number
        let zone_n = caseZone()
        if (connectionStatus == "Connected") {
            print("It's MQTT")
        }
        else {
            TCPconnection(zone_number: zone_n)
        }
        currentOnOff = "Current Status: On" //status
        
        zoneNumb = getZoneForZoneTimes(string: zoneName)
        zoneNumb.removeFirst()
        zoneInt = Int(zoneNumb) ?? -1

        //put timervalue into array of zonetimes
        zonetimes[zoneInt-1] = timerValue   //timervalue stored
        //print(zonetimes)
        //print("")
        
        //send data back
        delegate?.currentStatusUpdate(type: currentOnOff, num: zoneInt)
        delegate?.zoneTimerUpdate(list: zonetimes)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func TCPconnection(zone_number: Int) {
        guard let client = client else { return }
        //duration clicked
        let ywz = "YW_"+YardWorkZone(zone_num: zone_number, duration: Int(timerValue)).convertToJSONString()
        print(ywz)
        switch client.connect(timeout: 5) {
        case .success:
            print("Connected to host \(client.address)")
        case .failure(let error):
            print(String(describing: error))
            return
        }
        if let response = sendRequest(string: ywz, using: client) {
            print( "Response: \(response)")
        }
    }
    
    private func caseZone() -> Int {
        let zone = String(ZoneInput.title!)
        switch (zone) {
        case "Zone 1":
            return 1
        case "Zone 2":
            return 2
        case "Zone 3":
            return 3
        case "Zone 4":
            return 4
        case "Zone 5":
            return 5
        case "Zone 6":
            return 6
        case "Zone 7":
            return 7
        case "Zone 8":
            return 8
        case "Zone 9":
            return 9
        case "Zone 10":
            return 10
        case "Zone 11":
            return 11
        case "Zone 12":
            return 12
        default:
            return 0
        }
    }
    
    private func readResponse(from client: TCPClient, string: String) -> String? {
        var data = [UInt8]()
        var counter = 0, total = 0
        let len = 1420  // one-time read limit: 1420 bytes
        if ((string.count) % len > 0) {
            total = 1
        }
        total += ((string.count) / len)
        while counter < total {
            guard let response = client.read(len, timeout: 5) else {
                print("readResponse is nil")
                return nil
            }
            counter += 1
            data += response
        }
        return String(bytes: data, encoding: .utf8)
    }
    
    private func sendRequest(string: String, using client: TCPClient) -> String? {
      print("Sending data ... ")
      
      switch client.send(string: string) {
      case .success:
        print("succeed.")
        //return readResponse(from: client, string: string)
        return "good enough."
      case .failure(let error):
        print("failed.")
        print(String(describing: error))
        return nil
      }
    }
}
