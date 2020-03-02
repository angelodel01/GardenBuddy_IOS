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
    
    var connectedColor = UIColor(red: 0, green: 0.749, blue: 0, alpha: 1.0)
    var unconnectedColor = UIColor(red: 0.65, green: 0, blue: 0, alpha: 1.0)
    var usedColor = UIColor(red: 0, green: 0.749, blue: 0, alpha: 1.0)
    
    override func viewDidLoad() {
        self.collectionView.backgroundColor = connectedColor

        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
       }
    
    //changing connected or not
    @IBAction func connectTapped(_ sender: Any) {
        let index = connectOrNot.selectedSegmentIndex
        switch (index) {
        case 0:
            usedColor = connectedColor
            self.collectionView.backgroundColor = connectedColor
            //extra code possibly for more functionality
            zones.zoneToggleButton.setTitleColor(connectedColor, for: .normal)
            self.collectionView.reloadData()
        case 1:
            usedColor = unconnectedColor
            self.collectionView.backgroundColor = unconnectedColor
            //extra code possibly for more functionality
            zones.zoneToggleButton.setTitleColor(unconnectedColor, for: .normal)
            self.collectionView.reloadData()
        default:
            usedColor = connectedColor
            zones.zoneToggleButton.setTitleColor(connectedColor, for: .normal)
        }
    }
    
    //struct of a cell in collection view
    struct ZoneData {
        var currentStatus: String
        var zoneTitle: [String] = []
        var zoneToggleButton: UIButton
        var zoneToggleText: String
    }
    
    var zones = ZoneData(currentStatus: "Current Status: Off", zoneTitle: [("Zone 1"), ("Zone 2"), ("Zone 3"), ("Zone 4"), ("Zone 5"), ("Zone 6"), ("Zone 7"), ("Zone 8"), ("Zone 9"), ("Zone 10"), ("Zone 11"), ("Zone 12")], zoneToggleButton: UIButton(), zoneToggleText: "Toggle On / Off")
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return zones.zoneTitle.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ZoneCollectionView else {
            fatalError("Unable to dequeue Cell.")
        }
        let cellIndex = indexPath.item
               
        //uidesigning
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.25
        cell.ZoneToggle.setTitleColor(usedColor, for: .normal)
        
        //cell info
        cell.ZoneTitle.text = zones.zoneTitle[cellIndex]
        cell.ZoneStatus.text = zones.currentStatus
        cell.ZoneToggle.setTitle(zones.zoneToggleText, for: .normal)
                
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let selectedIndexPath = zones.zoneTitle[indexPath.item]
        performSegue(withIdentifier: "popUpSegue", sender: selectedIndexPath)
    }
    
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
