//
//  PopUpView.swift
//  YardWorkMode_3
//
//  Created by Nicholas Balestrino on 2/12/20.
//  Copyright © 2020 Misc. All rights reserved.
//

import UIKit

class PopUpView: UIViewController {
    
    @IBOutlet weak var popupArea: UIView!
    
    @IBOutlet weak var connectOrNot: UILabel! //mqtt or tcp
    
    @IBOutlet weak var ZoneInput: UINavigationItem! //zone #
    
    @IBOutlet weak var CountdownTimer: UIDatePicker!
    var timerValue: Double = 0
    var prevValue: Double = 0
    
    var zoneToggleText: String = ""
    var connectionStatus: String = ""
    
    var zoneName = "Idk zone"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ZoneInput.title! = zoneName
        connectOrNot.text = connectionStatus
        
        CountdownTimer.addTarget(self, action: #selector(PopUpView.countdownChanged(CountdownTimer:)), for: UIControl.Event.valueChanged)
    
        //self.navigationItem.hidesBackButton = true
        popupArea.layer.cornerRadius = 15
        //popupArea.layer.masksToBounds = true
    }
    
    @objc func countdownChanged(CountdownTimer:UIDatePicker) {
        let countdownFormat = NumberFormatter()
        countdownFormat.numberStyle = NumberFormatter.Style.none
        //let strCount = countdownFormat.string(from: NSNumber(value: CountdownTimer.countDownDuration))
        //ZoneInput?.text = strCount
    }
    @IBAction func turnOff(_ sender: Any) {
        timerValue = 0.0
        print(timerValue)
        //current status: off
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmPopUp(_ sender: Any) {
        //duration clicked
        timerValue = CountdownTimer.countDownDuration
        print(timerValue)
        if (connectionStatus == "Connected") {
            print("yay")
        }
        //get zone title
        //change status to "Current Status: On"
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
