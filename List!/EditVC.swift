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
    var list = String()
    
    @IBOutlet weak var editAisleField: TextField!
    @IBOutlet weak var editTextField: UITextField!
    @IBOutlet weak var editAisleLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listNo = UserDefaults.standard
        if let listcheck = listNo.string(forKey: "List"){
            list = listcheck
        }

        editTextField.text = itemTextLbl
        
       // let list1Name = UserDefaults.standard
        
        if list == "1" {
        editAisleField.text = itemAisle
            editAisleLbl.isHidden = false
            editAisleField.isHidden = false
        }         
        
    }
    @IBAction func updateBtnPressed(_ sender: Any) {
        
        //let list1Name = UserDefaults.standard
        
        if list == "1" {
            FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Lists").child(itemPostID).child("Item").setValue(editTextField.text)
        
        FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Lists").child(itemPostID).child("Aisle").setValue(editAisleField.text)

        self.performSegue(withIdentifier: "FinishEdit", sender: UIButton())
            
        } else {
            FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Lists").child(itemPostID).child("Item").setValue(editTextField.text)
            self.performSegue(withIdentifier: "FinishEdit2", sender: UIButton())
        }

    }

    @IBAction func cancelBtnPressed(_ sender: Any) {
        
        //let list1Name = UserDefaults.standard
        
        if list == "1"{
            self.performSegue(withIdentifier: "FinishEdit", sender: UIButton())
        } else {
            self.performSegue(withIdentifier: "FinishEdit2", sender: UIButton())
        }
        
    }
    }
