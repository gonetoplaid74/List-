//
//  EditVC.swift
//  List!
//
//  Created by AW on 07/11/2016.
//  Copyright © 2016 Allan Wallace. All rights reserved.
//

import UIKit
import Firebase

class EditVC: UIViewController {

    var editText = String()
    var listName = String()
    
    @IBOutlet weak var editAisleField: TextField!
    @IBOutlet weak var editTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let list = UserDefaults.standard
        listName = list.string(forKey: "List")!

        editTextField.text = itemTextLbl
        if listName == "Grocery" {
        editAisleField.text = itemAisle
        }
        
        
    }
    @IBAction func updateBtnPressed(_ sender: Any) {
        
        if listName == "Grocery"{
        FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Lists").child(itemPostID).child("Item").setValue(editTextField.text)
        
        FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Lists").child(itemPostID).child("Aisle").setValue(editAisleField.text)

        self.performSegue(withIdentifier: "FinishEdit", sender: UIButton())
            
        } else {
            FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Lists").child(itemPostID).child("Item").setValue(editTextField.text)
            self.performSegue(withIdentifier: "FinishEdit2", sender: UIButton())
        }

    }

    }
