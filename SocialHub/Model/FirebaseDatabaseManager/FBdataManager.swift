//
//  FBdataManager.swift
//  SocialHub
//
//  Created by GLB-312-PC on 13/03/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class FBdatabaseProvider {
    
    
private static let instance = FBdatabaseProvider();
    
    static var shareinstance :FBdatabaseProvider{
     return instance;
    }
    
    var dbRef: DatabaseReference {
        return Database.database().reference()
    }
    
    var userRef: DatabaseReference {
        return dbRef.child(Constants.USERS)
    }
    
    var postRef: DatabaseReference {
        return dbRef.child(Constants.POSTS)
    }
    var storyRef : DatabaseReference {
        
        return dbRef.child(Constants.STORIES)
    }
    
    var storageReference: StorageReference {
        return Storage.storage().reference(forURL: Constants.STORAGE_URL_STRING)
    }
    
    var profileImgestorage: StorageReference {
        return storageReference.child(Constants.PROFILE_IMAGE_STORAGE)
    }
    
    var shareImagestorage:StorageReference {
        return storageReference.child(Constants.SHARE_IMAGE_STORAGE)
    }
    
    var storyImagestorage: StorageReference{
        return storageReference.child(Constants.STORY_IMAGE_STORAGE)
    }
    
    func saveUserInfo(withId: String,email: String,password:String,name : String,profilepicUrlstring:String,quickblocksId:UInt){
        
        let data: Dictionary<String,Any> = [Constants.EMAIL:email,Constants.NAME : name,Constants.PASSWORD:password,Constants.PROFILE_IMAGE_URL:profilepicUrlstring,Constants.USERID:withId,Constants.QUICKBLOXID:quickblocksId]
        userRef.child(withId).setValue(data)
    }
    
    func savePostsinfo(shareimagecaption:String,shareImgeUrlstring:String,onSuccess:@escaping()->Void,onError:@escaping(_ error:String?)->Void){
               let uploaderID = Auth.auth().currentUser!.uid
               let PostId = NSUUID().uuidString
        
        let data:Dictionary<String,Any> = [Constants.POSTTIMESTAMP:Date().timeIntervalSince1970 ,Constants.SHARE_IMAGE_URL: shareImgeUrlstring,Constants.SHARE_IMAGE_CAPTION:shareimagecaption,Constants.POSTID:PostId,Constants.UPLOADERID:uploaderID]
        postRef.childByAutoId().setValue(data) { (error, ref) in
            if error != nil {
              onError(error!.localizedDescription)
            }
            else{
                let posts = ["posts/\(PostId)" : data]
                self.userRef.child(uploaderID).updateChildValues(posts)
                onSuccess()
            }
            
        }
    }
    
    func saveStoryinfo(storyImageUrl : String,storyUserId : String,storyUserPicUrl: String,storyUserName : String,onSuccess:@escaping()->Void,onError:@escaping(_ error: String?)-> Void){
        let data : Dictionary<String,Any> = [Constants.STORY_IMAGE_URL:storyImageUrl,Constants.STORY_USER_ID:storyUserId,Constants.STORY_USER_PICURL:storyUserPicUrl,Constants.STORY_USER_NAME:storyUserName]
        storyRef.childByAutoId().setValue(data) { (error, ref) in
            if error != nil {
                onError(error!.localizedDescription)
            }
            else{
                onSuccess()
            }

        }
        
    }
}


