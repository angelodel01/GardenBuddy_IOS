//
//  PopUpView.swift
//  YardWorkMode_3
//
//  Created by Nicholas Balestrino on 2/12/20.
//  Copyright © 2020 Misc. All rights reserved.
//

import UIKit


protocol PopUpViewDelegate: NSObjectProtocol {
    func zoneTimerUpdate(list: [Double])
    func currentStatusUpdate(type: String, num: Int)
}

class PopUpView: UIViewController {
    
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
        if (connectionStatus == "Connected") {
            //print("mqtt")
        }
        else {
            //print("tcp")
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
        if (connectionStatus == "Connected") {
            //print("mqtt")
        }
        else {
            //print("tcp")
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
}
