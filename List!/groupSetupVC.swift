//
//  groupSetupVC.swift
//  List!
//
//  Created by AW on 09/12/2016.
//  Copyright © 2016 Allan Wallace. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class groupSetupVC: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoLabel2: UILabel!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var buttonLabel: MaterialButton!
    @IBOutlet weak var groupPasscodeField: TextField!
    @IBOutlet weak var groupNameField: TextField!
    var passcode = String()
    var groupsCheck = String()
    var emailString = String()
    var passwordString = String()
    
    
    override func viewDidLoad() {
        
        let device = UIDevice()
        
        if device.model != "iPad" {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard))
        
        
        
        view.addGestureRecognizer(tap)

        }
        let user = UserDefaults.standard
       emailString = user.string(forKey: "UserName")!
        
        let passwrd = UserDefaults.standard
       passwordString = passwrd.string(forKey: "password")!
        
        let group = UserDefaults.standard
        
        if group.string(forKey: "GroupName") != "" {
        groupNameField.text = group.string(forKey: "GroupName")
        } else {
            groupNameField.text = ""
        }
        
        if let groupID = groupNameField.text {
        
        let status = UserDefaults.standard
        if status.string(forKey: "Status") != "" {
            if status.string(forKey: "Status") == "New" {
                infoLabel.text = "This is a new group.  Please enter a new Group Passcode"
                infoLabel2.text = "Share this passcode with anyone you want to join the group"
                
            } else if status.string(forKey: "Status") == "Existing" {
                infoLabel.text = "You are joining group \(groupID)."
                infoLabel2.text = "Please enter Passcode received from group owner"
            
            }
        } else {
            infoLabel.text = "Error, pleae return to login screen"
        }
        }
       
        
        super.viewDidLoad()

    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


    @IBAction func btnPressed(_ sender: Any) {
        
        passcode = groupPasscodeField.text!
        
        let pscode = UserDefaults.standard
        pscode.set(passcode, forKey: "Passcode")
        
        let group = UserDefaults.standard
        let ref = group.string(forKey: "GroupName")
        
        
        
        
        FIRDatabase.database().reference().child(ref!).observe(.value, with: {snapshot in
            
           
            
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.groupsCheck = ""
                for snap in snapshot {
                    
                    if let groupDict = snap.value as? String {
                        
                        
                        self.groupsCheck = groupDict
                        
                        
                    }
                }
            }
            
            
            
        })
        
        let status = UserDefaults.standard
        
         if status.string(forKey: "Status") == "Existing"{
        
        if groupsCheck == groupPasscodeField.text {
           
            
            let email = emailString
            let pwd = passwordString
            
            if let group = groupNameField.text,
                let passcode = groupPasscodeField.text {
                
    
                FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                    if error == nil {
                       
                        if let user = user {
                            let userData = ["UserName": user.email, "Group": group]
                            let passcodeData = ["Passcode": passcode]
                            self.completeSignup(id: user.uid, userData: userData as! Dictionary<String, String>)
                            FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).updateChildValues(passcodeData)
                            
                           
                            let userID = UserDefaults.standard
                            userID.set(user.uid, forKey: "User")
                        } else {
                            
                            
                            self.infoLabel.text = error?.localizedDescription
                            self.infoLabel.isHidden = false
                            
                            
                        }
                    }
                })
            }

            
            
            
        } else {
            
            errorLbl.isHidden = false
            errorLbl.text = " Passcode entered is incorrect, please try again"
        }

        } else  if status.string(forKey: "Status") == "New"{
        
        
        
       
        
       
        
        let email = emailString
            let pwd = passwordString
            
          if let group = groupNameField.text,
            let passcode = groupPasscodeField.text {
   
            FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                   
                    if let user = user {
                        let userData = ["UserName": user.email, "Group": group]
                        let passcodeData = ["Passcode": passcode]
                        self.completeSignup(id: user.uid, userData: userData as! Dictionary<String, String>)
                        FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).updateChildValues(passcodeData)
                        
                        
                        let userID = UserDefaults.standard
                        userID.set(user.uid, forKey: "User")
                                    } else {
                    
                        
                        self.infoLabel.text = error?.localizedDescription
                        self.infoLabel.isHidden = false


                    }
                }
            })
            }
        }
        
        
        
        }
    
func completeSignup(id: String, userData: Dictionary<String, String>) {
    
    FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Users").child(id).updateChildValues(userData)
    
    //DataService.ds.createFirbaseDBUser(uid: id, userData: userData)
    
    _ = KeychainWrapper.standard.set(id, forKey: KEY_UID)
    
    performSegue(withIdentifier: "login2", sender: nil)
    
}
    
    func keyboardWillShow(notification: NSNotification) {
        
        
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= 150
        }
        
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += 150
        }
    }


}
