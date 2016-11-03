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

class PrivateListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {

    @IBOutlet weak var privateTableView: UITableView!
    @IBOutlet weak var privateLabel: UILabel!
    
    @IBOutlet weak var privateAddItem: TextField!
    
    var user = String()
    var listName = String()
    
    var posts = [Post]()
    
    
    override func viewDidLoad() {
        
        let title = UserDefaults.standard
        let userID = UserDefaults.standard
        if title.string(forKey: "List") != nil {
            privateLabel.text = title.string(forKey: "List")
            listName = title.string(forKey: "List")!
        }
        
        if userID.string(forKey: "User") != nil {
            user = userID.string(forKey: "User")!
        } else {
            user = "error"
        }
        
        super.viewDidLoad()
        privateTableView.delegate = self
        privateTableView.dataSource = self
        
        
        
        FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Users").child(user).queryOrdered(byChild: "Catagory").queryEqual(toValue: "\(listName)").observe(.value, with: {snapshot in
            
            // DataService.ds.REF_POSTS.queryOrdered(byChild: "Catagory").queryEqual(toValue: "\(listName)").observe(.value, with: { snapshot in
            
            
            
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.posts = []
                for snap in snapshot {
                    print("SNAP: \(snap)")
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let item = self.posts[indexPath.row]
        self.posts.remove(at: indexPath.row)
        
        
            FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Users").child(user).child(item.postID).removeValue(completionBlock: { (error, ref) in
                // DataService.ds.REF_POSTS.child(item.postID).removeValue(completionBlock: { (error, ref) in
                if error != nil {
                    print("Failed to delete item", error)
                    return
                }
            })
        
         self.privateTableView.deleteRows(at: [indexPath], with: .automatic)
         self.privateTableView.reloadData()
        

    }
    
    
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
            print(" Item must be entered .............")
            return
        }
        postToFirebase()
        
    }
    
    func postToFirebase() {
        let post: Dictionary<String, String> = [
            "Item": privateAddItem.text!,
            "Catagory": privateLabel.text!
            
        ]
        
        let firebasePost = FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Users").child(user).childByAutoId()
       
        firebasePost.setValue(post)
        
        privateAddItem.text = ""
      
        
        self.privateTableView.reloadData()
        
        
    }
    
    
    
}
