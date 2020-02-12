//
//  PopUpView.swift
//  YardWorkMode_3
//
//  Created by Nicholas Balestrino on 2/12/20.
//  Copyright © 2020 Misc. All rights reserved.
//

import UIKit

class PopUpView: UIViewController {
    
    
    @IBOutlet weak var ZoneInput: UILabel!
    @IBOutlet weak var Confirm: UIButton!
    @IBOutlet weak var Cancel: UIButton!
    @IBOutlet weak var CountdownTimer: UIDatePicker!
    
    override func viewDidLoad() {
           super.viewDidLoad()

           self.view.backgroundColor = UIColor.black

           self.showAnimate()
    }
    
    @IBAction func CancelOp(_ sender: UIButton) {
        self.removeAnimate()
    }
    
    @IBAction func ConfirmOp(_ sender: UIButton) {
        self.removeAnimate()
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished : Bool) in
            if (finished) {
                self.view.removeFromSuperview()
            }
        })
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
