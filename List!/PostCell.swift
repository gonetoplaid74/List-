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
   
    
    var post: Post!
    var likesRef: FIRDatabaseReference!
    var list = String()


    func viewDidLoad() {
        viewDidLoad()
        
        let listName = UserDefaults.standard
        
        if listName.string(forKey: "List") != nil {
            list = listName.string(forKey: "List")!
        } else {
            list = "Grocery"
        }
    

    }
    
//    }
    
    func configureCell(post: Post) {
        self.post = post
             self.item.text = post.item
       

    }

}
