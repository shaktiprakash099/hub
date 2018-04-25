//
//  Authprovider.swift
//  SocialHub
//
//  Created by GLB-312-PC on 14/03/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseStorage
import Quickblox

class AuthProvider{
   private static let instance = AuthProvider()
    static  var shareinstance:AuthProvider{
        return instance;
    }
    
    //MARK: Sign In
    func signIn(email:String,password : String, onSuccessCallback: @escaping () ->Void,onErrorCallback: @escaping(_ errorMessage:String?) ->Void){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                onErrorCallback(error!.localizedDescription)
                return
            }
            else {
               onSuccessCallback()
            }
        }
    }
    
    //MARK: Sign up
    func signUp(username: String,email:String,password: String,imageData:Data,onSuccessCallback: @escaping() ->Void,onerrorCallback:@escaping(_ errorMessage: String?)-> Void){
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil{
                print("we have an error \(String(describing: error  ))")
                onerrorCallback(error!.localizedDescription)
                return
            }
            else{
                
                FBdatabaseProvider.shareinstance.profileImgestorage.child(user!.uid + "\(NSUUID().uuidString).jpg").putData(imageData, metadata: nil, completion: { (metadata, error) in
         
                    if error != nil{
                    onerrorCallback(error!.localizedDescription)
                    return
                    }
                    else {
                        
                        let Quser = QBUUser()
                        Quser.login = user!.uid
                        Quser.password = user!.uid
                        
                        QBRequest.signUp(Quser, successBlock: { (qbresponse , QbnewUser) in
                            print("New user successfully inserted")
                            let profilepicImageUrl = metadata?.downloadURL()?.absoluteString
                            FBdatabaseProvider.shareinstance.saveUserInfo(withId: user!.uid, email:email, password: password, name: username, profilepicUrlstring: profilepicImageUrl!,quickblocksId:QbnewUser.id)
                            onSuccessCallback()
                            
                        }, errorBlock: { (errorResponse) in
                            
                            onerrorCallback("something went wrong")
                        })
                        
//                        let profilepicImageUrl = metadata?.downloadURL()?.absoluteString
//                        FBdatabaseProvider.shareinstance.saveUserInfo(withId: user!.uid, email:email, password: password, name: username, profilepicUrlstring: profilepicImageUrl!)
                        
                    }
                })
            }
        }
    }
    
    //MARK: SHAREPOSTS
    func shareImage(shareimagecaption:String,imageData:Data,onSuccessCallback:@escaping()->Void,onErrorCallback:@escaping(_ errormessage:String)->Void){
        
        
   
        FBdatabaseProvider.shareinstance.shareImagestorage.child(NSUUID().uuidString).putData(imageData, metadata: nil) { (metaData, error) in
            if error != nil {
                onErrorCallback(error!.localizedDescription)
                return
            }
            else{
                let sharepicUrl = metaData?.downloadURL()?.absoluteString
                FBdatabaseProvider.shareinstance.savePostsinfo(shareimagecaption: shareimagecaption, shareImgeUrlstring: sharepicUrl!, onSuccess: {
                    onSuccessCallback()
                }, onError: { (error) in
                    onErrorCallback(error!)
                    return
                })
                
            }
            
        }
        
    }
    
    //MARK: POST STORY  
    func postsStory(storyImageData: Data,userId : String,userImageUrl : String,user name:String,onSuccessCallback:@escaping()->Void,onerrorCallback:@escaping(_ error:String)->Void){
        
        FBdatabaseProvider.shareinstance.storyImagestorage.child(NSUUID().uuidString).putData(storyImageData, metadata: nil) { (metaData, error) in
            
            if error != nil {
                onerrorCallback(error!.localizedDescription)
                return
            }
            else{
                let storyImageUrl = metaData?.downloadURL()?.absoluteString
                FBdatabaseProvider.shareinstance.saveStoryinfo(storyImageUrl: storyImageUrl!, storyUserId: userId, storyUserPicUrl: userImageUrl, storyUserName: name, onSuccess: {
                    onSuccessCallback()
                }, onError: { (error) in
                    onerrorCallback(error!)
                })
            }
        }
        
    }
    
}
