//
//  QuickblockManager.swift
//  SocialHub
//
//  Created by GLB-312-PC on 19/04/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import Foundation
import Quickblox
class QuickblocxManager {
   
static let shareinstance = QuickblocxManager()
    
    func createnewQuickblocksUser(Quserlogin:String,QuserPassword:String){
        let user = QBUUser()
        user.login = Quserlogin
        user.password = QuserPassword
        QBRequest.signUp(user, successBlock: { (Qbresponse, qbuser) in
            print("successfully registred \(qbuser) ")
        }) { (error) in
         
            print("Something went wrong")
        }
        
    }
    
   func  signinQuickblockUser(Quserlogin:String,QuserPassword:String){
    
    
    
    
    
  }
    
    
    
    
}
