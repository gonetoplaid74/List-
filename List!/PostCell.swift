//
//  PostCell.swift
//  List!
//
//  Created by AW on 21/10/2016.
//  Copyright © 2016 Allan Wallace. All rights reserved.
//

import UIKit
import Firebase


class PostCell: UITableViewCell {
    
    @IBOutlet weak var item: UILabel!
    @IBOutlet weak var aisle: UILabel!
   
    
    var post: Post!
    var likesRef: FIRDatabaseReference!
    var list = String()
    var listName = String()


    func viewDidLoad() {
        viewDidLoad()
        
        let listCheck = UserDefaults.standard
        let list1Name = UserDefaults.standard
        
        if let listNo = listCheck.string(forKey: "List") {
            list = listNo
            print(" .....list: \(list)")
        }
        
        
        if list1Name.string(forKey: "ListName\(list)") != nil {
            listName = list1Name.string(forKey: "ListName\(list)")!
        } else {
            listName = list1Name.string(forKey: "ListName1")!
        }
    

    }
    
//    }
    
    func configureCell(post: Post) {
        
        let listCheck = UserDefaults.standard
        if let listNo = listCheck.string(forKey: "List") {
            list = listNo
        }
        
        if list == "1" {
            self.post = post
            self.item.text = post.item
            //self.aisle.text = "hello"
            self.aisle.text = post.aisle
            
        } else {
           // aisle.isHidden = true
        self.post = post
             self.item.text = post.item
        }

    }

}
