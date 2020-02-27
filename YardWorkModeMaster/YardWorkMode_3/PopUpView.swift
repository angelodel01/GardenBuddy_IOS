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
    
    @IBOutlet weak var ZoneInput: UILabel!
    @IBOutlet weak var CountdownTimer: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        popupArea.layer.cornerRadius = 15
        popupArea.layer.masksToBounds = true
    }
    
    
    
    @IBAction func cancelPopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmPopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //cancel and confirm functions
    //@IBAction func CancelOp(_ sender: UIButton) {
        //self.removeAnimate()
    //}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ViewController

        if segue.identifier == "unwindToMainConfirm" {
            print("confirmed")
            destVC.currentstatus = "Current Status: On"
        }
        else if segue.identifier == "unwindToMainCancel" {
            print("cancelled")
            destVC.currentstatus = "Current Status: Off"
        }
        else {
            print("errorrrrr")
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
