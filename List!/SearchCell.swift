//
//  SearchCell.swift
//  List!
//
//  Created by AW on 26/10/2016.
//  Copyright © 2016 Allan Wallace. All rights reserved.
//

import UIKit
import Firebase


class SearchCell: UITableViewCell {
    @IBOutlet weak var searchItem: UILabel!
    var post: Post!
    var list = String()
    
    func viewDidLoad() {
        viewDidLoad()
        
        let listName = UserDefaults.standard
        //let list1Name = UserDefaults.standard
        
        if listName.string(forKey: "List") != nil {
            list = listName.string(forKey: "List")!
        } else {
            list = "1"
        }
        
        
    }
    
    //    }
    
    func configureCell(_ post: Post) {
        self.post = post
        self.searchItem.text = post.item
        
        
    }
    
}

    
