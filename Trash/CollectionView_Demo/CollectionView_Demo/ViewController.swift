//
//  ViewController.swift
//  CollectionView_Demo
//
//  Created by Nicholas Balestrino on 2/5/20.
//  Copyright © 2020 Misc. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {

    let zone_titles = [("Zone 1"), ("Zone 2"), ("Zone 3"), ("Zone 4"), ("Zone 5"), ("Zone 6"), ("Zone 7"), ("Zone 8"), ("Zone 9"), ("Zone 10"), ("Zone 11"), ("Zone 12")]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return zone_titles.count
        return 12
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ZoneCell else {
            fatalError("Unable to dequeue Cell.")
        }
        
        let cellIndex = indexPath.item
                
        cell.ZoneLabel.text = zone_titles[cellIndex]
        cell.ZoneStatus.text = "Current Status: Off"
        cell.ZoneToggle.setTitle("Toggle ON / OFF", for: .normal)
        
        return cell
    }
    
    @IBAction func showPopUp(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "YardWorkArea", bundle: nil).instantiateViewController(identifier: "ButtonPopUp") as! PopUpViewController
        
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
}

