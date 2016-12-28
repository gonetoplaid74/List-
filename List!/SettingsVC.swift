//
//  SettingsVC.swift
//  List!
//
//  Created by AW on 12/12/2016.
//  Copyright © 2016 Allan Wallace. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {

    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var passcode: UITextField!
    @IBOutlet weak var list1Name: UITextField!
    @IBOutlet weak var list2Name: UITextField!
    @IBOutlet weak var list3Name: UITextField!
    @IBOutlet weak var list4Name: UITextField!
    @IBOutlet weak var list5Name: UITextField!
    @IBOutlet weak var list6Name: UITextField!
    @IBOutlet weak var infoLbl: UILabel!
    var list1Check = [String]()
    var list2Check = [String]()
    var list3Check = [String]()
    var list4Check = [String]()
    var list5Check = [String]()
    var list6Check = [String]()
    //var checker = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let storedGroupName = UserDefaults.standard
        let storedList1Name = UserDefaults.standard
        let storedList2Name = UserDefaults.standard
        let storedList3Name = UserDefaults.standard
        let storedList4Name = UserDefaults.standard
        let storedList5Name = UserDefaults.standard
        let storedList6Name = UserDefaults.standard
        
        
        groupName.text = storedGroupName.string(forKey: "GroupName")
        list1Name.text = storedList1Name.string(forKey: "ListName1")
        list2Name.text = storedList2Name.string(forKey: "ListName2")
        list3Name.text = storedList3Name.string(forKey: "ListName3")
        list4Name.text = storedList4Name.string(forKey: "ListName4")
        list5Name.text = storedList5Name.string(forKey: "ListName5")
        list6Name.text = storedList6Name.string(forKey: "ListName6")
        
        print("list1Name ..... \(list1Name.text)")
        
        
        FIRDatabase.database().reference().child(groupName.text!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let pscode = value?["Passcode"] as? String
            print("pscode ........ \(pscode)")
            
           // let user = User.init(username: username)
            self.passcode.text = pscode
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
       
    }

 
    @IBAction func saveBtnPressed(_ sender: Any) {
     //   let groupName = UserDefaults.standard
       self.list1Check = []
        self.list2Check = []
        self.list3Check = []
        self.list4Check = []
        self.list5Check = []
        self.list6Check = []
        
        
        if let l1n = list1Name.text {
           self.list2Check.append(l1n)
            self.list3Check.append(l1n)
            self.list4Check.append(l1n)
            self.list5Check.append(l1n)
            self.list6Check.append(l1n)
                   }
        
        if let l2n = list2Name.text {
            self.list1Check.append(l2n)
            self.list3Check.append(l2n)
            self.list4Check.append(l2n)
            self.list5Check.append(l2n)
            self.list6Check.append(l2n)
        }
        
        if let l3n = list3Name.text {
            self.list1Check.append(l3n)
            self.list2Check.append(l3n)
            self.list4Check.append(l3n)
            self.list5Check.append(l3n)
            self.list6Check.append(l3n)
        }
        
        if let l4n = list4Name.text {
            self.list1Check.append(l4n)
            self.list2Check.append(l4n)
            self.list3Check.append(l4n)
            self.list5Check.append(l4n)
            self.list6Check.append(l4n)
        }
        
        if let l5n = list5Name.text {
            self.list1Check.append(l5n)
            self.list2Check.append(l5n)
            self.list4Check.append(l5n)
            self.list3Check.append(l5n)
            self.list6Check.append(l5n)
        }
        
        if let l6n = list6Name.text {
            self.list1Check.append(l6n)
            self.list2Check.append(l6n)
            self.list4Check.append(l6n)
            self.list5Check.append(l6n)
            self.list3Check.append(l6n)
        }
       
        print ("... \(list5Check),\(list6Check)")
        
        if list1Check.contains(list1Name.text!) || list2Check.contains(list2Name.text!) || list3Check.contains(list3Name.text!) || list4Check.contains(list4Name.text!) || list5Check.contains(list5Name.text!) || list6Check.contains(list6Name.text!) {
            infoLbl.isHidden = false
            infoLbl.text = "You cannot have duplicate List names"
            
            
        } else {
            let storedList1Name = UserDefaults.standard
            let storedList2Name = UserDefaults.standard
            let storedList3Name = UserDefaults.standard
            let storedList4Name = UserDefaults.standard
            let storedList5Name = UserDefaults.standard
            let storedList6Name = UserDefaults.standard
            
            storedList1Name.set(list1Name.text, forKey: "ListName1")
            storedList2Name.set(list2Name.text, forKey: "ListName2")
            storedList3Name.set(list3Name.text, forKey: "ListName3")
            storedList4Name.set(list4Name.text, forKey: "ListName4")
            storedList5Name.set(list5Name.text, forKey: "ListName5")
            storedList6Name.set(list6Name.text, forKey: "ListName6")
            
         //   FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Lists").child(itemPostID).child("Catagory").setValue(list1Name.text)
            
             performSegue(withIdentifier: "SettingSave", sender: UIButton())
        }
        
        

        
        
        
        
        
        
       
    }
    func keyboardWillShow(notification: NSNotification) {
        
        
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= 125
        }
        
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += 125
        }
    }


    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "SettingSave", sender: UIButton())
    }
}
