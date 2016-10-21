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
    
    @IBOutlet weak var item: UITextView!
    @IBOutlet weak var catagory: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likesImg: UIImageView!
    
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
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(likeBtnPressed))
//        tap.numberOfTapsRequired = 1
//        likesImg.addGestureRecognizer(tap)
//        likesImg.isUserInteractionEnabled = true
//        
//    }
    
    func configureCell(post: Post) {
        self.post = post
      //  likesRef = DataService.ds.REF_USER_CURRENT.child("Likes").child(post.postID)
        self.catagory.text = post.aisle
        self.item.text = post.item
       // self.likesLbl.text = "\(post.likes)"


    }
//    func likeBtnPressed(sender: UITapGestureRecognizer) {
//        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            if let _ = snapshot.value as? NSNull {
//                self.likesImg.image = UIImage(named: "filled-heart")
//                self.post.adjustLikes(addLikes: true)
//                self.likesRef.setValue(true)
//            } else {
//                self.likesImg.image = UIImage(named: "empty-heart")
//                self.post.adjustLikes(addLikes: false)
//                self.likesRef.removeValue()
//                
//            }
//            
//        })
//        
//        
//    }

}
