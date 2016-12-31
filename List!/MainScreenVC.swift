//
//  MainScreenVC.swift
//  List!
//
//  Created by Allan Wallace on 19/10/2016.
//  Copyright © 2016 Allan Wallace. All rights reserved.
//


import UIKit
import SwiftKeychainWrapper
import Firebase

class MainScreenVC: UIViewController {
    
    @IBOutlet weak var grocery: MaterialButton!
    @IBOutlet weak var household: MaterialButton!
    @IBOutlet weak var chores: MaterialButton!
    @IBOutlet weak var groupOther: MaterialButton!
    @IBOutlet weak var privateGifts: MaterialButton!
    @IBOutlet weak var privateOther: MaterialButton!
    var currentList = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listName = UserDefaults.standard
        
        if listName.string(forKey: "ListName1") != nil {
             grocery.setTitle(listName.string(forKey: "ListName1"), for: .normal)
            
        } else {
           
            listName.set("Grocery", forKey: "ListName1")
            grocery.setTitle("Grocery", for: .normal)
        
        }
        
        if listName.string(forKey: "ListName2") != nil {
                        household.setTitle(listName.string(forKey: "ListName2"), for: .normal)

        } else {
            listName.set("Household", forKey: "ListName2")
            household.setTitle("Household", for: .normal)

                    }
        if listName.string(forKey: "ListName3") != nil {
            chores.setTitle(listName.string(forKey: "ListName3"), for: .normal)

            
        } else {
            listName.set("Chores", forKey: "ListName3")
            
            chores.setTitle("Chores", for: .normal)
                    }
        
        if listName.string(forKey: "ListName4") != nil{
            groupOther.setTitle(listName.string(forKey: "ListName4"), for: .normal)

        } else {
            
            listName.set("Message", forKey: "ListName4")
            groupOther.setTitle("Message", for: .normal)
                    }
        
        if listName.string(forKey: "ListName5") != nil {
           privateGifts.setTitle(listName.string(forKey: "ListName5"), for: .normal)
            
        } else {
            listName.set("Gifts", forKey: "ListName5")
            privateGifts.setTitle("Gifts", for: .normal)
            
        }
        if listName.string(forKey: "ListName6") != nil {
            privateOther.setTitle(listName.string(forKey: "ListName6"), for: .normal)

            
        } else {
            listName.set("Other", forKey: "ListName6")
            privateOther.setTitle("Other", for: .normal)
                    }

        

      
    }
    @IBAction func householdBtnPressd(_ sender: AnyObject) {
        currentList = "2"
        
        storeListAndSegue()
        
        
    }
    
    @IBAction func choresBtnPressed(_ sender: AnyObject) {
        currentList = "3"
        storeListAndSegue()
    }
    @IBAction func otherBtnPressed(_ sender: AnyObject) {
     currentList = "4"
        storeListAndSegue()
    }
    @IBAction func privateGiftsBtnPressed(_ sender: AnyObject) {
        
        currentList = "5"
        storeListAndSegue()
    }
    
    @IBAction func privateOtherBtnPressed(_ sender: AnyObject) {
        currentList = "6"
        storeListAndSegue()
    }
    
    @IBAction func groceryBtnPressed(_ sender: MaterialButton) {
        currentList = "1"
        
        storeListAndSegue()
    }
    
    
    
    func storeListAndSegue() {
        let storedList = UserDefaults.standard
        
        
               
        storedList.set(currentList, forKey: "List")
        
        
        if currentList == "5" || currentList == "6" {
            performSegue(withIdentifier: "private", sender: self)
        } else  if currentList == "1"{
            
            performSegue(withIdentifier: "group", sender: self)
        } else {
            performSegue(withIdentifier: "other", sender: self)
        }
     
    }
    
    @IBAction func logoutBtnPressed(_ sender: AnyObject) {
        
     
        
        let _ = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        
      
        
        
        try! FIRAuth.auth()?.signOut()
        
    }
}

