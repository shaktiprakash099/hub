//
//  PrivacyaccessManager.swift
//  SocialHub
//
//  Created by GLB-312-PC on 15/03/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import Foundation
import Photos
class PrivacyManager{
    
 private static let instance = PrivacyManager()
    static var shareinstance :PrivacyManager {
        return instance
    }
    
    func checkMediaAccesStatus()->(PHAuthorizationStatus){
       return  PHPhotoLibrary.authorizationStatus()
    }
    
    
}
