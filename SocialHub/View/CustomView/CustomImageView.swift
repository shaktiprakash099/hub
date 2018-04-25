//
//  CustomImageView.swift
//  HashTagApp
//
//  Created by GLB-312-PC on 09/01/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import UIKit

@IBDesignable class CustomImageView: UIImageView {
    
    @IBInspectable var cornerRadius : CGFloat = 0  {
        didSet {
          updateUI()
            
        }
      
 }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet  {
            updateUI()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet  {
            updateUI()
        }
    }
   
    func updateUI(){
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}
