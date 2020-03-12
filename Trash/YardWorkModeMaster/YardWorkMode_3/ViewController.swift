//
//  ViewController.swift
//  YardWorkMode_3
//
//  Created by Nicholas Balestrino on 2/10/20.
//  Copyright © 2020 Misc. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var connectOrNot: UISegmentedControl!
    var dataType: String = "Connected"
    
    @IBOutlet var collectView: UICollectionView!
    
    var connectedColor = UIColor(red: 0, green: 0.749, blue: 0, alpha: 1.0)
    var unconnectedColor = UIColor(red: 0.65, green: 0, blue: 0, alpha: 1.0)
    var usedColor = UIColor(red: 0, green: 0.749, blue: 0, alpha: 1.0)
    
    override func viewDidLoad() {
        collectView.backgroundColor = connectedColor

        super.viewDidLoad()
        //self.navigationItem.hidesBackButton = true
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
    
    //struct of a cell in collection view
    struct ZoneData {
        var currentStatus: String
        var zoneTitle: [String] = []
        var zoneToggleText: String
    }
    
    var zones = ZoneData(currentStatus: "Current Status: Off", zoneTitle: [("Zone 1"), ("Zone 2"), ("Zone 3"), ("Zone 4"), ("Zone 5"), ("Zone 6"), ("Zone 7"), ("Zone 8"), ("Zone 9"), ("Zone 10"), ("Zone 11"), ("Zone 12")], zoneToggleText: "Toggle On / Off")
    

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
        cell.ZoneTitle.text = zones.zoneTitle[indexPath.row]
        cell.ZoneStatus.text = zones.currentStatus
        cell.ZoneToggle.text = zones.zoneToggleText
                
        return cell
    }
    
    
    //works
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dest: PopUpView = self.storyboard?.instantiateViewController(withIdentifier: "PopUpView") as! PopUpView
        dest.zoneName = zones.zoneTitle[indexPath.row]
        dest.connectionStatus = dataType
        self.navigationController?.pushViewController(dest, animated: true)
    }
    
    //connected mqtt - disconnect tcp
    //connection needs to send with case funct
    
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      //  if segue.destination is PopUpView {
        //    let vc = segue.destination as? PopUpView
           // cellIndex = indexPath.item
           // vc?.zoneName = zones.zoneTitle[cellIndex]
        
            //if let cell = sender as? UICollectionViewCell,
                //let indexPath = collectionView.indexPath(for: cell) {
                //let cellIndex = indexPath.item
                
                //let destination = segue.destination as! PopUpView
                //destination.zoneName = zones.zoneTitle[cellIndex]
            //}
       // }
    //}
    
   // override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     //   if segue.identifier == "popUpSegue" {
       //     print("0")
         //   var destination = segue.destination as! PopUpView

           // if let index = collectionView.indexPathsForSelectedItems {
             //   destination.ZoneData
                //let selectedItem = self.zones[itemIndex]
                // do here what you need
           // }
        //}
    //}
    
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       // guard let destination = segue.destination as? PopUpView,
            //let index = collectionView.indexPathsForSelectedItems
           // else {
             //   return
        //}
        //destination.zoneData = zones[index]
        //if let destination = segue.destination as? PopUpView {
            //if let collectionView = self.collectionView,
            //let indexPath = collectionView.indexPathsForSelectedItems?.first,
            //let cell = collectionView.cellForItem(at: indexPath) as? ZoneCollectionView ,
            //let zoneTop = cell.ZoneTitle
            //let index = collectionView.cellForItem(at: IndexPath)
            //destination.zoneTop = cell.zoneTitle
       // }
    //}
}
