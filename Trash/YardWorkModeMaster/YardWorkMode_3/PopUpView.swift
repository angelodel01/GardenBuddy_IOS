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
    
    @IBOutlet weak var ZoneInput: UILabel?
    
    @IBOutlet weak var CountdownTimer: UIDatePicker!
    var timerValue: Double = 0
    var prevValue: Double = 0
    
    struct ZoneData {
        var currentStatus: String
        var zoneTitle: [String] = []
        var zoneToggleButton: UIButton
        var zoneToggleText: String
    }
    //var zoneData:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ZoneInput?.text = zoneData?.zoneTitle
        
        CountdownTimer.addTarget(self, action: #selector(PopUpView.countdownChanged(CountdownTimer:)), for: UIControl.Event.valueChanged)
    
        self.navigationItem.hidesBackButton = true
        popupArea.layer.cornerRadius = 15
        popupArea.layer.masksToBounds = true
    }
    
    @objc func countdownChanged(CountdownTimer:UIDatePicker) {
        let countdownFormat = NumberFormatter()
        countdownFormat.numberStyle = NumberFormatter.Style.none
        //let strCount = countdownFormat.string(from: NSNumber(value: CountdownTimer.countDownDuration))
        //ZoneInput?.text = strCount
    }
    
    //need to change status when confirm
    @IBAction func cancelPopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //
    @IBAction func confirmPopUp(_ sender: Any) {
        //duration clicked
        timerValue = CountdownTimer.countDownDuration
        print(timerValue)
        //get zone title
        //change status to "Current Status: On"
        dismiss(animated: true, completion: nil)
    }
    
    //cancel and confirm functions
    //@IBAction func CancelOp(_ sender: UIButton) {
        //self.removeAnimate()
    //}
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let destVC = segue.destination as! ViewController

        //if segue.identifier == "unwindToMainConfirm" {
          //  print("confirmed")
            //destVC.currentstatus = "Current Status: On"
        //}
        //else if segue.identifier == "unwindToMainCancel" {
            //print("cancelled")
            //destVC.currentstatus = "Current Status: Off"
        //}
        //else {
          //  print("errorrrrr")
       // }
    //}
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
