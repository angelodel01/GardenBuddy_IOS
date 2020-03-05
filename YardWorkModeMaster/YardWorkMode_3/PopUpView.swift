//
//  PopUpView.swift
//  YardWorkMode_3
//
//  Created by Nicholas Balestrino on 2/12/20.
//  Copyright © 2020 Misc. All rights reserved.
//

import UIKit
import SwiftSocket
import AWSIoT

class PopUpView: UIViewController {
    
    let host = "192.168.43.78"    // 192.168.43.78 192.168.43.121
    let port = 7                  // 7
    var client: TCPClient?
    
//    let iotDataManager = AWSIoTDataManager(forKey: ASWIoTDataManager)
//    let tabBarViewController = tabBarController as! IoTSampleTabBarController
    
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
        
        // TCPClient
        client = TCPClient(address: host, port: Int32(port))
    }
    
    @objc func countdownChanged(CountdownTimer:UIDatePicker) {
        let countdownFormat = NumberFormatter()
        countdownFormat.numberStyle = NumberFormatter.Style.none
        //let strCount = countdownFormat.string(from: NSNumber(value: CountdownTimer.countDownDuration))
        //ZoneInput?.text = strCount
    }
    @IBAction func turnOff(_ sender: Any) {
        timerValue = 0.0
        let zone_n = caseZone()
        
        if (connectionStatus == "Connected") {  // MQTT
            print("It's MQTT")
        }
        else {                                  // TCP
            TCPconnection(zone_number: zone_n)
        }
        //current status: off
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmPopUp(_ sender: Any) {
        //duration clicked
        timerValue = CountdownTimer.countDownDuration
        let zone_n = caseZone()
        
        if (connectionStatus == "Connected") {  // MQTT
            print("It's MQTT")
        }
        else {                                  // TCP
            TCPconnection(zone_number: zone_n)
        }
        //get zone title
        //change status to "Current Status: On"
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
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
//                let alert = UIAlertController(title: "Alert", message: "readResponse is nil", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
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
        return readResponse(from: client, string: string)
      case .failure(let error):
        print("failed.")
        print(String(describing: error))
        return nil
      }
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
