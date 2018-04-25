//
//  ExtensionFile.swift
//  SocialHub
//
//  Created by GLB-312-PC on 13/03/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import Foundation
import UIKit
extension UITextField {
    
    func customizeTextfield() {
        self.backgroundColor = UIColor.clear
        self.tintColor = UIColor.white
        self.textColor = UIColor.white
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(white: 1.0, alpha: 0.6)])
    }
    
}

extension UIColor{
    
    func getRandomColor() -> UIColor{
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
}
