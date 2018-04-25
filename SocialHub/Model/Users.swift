//
//  Users.swift
//  SocialHub
//
//  Created by GLB-312-PC on 19/03/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import UIKit
import FirebaseDatabase
struct Users {
    var email : String?
    var name : String?
    var profileimageUrl : String?
    var userid: String?
    var following:[String: AnyObject]?
    var followers:[String: AnyObject]?
    var posts:[String: AnyObject]?
    var quickblocksid :UInt?
    
    
    init(snapshot: DataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as? String
        email = snapshotValue["email"] as? String
        profileimageUrl = snapshotValue["profileimageUrl"] as? String
        userid = snapshotValue["userid"] as? String
        following = snapshotValue["following"] as? [String: AnyObject]
        followers = snapshotValue["followers"] as? [String: AnyObject]
        posts = snapshotValue["posts"] as? [String: AnyObject]
        quickblocksid = snapshotValue["quickblocksid"] as? UInt
    }
}
