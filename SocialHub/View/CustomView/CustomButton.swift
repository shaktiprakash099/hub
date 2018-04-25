//
//  CustomButton.swift
//  SocialHub
//
//  Created by GLB-312-PC on 27/03/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import UIKit
@IBDesignable class CustomButtom: UIButton{
    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet{
            updateUI()
            
        }
        
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            updateUI()
        }
        
    }
    
    @IBInspectable var bordercolor: UIColor  = UIColor.clear{
        didSet{
            updateUI()
        }
        
    }
    
    func updateUI(){
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor =  bordercolor.cgColor
        self.layer.borderWidth = borderWidth
        
    }
    
}

