//
//  GroupListVC.swift
//  List!
//
//  Created by Allan Wallace on 19/10/2016.
//  Copyright © 2016 Allan Wallace. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase





class GroupListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    // @IBOutlet weak var addCatagoryLBL: UITextField!
    @IBOutlet weak var listTitle: UILabel!
    @IBOutlet weak var addItemLbl: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var listName = String()
    
    var posts = [Post]()
    
    
    override func viewDidLoad() {
        
        let title = UserDefaults.standard
        if title.string(forKey: "List") != nil {
            listTitle.text = title.string(forKey: "List")
            listName = title.string(forKey: "List")!
        }
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        
        DataService.ds.REF_POSTS.queryOrdered(byChild: "Catagory").queryEqual(toValue: "\(listName)").observe(.value, with: { snapshot in
            
            
            
            
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
            
            
            
            self.tableView.reloadData()        })
        
        tableView.allowsSelectionDuringEditing = true
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let item = self.posts[indexPath.row]
        self.posts.remove(at: indexPath.row)
        
        DataService.ds.REF_POSTS.child(item.postID).removeValue(completionBlock: { (error, ref) in
            if error != nil {
                print("Failed to delete item;" , error)
                return
            }
            
            
            
            
            //  self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            
        })
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            cell.configureCell(post: post)
            
            return cell
        } else {
            return PostCell()
        }
        
    }
    @IBAction func addBtnPressed(_ sender: AnyObject) {
        
        guard let item = addItemLbl.text, item != "" else {
            print(" Item must be entered .............")
            return
        }
        postToFirebase()
        
    }
    
    func postToFirebase() {
        let post: Dictionary<String, String> = [
            "Item": addItemLbl.text!,
            "Catagory": listTitle.text!,
            // "Aisle": addCatagoryLBL.text!
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        addItemLbl.text = ""
        // addCatagoryLBL.text = ""
        
        self.tableView.reloadData()
        
        
    }
    
    
    
}
