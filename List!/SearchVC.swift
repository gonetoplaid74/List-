//
//  SearchVC.swift
//  List!
//
//  Created by AW on 26/10/2016.
//  Copyright © 2016 Allan Wallace. All rights reserved.
//

import UIKit
import Firebase


class SearchVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchTitleLbl: UILabel!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortingBar: UISegmentedControl!
    var list = String()
    var likesCount = Int()

    
            var listName = String()
            var posts = [Post]()
    let searchController = UISearchController(searchResultsController: nil)
    var filteredPosts = [Post]()
    
    
    
        
        override func viewDidLoad() {
            
    
            
            let listNo = UserDefaults.standard
            
            if let listcheck = listNo.string(forKey: "List"){
                
                list = listcheck
            }
            
            if list == "1" {
                sortingBar.isHidden = false
            } else {
                sortingBar.isHidden = true
            }

            
            
            let title = UserDefaults.standard
            if title.string(forKey: "ListName\(list)") != nil {
                searchTitleLbl.text = title.string(forKey: "ListName\(list)")
                                
            
            }
            
            
            
            super.viewDidLoad()
            searchTableView.delegate = self
            searchTableView.dataSource = self
            searchController.searchResultsUpdater = self
            searchController.searchBar.delegate = self
            searchController.dimsBackgroundDuringPresentation = false
            definesPresentationContext = true
            searchTableView.tableHeaderView = searchController.searchBar
            
            
            
            FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Lists").queryOrdered(byChild: "Catagory").queryEqual(toValue: "Removed\(self.list)").observe(.value, with: { snapshot in
                
                
    
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
                
                
                
                self.searchTableView.reloadData()        })
            
            searchTableView.allowsSelectionDuringEditing = true
        }
        
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let add = UITableViewRowAction(style: .normal, title: "Add") { action, index in
            
            if self.searchController.isActive && self.searchController.searchBar.text != "" {
                let item = self.filteredPosts[indexPath.row]
                let likes = self.filteredPosts[indexPath.row]
                self.filteredPosts.remove(at: indexPath.row)
                
                self.likesCount = likes.likes
                    self.likesCount += 1
                
                FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Lists").child(item.postID).child("Catagory").setValue(self.list)
                FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Lists").child(item.postID).child("Likes").setValue(self.likesCount)

                
            } else {
            let item = self.posts[indexPath.row]
                let likes = self.posts[indexPath.row]
            self.posts.remove(at: indexPath.row)
                
                
               self.likesCount = likes.likes
                
                    self.likesCount += 1
                    
                
               
                
            
            FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Lists").child(item.postID).child("Catagory").setValue(self.list)
                FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Lists").child(item.postID).child("Likes").setValue(self.likesCount)
                
                
            
        
        }
        }
        
       
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
           
            if self.searchController.isActive && self.searchController.searchBar.text != "" {
           
                let item = self.filteredPosts[indexPath.row]
                self.filteredPosts.remove(at: indexPath.row)
                
                
                FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Lists").child(item.postID).removeValue()
                
            } else {

            
                
                let item = self.posts[indexPath.row]
                self.posts.remove(at: indexPath.row)
            
            
            FIRDatabase.database().reference().child(groupName.string(forKey: "GroupName")!).child("Lists").child(item.postID).removeValue()

            
            }
            }
        
        
        add.backgroundColor = UIColor(red: 0.3764, green: 0.4902, blue: 0.5451, alpha: 1.0)
        delete.backgroundColor = UIColor(red: 0.9411, green: 0.3764, blue: 0.5725, alpha: 1.0)
        return[delete, add]
        
    
    }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if searchController.isActive && searchController.searchBar.text != "" {
                return filteredPosts.count
              
                
            }
            
            return posts.count
        }
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchCell
            
            let post : Post
            
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
                self.posts.sort{
                    $0.likes > $1.likes
                }
            default: break
            }
            }
           
            
            if searchController.isActive && searchController.searchBar.text != "" {
                post = filteredPosts[indexPath.row]
                
               
                
            } else {
                post = posts[indexPath.row]
                
            }
            
            cell?.configureCell(post)
            return cell!
            
        }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        filteredPosts = posts.filter { Post in
            return Post.item.lowercased().contains(searchText.lowercased())
            
            
        }
            searchTableView.reloadData()
    
        
}

    @IBAction func sortingBarSelected(_ sender: Any) {
        
        self.searchTableView.reloadData()
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        if list == "1" {
            performSegue(withIdentifier: "SearchBack1", sender: UIButton.self)
        } else {
            performSegue(withIdentifier: "SearchBack2", sender: UIButton.self)
        }
    }


}
extension SearchVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    
}
