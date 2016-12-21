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
import UserNotifications

var itemTextLbl = String()
var itemPostID = String()
var itemAisle = String()



class GroupListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    @IBOutlet weak var addCatagoryLBL: UITextField!
    @IBOutlet weak var listTitle: UILabel!
    @IBOutlet weak var addItemLbl: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortingBar: UISegmentedControl!
    var listName = String()
    var list = String()
    
    var posts = [Post]()
    
    
    override func viewDidLoad() {
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        let listNo = UserDefaults.standard
        
        if let listcheck = listNo.string(forKey: "List"){
            list = listcheck
        }
        
        
        
        let title = UserDefaults.standard
        if title.string(forKey: "ListName\(list)") != nil {
            listTitle.text = title.string(forKey: "ListName\(list)")
            listName = title.string(forKey: "ListName\(list)")!
        }
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
//        if list == "1"{
//            searchBtn.isHidden = false
//            
//        }
        
        
        FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Lists").queryOrdered(byChild: "Catagory").queryEqual(toValue: "\(list)").observe(.value, with: {snapshot in
            
            
            
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.posts = []
                for snap in snapshot {
                   print("\(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postID: key, postData: postDict)
                        self.posts.append(post)
                        
                    }
                }
            }
            
     
            
            self.tableView.reloadData()
        })
        
        tableView.allowsSelectionDuringEditing = true
        
    }
    
    func appMovedToBackground() {
        
        
        
        if list == "1" {
            if posts.count == 0 {
                UIApplication.shared.applicationIconBadgeNumber = 0
            } else {
            self.scheduleNotification(inSeconds: 2, completion: { success in
                
            })
            
            
        }

    }
    }
    
    func scheduleNotification(inSeconds: TimeInterval, completion: @escaping (_ Success: Bool) -> ()) {
        let notif = UNMutableNotificationContent()
        
        if posts.count != 0 {
        notif.badge = posts.count as NSNumber?
        
        
        let notifTrigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        
        let request = UNNotificationRequest(identifier: "badge", content: notif, trigger: notifTrigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
            
        })
        
    }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            
                let item = self.posts[indexPath.row]
            
            
            if self.list == "1" {
                itemTextLbl = item.item
                itemPostID = item.postID
                itemAisle = item.aisle
                
            self.performSegue(withIdentifier: "Edit", sender: UITableViewRowAction())
        
            } else {
                itemTextLbl = item.item
                itemPostID = item.postID
                self.performSegue(withIdentifier: "edit2", sender: UITableViewRowAction())

                
            }
            
            
        }
        
        
        let delete = UITableViewRowAction(style: .normal, title: "Remove") { action, index in
            
            
            let item = self.posts[indexPath.row]
            self.posts.remove(at: indexPath.row)
            
      //    if self.list == "1" {
                
                FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Lists").child(item.postID).child("Catagory").setValue("Removed\(self.list)")
//            (completionBlock: { (error, ref) in
//                    
//                
//                
//            })
//            } else {
//                
//                FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Lists").child(item.postID).removeValue(completionBlock: { (error, ref) in
//                    return
//                    
//                })
//            }
            
           self.tableView.reloadData()
      //  }
        }
        
        edit.backgroundColor = UIColor(red: 0.3764, green: 0.4902, blue: 0.5451, alpha: 1.0)
        delete.backgroundColor = UIColor(red: 0.9411, green: 0.3764, blue: 0.5725, alpha: 1.0)
        return[delete, edit]
        
        
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post : Post
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            
            
            if list == "1" {
            
            switch(self.sortingBar.selectedSegmentIndex) {
            case 0:
                self.posts.sort{
                    $0.item < $1.item
                }
            case 1:
                self.posts.sort{
                    $0.aisle < $1.aisle
                }
            case 2:
                self.posts.sort {
                    $0.likes > $1.likes
                }
            default: break
            }
            
                
            }
            post = posts[indexPath.row]
            cell.configureCell(post)
            
            return cell
            
            
        } else {
            return PostCell()
        }
        
    }
    @IBAction func addBtnPressed(_ sender: AnyObject) {
        

        
        guard let item = addItemLbl.text, item != "" else {
            
            return
        }
        postToFirebase()
        addItemLbl.resignFirstResponder()
        
    }
    
    func postToFirebase() {
        
        let post: Dictionary<String, AnyObject>
        
       
        
        if list == "1"{
            post = [
            "Item": addItemLbl.text! as AnyObject,
            "Catagory": list as AnyObject,
            "Aisle": addCatagoryLBL.text! as AnyObject,
             "Likes": 0 as AnyObject
        ]
        
        
        } else {
            post = [
                "Item": addItemLbl.text! as AnyObject,
                "Catagory": list as AnyObject,
                "Likes" : 0 as AnyObject
        ]
            
            
        }
        
        let firebasePost = FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Lists").childByAutoId()
        firebasePost.setValue(post)
        
        addItemLbl.text = ""
        
       
        
        if list == "1" {
        addCatagoryLBL.text = ""
        }
        
        self.tableView.reloadData()
        
        
    }
    
    @IBAction func sortingBarSelected(_ sender: Any) {
        self.tableView.reloadData()
        
    }
    
    
}
