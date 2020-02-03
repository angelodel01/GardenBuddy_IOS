//
//  ViewController.swift
//  Nick_Frontend_YardWorkZone
//
//  Created by Nicholas Balestrino on 1/27/20.
//  Copyright © 2020 Misc. All rights reserved.
//

import UIKit
import AWSCognitoAuth

class ViewController: UIViewController, UICollectionViewDelegate,
UICollectionViewDataSource {
    
    //zones for each box
    @IBOutlet weak var collectionview: UICollectionView!
    var collectionarr: [String] = ["1", "2", "3", "4"]
    let zone_titles = [("Zone 1"), ("Zone 2"), ("Zone 3"), ("Zone 4"), ("Zone 5"), ("Zone 6"), ("Zone 7"), ("Zone 8"), ("Zone 9"), ("Zone 10"), ("Zone 11"), ("Zone 12")]
    let zone_status = [("Current Status: Off"), ("Current Status: On")]
    let zone_button = [("Toggle ON / OFF")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionview.delegate = self
        collectionview.dataSource = self
        
        //sign in functionality
        self.auth.delegate = self;
        if(self.auth.authConfiguration.appClientId.contains("SETME")){
            self.alertWithTitle("Error", message: "Info.plist missing necessary config under AWS->CognitoUserPool->Default")
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return zone_titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let cellIndex = indexPath.item
        
        cell.ZoneNumber.text = zone_titles[cellIndex]
        cell.ZoneStatus.text = zone_status[cellIndex]
        
        return cell
    }
    
    //sign in functionality section
    
    @IBOutlet weak var signInButton: UIBarButtonItem!
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    var auth: AWSCognitoAuth = AWSCognitoAuth.default()
    var session: AWSCognitoAuthUserSession?
    var firstLoad: Bool = true

    func refresh () {
        DispatchQueue.main.async {
            self.signInButton.isEnabled = self.session == nil
            self.signOutButton.isEnabled = self.session != nil
            self.tableView.reloadData()
            self.title = self.session?.username;
        }
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        self.auth.getSession  { (session:AWSCognitoAuthUserSession?, error:Error?) in
            if(error != nil) {
                self.session = nil
                self.alertWithTitle("Error", message: (error! as NSError).userInfo["error"] as? String)
            }else {
                self.session = session
                
                //find way to get switch to toggle here
                
            }
            self.refresh()
        }
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        self.auth.signOut { (error:Error?) in
            if(error != nil){
                self.alertWithTitle("Error", message: (error! as NSError).userInfo["error"] as? String)
            }else {
                self.session = nil
                self.alertWithTitle("Info", message: "Session completed successfully")
            }
            self.refresh()
        }
    }
    
    func alertWithTitle(_ title:String, message:String?) -> Void {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (UIAlertAction) in
                alert.dismiss(animated: false, completion: nil)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //not sure if these funcs are needed but from sign in code

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(self.firstLoad){
            self.signInTapped(signInButton as Any)
        }
        self.firstLoad = false
    }
    
    func getViewController() -> UIViewController {
        return self;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let token = getBestToken()
        if((token) != nil){
            return token!.claims.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let token = getBestToken()
        let key = Array(token!.claims.keys)[indexPath.row]
        cell.textLabel?.text = key as? String
        cell.detailTextLabel?.text = (token!.claims[key] as AnyObject).description
        return cell
    }
    
    func getBestToken() -> AWSCognitoAuthUserSessionToken? {
        if(self.session != nil){
            if((self.session?.idToken) != nil){
                return self.session?.idToken!
            }else if((self.session?.accessToken) != nil){
                return self.session?.accessToken!
            }
        }
        return nil;
    }
}

