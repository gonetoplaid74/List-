//
//  MainScreenVC.swift
//  List!
//
//  Created by Allan Wallace on 19/10/2016.
//  Copyright © 2016 Allan Wallace. All rights reserved.
//

import UIKit

class MainScreenVC: UIViewController {

    @IBOutlet weak var grocery: MaterialButton!
    @IBOutlet weak var household: MaterialButton!
    @IBOutlet weak var chores: MaterialButton!
    @IBOutlet weak var groupOther: MaterialButton!
    @IBOutlet weak var privateGifts: MaterialButton!
    @IBOutlet weak var privateOther: MaterialButton!
    var list = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func householdBtnPressd(_ sender: AnyObject) {
        if let listName = household.titleLabel?.text {
            list = listName
            
        }
        storeListAndSegue()
        
        
    }
    
    @IBAction func choresBtnPressed(_ sender: AnyObject) {
        if let listName = chores.titleLabel?.text {
            list = listName
            
        }
        storeListAndSegue()
    }
    @IBAction func otherBtnPressed(_ sender: AnyObject) {
        if let listName = groupOther.titleLabel?.text {
            list = listName
            
        }
        storeListAndSegue()
    }
    @IBAction func privateGiftsBtnPressed(_ sender: AnyObject) {
        if let listName = privateGifts.titleLabel?.text {
            list = listName
            
        }
        storeListAndSegue()
    }
    
    @IBAction func privateOtherBtnPressed(_ sender: AnyObject) {
                    list = "Private Other"
            
        
        storeListAndSegue()
    }
    
    @IBAction func groceryBtnPressed(_ sender: MaterialButton) {
        if let listName = grocery.titleLabel?.text {
            list = listName
            
        }
        storeListAndSegue()
    }
    
    
    
    func storeListAndSegue() {
        let storedList = UserDefaults.standard
        storedList.set(list, forKey: "List")
        
        if list == "Private Other" || list == "Gifts" {
            performSegue(withIdentifier: "private", sender: self)
        } else {
        
        performSegue(withIdentifier: "group", sender: self)
        }
        print( "listname stored is userdefaults is ........... \(storedList.string(forKey: "List"))")
    }

}
