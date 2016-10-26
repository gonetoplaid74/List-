//
//  SearchVC.swift
//  List!
//
//  Created by AW on 26/10/2016.
//  Copyright © 2016 Allan Wallace. All rights reserved.
//

import UIKit
import Firebase

class SearchVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var searchTitleLbl: UILabel!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
            var listName = String()
            var posts = [Post]()
        
        
        override func viewDidLoad() {
            
            let title = UserDefaults.standard
            if title.string(forKey: "List") != nil {
                searchTitleLbl.text = title.string(forKey: "List")
                listName = title.string(forKey: "List")!
            }
            
            super.viewDidLoad()
            searchTableView.delegate = self
            searchTableView.dataSource = self
            
            
            
            
            DataService.ds.REF_POSTS.queryOrdered(byChild: "Catagory").queryEqual(toValue: nil).observe(.value, with: { snapshot in
                
                
                
    
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
                
                
                
                self.searchTableView.reloadData()        })
            
            searchTableView.allowsSelectionDuringEditing = true
        }
        
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            
            // (completionBlock: { (error, ref) in
        //        if error != nil {
         //           print("Failed to delete item;" , error)
         //           return
         //       }
                
                
                
                
                //  self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
                
        //    })
            
    
    //    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let add = UITableViewRowAction(style: .normal, title: "Add") { action, index in
            let item = self.posts[indexPath.row]
            self.posts.remove(at: indexPath.row)
            
            DataService.ds.REF_POSTS.child(item.postID).child("Catagory").setValue(self.listName)
            
            print("Add button tapped")
        }
        add.backgroundColor = UIColor.green
        return[add]
        self.searchTableView.reloadData()
    }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return posts.count
        }
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let post = posts[indexPath.row]
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchCell {
                
                cell.configureCell(post: post)
                
                return cell
            } else {
                return SearchCell()
            }
            
        }
      //  @IBAction func addBtnPressed(_ sender: AnyObject) {
            
      //      guard let item = addItemLbl.text, item != "" else {
      //          print(" Item must be entered .............")
      //          return
     //       }
     //       postToFirebase()
            
     //   }
        
     //   func postToFirebase() {
     //       let post: Dictionary<String, String> = [
     //           "Item": addItemLbl.text!,
     //           "Catagory": listTitle.text!,
                // "Aisle": addCatagoryLBL.text!
     //       ]
            
    //        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
    //        firebasePost.setValue(post)
    //
     //       addItemLbl.text = ""
           // addCatagoryLBL.text = ""
            
    //        self.searchTableView.reloadData()
            
            
    //    }
        
        
        
}
