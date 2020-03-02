//
//  PopUpView.swift
//  YardWorkMode_3
//
//  Created by Nicholas Balestrino on 2/12/20.
//  Copyright © 2020 Misc. All rights reserved.
//

import UIKit
import SwiftSocket

class PopUpView: UIViewController {
      
    let host = "192.168.43.78"    // 192.168.43.78 192.168.43.121
    let port = 7                  // 7
    var client: TCPClient?
    
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
        
        // TCPClient
        client = TCPClient(address: host, port: Int32(port))
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
    @IBAction func confirmPopUp(sender: UIButton) {
        guard let client = client else { return }
        //duration clicked
        timerValue = CountdownTimer.countDownDuration
        let ywz = YardWorkZone(zone_num: 1, duration: Int(timerValue)).convertToJSONString()
        print(ywz)
        switch client.connect(timeout: 10) {
        case .success:
            print("Connected to host \(client.address)")
            if let response = sendRequest(string: ywz, using: client) {   // "YW_"+ywz
                print( "Response: \(response)")
            }
        case .failure(let error):
            print(String(describing: error))
        }
        //get zone title
        //change status to "Current Status: On"
        dismiss(animated: true, completion: nil)
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
            guard let response = client.read(len, timeout: 10) else { print("readResponse is nil")
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
        return readResponse(from: client, string: string)
      case .failure(let error):
        print("failed.")
        print(String(describing: error))
        return nil
      }
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
