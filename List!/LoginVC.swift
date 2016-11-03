//
//  LoginVC.swift
//  List!
//
//  Created by Allan Wallace on 19/10/2016.
//  Copyright © 2016 Allan Wallace. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class LoginVC: UIViewController {
    
    @IBOutlet weak var usernameField: TextField!
    @IBOutlet weak var passwordField: TextField!
    @IBOutlet weak var groupField: TextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRDatabase.database().persistenceEnabled = true

           }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID){
            performSegue(withIdentifier: "login", sender: nil)
        }
        
    }
    

    @IBAction func loginBtnPressed(_ sender: AnyObject) {
        
        let groupName = UserDefaults.standard
        
        if let GID =  groupField.text {
            if GID != "" {
            groupName.set(GID, forKey: "GroupName")
            
            
        } else {
                groupName.set("Generic", forKey: "GroupName")
        }
        }
        
     //   DataService.ds.REF_BASE.updateChildValues(["Group": groupName.string(forKey: "GroupName") as NSString!])
        
        
        
        
        if let email = usernameField.text, let pwd = passwordField.text, let group = groupField.text{
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    
                    if let user = user {
                        let userData = ["UserName ": user.email, "Group": group]
                        self.completeSignin(id: user.uid, userData: userData as! Dictionary<String, String>)
                        
                        let userID = UserDefaults.standard
                        userID.set(user.uid, forKey: "User")
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                        
                        } else {
                            
                            if let user = user {
                                let userData = ["UserName": user.email, "Group": group]
                                self.completeSignin(id: user.uid, userData: userData as! Dictionary<String, String>)
                                
                                let userID = UserDefaults.standard
                                userID.set(user.uid, forKey: "User")                            }
                        }
                    })
                }
            })
        }
    }
    
    
        func completeSignin(id: String, userData: Dictionary<String, String>) {
        
        DataService.ds.createFirbaseDBUser(uid: id, userData: userData)
                
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("this fing thing aint working ..........................\(id)")
        print("data saved to keychain \(keychainResult)")
        
        performSegue(withIdentifier: "login", sender: nil)
            
    }
    
    
}
