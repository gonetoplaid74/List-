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
    @IBOutlet weak var loginInfo: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginInfo.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let groupName = UserDefaults.standard
        if groupName.string(forKey: "GroupName") != "" {
            groupField.text = groupName.string(forKey: "GroupName")
        } else {
            groupField.text = ""
        }
       
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
                    
                    self.loginInfo.text = error?.localizedDescription
                    self.loginInfo.isHidden = false
                                        FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                       self.loginInfo.text = error?.localizedDescription
                            self.loginInfo.isHidden = false
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
        passwordField.resignFirstResponder()
        groupField.resignFirstResponder()
    }
    
    
        func completeSignin(id: String, userData: Dictionary<String, String>) {
        
        DataService.ds.createFirbaseDBUser(uid: id, userData: userData)
                
        _ = KeychainWrapper.standard.set(id, forKey: KEY_UID)
            
        performSegue(withIdentifier: "login", sender: nil)
            
    }
    func keyboardWillShow(notification: NSNotification) {
        
        
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= 100
        }
        
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += 100
        }
    }

    
}
