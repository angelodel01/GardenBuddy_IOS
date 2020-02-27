//
//  ViewController.swift
//  YardWorkMode_3
//
//  Created by Nicholas Balestrino on 2/10/20.
//  Copyright © 2020 Misc. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var currentstatus = "Current Status: Off"

    @IBOutlet weak var connectionSwitch: UISwitch!
    
    let zone_titles = [("Zone 1"), ("Zone 2"), ("Zone 3"), ("Zone 4"), ("Zone 5"), ("Zone 6"), ("Zone 7"), ("Zone 8"), ("Zone 9"), ("Zone 10"), ("Zone 11"), ("Zone 12")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
            
        //navigation bar
        connectionSwitch.setOn(true, animated: true)
        self.navigationItem.title = "Connected"
        setNavButton()
        //end of nav bar
    }
    
    //collection button function
    @IBAction func goToPop(_ sender: Any) {
        print("moving")
        self.performSegue(withIdentifier: "PopUpSegue", sender: self)
    }
    
    @IBAction func unwindToMainCancel(_ sender: UIStoryboardSegue) {
        print("maincancel")
        print(currentstatus)
    }
    
    @IBAction func unwindtoMainConfirm(_ sender: UIStoryboardSegue) {
        print("mainconfirm")
        print(currentstatus)
    }
    
    //navigation bar (top) setup
    func setNavButton() {
        let temp = connectionSwitch
        temp!.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: temp!)

        self.connectionSwitch = temp
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch){
        if sender.isOn {
            self.navigationItem.title = "Connected"
        } else {
            self.navigationItem.title = "Not Connected"
        }
        self.collectionView?.reloadData()
    }
    //end of navigation bar setup

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return zone_titles.count
        return 12
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ZoneCollectionView else {
            fatalError("Unable to dequeue Cell.")
        }
        let cellIndex = indexPath.item
                
        cell.ZoneTitle.text = zone_titles[cellIndex]
        cell.ZoneStatus.text = currentstatus
        cell.ZoneToggle.setTitle("Toggle ON/OFF", for: .normal)
        
        return cell
    }
}
