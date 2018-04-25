//
//  Posts.swift
//  SocialHub
//
//  Created by GLB-312-PC on 28/03/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
struct  Posts {
    
    var postsid  : String?
    var shareimageUrl: String?
    var shareimagecaption: String?
    var uploaderId: String?
    var postTimeStamp: Double?
    init(snapshots : DataSnapshot) {
        let snapshotsValue  = snapshots.value as! [String: AnyObject]
        postsid = snapshotsValue["postsid"] as? String
        shareimageUrl = snapshotsValue["shareimageUrl"] as? String
        postTimeStamp = snapshotsValue["postTimeStamp"] as? Double
        shareimagecaption = snapshotsValue["shareimagecaption"] as? String
        uploaderId = snapshotsValue["uploaderId"] as? String
    }
    
}
