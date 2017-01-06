//
//  PrivateEditVC.swift
//  List!
//
//  Created by AW on 07/11/2016.
//  Copyright © 2016 Allan Wallace. All rights reserved.
//

import UIKit
import Firebase

class PrivateEditVC: UIViewController {

    @IBOutlet weak var privateEditTextField: TextField!
    var user = String()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        
        
        view.addGestureRecognizer(tap)
        
        privateEditTextField.text = privateitemTextLbl
        
        let userID = UserDefaults.standard
        if userID.string(forKey: "User") != nil {
            user = userID.string(forKey: "User")!
        } else {
            user = "error"
        }
        
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func updateBtnPressed(_ sender: Any) {
        
        
        FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Users").child(self.user).child(privateitemPostID).child("Item").setValue(privateEditTextField.text)
        performSegue(withIdentifier: "Pupdate", sender: UIButton())
        
        
    }
    @IBAction func cancelBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "Pupdate", sender: UIButton())
    }
    
}
