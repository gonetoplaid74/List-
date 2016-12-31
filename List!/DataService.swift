//
//  DataService.swift
//  List!
//
//  Created by Allan Wallace on 19/10/2016.
//  Copyright © 2016 Allan Wallace. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = FIRDatabase.database().reference()
let groupName = UserDefaults.standard



class DataService {
    
    static let ds = DataService()
    
    

    // DB Reference
    
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child(groupName.string(forKey: "GroupName")!).child("Lists")
    private var _REF_USERS = DB_BASE.child(groupName.string(forKey: "GroupName")!).child("Users")

    
    var REF_BASE : FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
        
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    var REF_USER_CURRENT: FIRDatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
        
    }
    
    
    func createFirbaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func getPosts(catagory: String, item: String, likes: Int, listName: String){
      //  REF_POSTS
    }
    
}

