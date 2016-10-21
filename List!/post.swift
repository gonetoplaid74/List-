//
//  post.swift
//  List!
//
//  Created by AW on 20/10/2016.
//  Copyright © 2016 Allan Wallace. All rights reserved.
//
import Foundation
import Firebase


class Post{
    
    private var _catagory: String!
    private var _aisle: String!
    private var _item: String!
    private var _likes: Int!
    private var _listName: String!
    private var _postID: String!
    private var _postReference: FIRDatabaseReference!
    
    
    var catagory: String {
        return _catagory
    }
    var aisle: String {
        return _aisle
    }

    
    var item: String {
        return _item
    }
    var likes: Int {
        return _likes
    }
    var listName: String {
        return _listName
    }
    var postID: String {
        return _postID
    }
    
    init(catagory: String, item: String, likes: Int, listName: String, aisle: String) {
        
        self._catagory = catagory
        self._item = item
        self._likes = likes
        self._listName = listName
        self._aisle = aisle
        
    }
    init(postID: String, postData: Dictionary<String, AnyObject>) {
        self._postID = postID
        
        if let catagory = postData["Catagory"] as? String {
            self._catagory = catagory
        }
        
        if let aisle = postData["Aisle"] as? String {
            self._aisle = aisle
        }
        
        if let item = postData["Item"] as? String {
            self._item = item
        }
        
        if let likes = postData["Likes"] as? Int {
            self._likes = likes
            
        }
        if let listName = postData["ListName"] as? String {
            self._listName = listName
        }
        
        
        _postReference = DataService.ds.REF_POSTS.child(_postID)
        
    }
    func adjustLikes(addLikes: Bool) {
        if addLikes {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        _postReference.child("Likes").setValue(likes)
        
    }
    
    
    
}