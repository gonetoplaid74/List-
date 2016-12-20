//
//  PrivateListVC.swift
//  List!
//
//  Created by Allan Wallace on 19/10/2016.
//  Copyright © 2016 Allan Wallace. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

var privateitemTextLbl = String()
var privateitemPostID = String()



class PrivateListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {

    @IBOutlet weak var privateTableView: UITableView!
    @IBOutlet weak var privateLabel: UILabel!
    
    @IBOutlet weak var privateAddItem: TextField!
    
    var user = String()
    var listName = String()
    var list = String()
    
    var posts = [Post]()
    
    
    override func viewDidLoad() {
        
        let listNo = UserDefaults.standard
        
        if let listcheck = listNo.string(forKey: "List"){
            list = listcheck
        }
        

        
        let title = UserDefaults.standard
        let userID = UserDefaults.standard
        if title.string(forKey: "ListName\(list)") != nil {
            privateLabel.text = title.string(forKey: "ListName\(list)")
            //listName = title.string(forKey: "List")!
        }
        
        if userID.string(forKey: "User") != nil {
            user = userID.string(forKey: "User")!
        } else {
            user = "error"
        }
        
        super.viewDidLoad()
        privateTableView.delegate = self
        privateTableView.dataSource = self
        
        
        
        FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Users").child(user).queryOrdered(byChild: "Catagory").queryEqual(toValue: "\(list)").observe(.value, with: {snapshot in
            
            // DataService.ds.REF_POSTS.queryOrdered(byChild: "Catagory").queryEqual(toValue: "\(listName)").observe(.value, with: { snapshot in
            
            
            
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.posts = []
                for snap in snapshot {
                   
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postID: key, postData: postDict)
                        self.posts.append(post)
                        
                    }
                }
            }
            
            
            
            self.privateTableView.reloadData()        })
        
      privateTableView.allowsSelectionDuringEditing = true
    
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            
            let item = self.posts[indexPath.row]
            
            privateitemTextLbl = item.item
            privateitemPostID = item.postID
            
            self.performSegue(withIdentifier: "PrivateEdit", sender: UITableViewRowAction())
            
            
            
            
        }
        
        
        let delete = UITableViewRowAction(style: .normal, title: "Remove") { action, index in
            
            
            let item = self.posts[indexPath.row]
            self.posts.remove(at: indexPath.row)
            
            
                FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Users").child(self.user).child(item.postID).removeValue(completionBlock: { (error, ref) in
                    return
                    
                })
            self.privateTableView.reloadData()
            }
        
        
        
        
        edit.backgroundColor = UIColor(red: 0.3764, green: 0.4902, blue: 0.5451, alpha: 1.0)
        delete.backgroundColor = UIColor(red: 1.0, green: 0.502, blue: 0.051, alpha: 1.0 )
        return[delete, edit]
        
        
    }
    

    
    
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        
//        let item = self.posts[indexPath.row]
//        self.posts.remove(at: indexPath.row)
//        
//        
//            FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Users").child(user).child(item.postID).removeValue(completionBlock: { (error, ref) in
//                
//                if error != nil {
//                   
//                    return
//                }
//            })
//        
//         self.privateTableView.deleteRows(at: [indexPath], with: .automatic)
//         self.privateTableView.reloadData()
//        
//
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "privateCell") as? privateCell {
            
            cell.configureCell(post: post)
            
            
            return cell
        } else {
            return privateCell()
        }
                
    }
    
    @IBAction func privateAddBtnPressed(_ sender: Any) {
    
        
        guard let item = privateAddItem.text, item != "" else {
                        return
        }
        postToFirebase()
        privateAddItem.resignFirstResponder()
        
    }
    
    func postToFirebase() {
        let post: Dictionary<String, String> = [
            "Item": privateAddItem.text!,
            "Catagory": list
            
        ]
        
        let firebasePost = FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Users").child(user).childByAutoId()
       
        firebasePost.setValue(post)
        
        privateAddItem.text = ""
      
        
        self.privateTableView.reloadData()
        
        
    }
    
    
    
}
