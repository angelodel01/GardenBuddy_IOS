//
//  ViewController.swift
//  YardWorkMode_3
//
//  Created by Nicholas Balestrino on 2/10/20.
//  Copyright © 2020 Misc. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, PopUpViewDelegate {
    
    @IBOutlet weak var connectOrNot: UISegmentedControl!
    
    @IBOutlet var collectView: UICollectionView!
    
    var connectedColor = UIColor(red: 0, green: 0.749, blue: 0, alpha: 1.0)
    var unconnectedColor = UIColor(red: 0.65, green: 0, blue: 0, alpha: 1.0)
    var usedColor = UIColor(red: 0, green: 0.749, blue: 0, alpha: 1.0)
    
    //data transfer variables
    var zonetimes: [Double] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] //list of zone times
    var dataType: String = "Connected"
    
    //increment timerValue down
    //var timerLatestProduct = [Int:Timer]()
    //var timerCount:NSMutableArray = [0,0,0,0,0,0,0,0,0,0,0,0]
    //var timer = [Timer()]
    
    //struct of a cell in collection view
    struct ZoneData {
        var currentStatus: [String] = []
        var zoneTitle: [String] = []
        var zoneToggleText: String
    }
    
    var zones = ZoneData(currentStatus: [("Current Status: Off"), ("Current Status: Off"), ("Current Status: Off"), ("Current Status: Off"), ("Current Status: Off"), ("Current Status: Off"), ("Current Status: Off"), ("Current Status: Off"), ("Current Status: Off"), ("Current Status: Off"), ("Current Status: Off"), ("Current Status: Off")], zoneTitle: [("Zone 1"), ("Zone 2"), ("Zone 3"), ("Zone 4"), ("Zone 5"), ("Zone 6"), ("Zone 7"), ("Zone 8"), ("Zone 9"), ("Zone 10"), ("Zone 11"), ("Zone 12")], zoneToggleText: "Toggle On / Off")
    
    
    override func viewDidLoad() {
        collectView.backgroundColor = connectedColor

        super.viewDidLoad()
        //dynamoGet() for angelo when merging
    }
    
    //changing connected or not
    @IBAction func connectTapped(_ sender: Any) {
        let index = connectOrNot.selectedSegmentIndex
        switch (index) {
        case 0:
            dataType = "Connected"
            usedColor = connectedColor
            collectView.backgroundColor = connectedColor
            //extra code possibly for more functionality
            collectView.reloadData()
        case 1:
            dataType = "Not Connected"
            usedColor = unconnectedColor
            collectView.backgroundColor = unconnectedColor
            //extra code possibly for more functionality
            collectView.reloadData()
        default:
            usedColor = connectedColor
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return zones.zoneTitle.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ZoneCollectionView = collectView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ZoneCollectionView
        
        //uidesigning
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.25
        cell.ZoneToggle.textColor = usedColor
                
        //cell info
        cell.ZoneTitle.text = zones.zoneTitle[indexPath.item]
        cell.ZoneToggle.text = zones.zoneToggleText
        cell.ZoneStatus.text = zones.currentStatus[indexPath.item]
        
        if cell.ZoneStatus.text == "Current Status: On" {
            cell.ZoneStatus.font = UIFont(name: "Helvetica Neue Condensed Black", size: 16)
            cell.ZoneStatus.textColor = usedColor
            cell.ZoneTitle.textColor = usedColor
        }
        if cell.ZoneStatus.text == "Current Status: Off" {
            cell.ZoneStatus.font = UIFont(name: "Helvetica Neue", size: 15)
            cell.ZoneStatus.textColor = UIColor.black
            cell.ZoneTitle.textColor = UIColor.black
        }
        
        return cell
    }
    
    
    //func timeCountdown(on: Bool) {
       //var i: Int = 0
       //timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
           //parse through zonetimes list
         //  let list = self.zonetimes
           //for i in list {
             //  if (self.zonetimes[Int(i)] == 0) {
               //     self.currentStatusUpdate(type: "Current Status: Off", num: Int(i))
                 //   continue
               //}
               //then the timer is running
               //else {
                   //continue
               //}
           //}
       //})
    //}
    
    
    //passing data between section with segue / delegate
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let childVC = segue.destination as! PopUpView
        childVC.delegate = self
        
        if let indexPath = self.collectionView.indexPath(for: sender as! ZoneCollectionView) {
            childVC.zoneName = zones.zoneTitle[indexPath.item] //cell zone #
            childVC.connectionStatus = dataType        //Connected/NotConnected
            childVC.currentOnOff = zones.currentStatus[indexPath.item] //current on/off status
            childVC.zonetimes = zonetimes      //pass back and forth zonetimes with timevalues stored
        }
    }
    
    func currentStatusUpdate(type: String, num: Int) {
        let x = num - 1 //get index value of currentstatus list
        zones.currentStatus[x] = type
        self.collectionView.reloadData()
        print(zones.currentStatus)
    }
    
    func zoneTimerUpdate(list: [Double]) {
        zonetimes = list
        print(zonetimes)
    }
    
    //works to send data
    //override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let dest: PopUpView = self.storyboard?.instantiateViewController(withIdentifier: "PopUpView") as! PopUpView
        //dest.zoneName = zones.zoneTitle[indexPath.item] //cell zone #
        //dest.connectionStatus = dataType        //Connected/NotConnected
        //dest.currentOnOff = zones.currentStatus[indexPath.item] //current on/off status
        //dest.zonetimes = zonetimes      //pass back and forth zonetimes with timevalues stored
        //self.navigationController?.pushViewController(dest, animated: true)
    //}
}
