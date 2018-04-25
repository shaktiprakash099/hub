//
//  Storys.swift
//  SocialHub
//
//  Created by GLB-312-PC on 04/04/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import Foundation
import FirebaseDatabase
struct Storys {
    var  storyUserID: String?
    var  storyUserName: String?
    var storyUserPicUrl: String?
    var storyimageUrl:String?
    init(snapshots: DataSnapshot){
        
        let snapshotsValue = snapshots.value as! [String: AnyObject]
        storyUserID = snapshotsValue["storyUserID"] as? String
        storyUserName = snapshotsValue["storyUserName"] as? String
        storyUserPicUrl = snapshotsValue["storyUserPicUrl"] as? String
        storyimageUrl = snapshotsValue["storyimageUrl"] as? String
        
    }
}
