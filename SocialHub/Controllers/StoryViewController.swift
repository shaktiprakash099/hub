//
//  StoryViewController.swift
//  SocialHub
//
//  Created by GLB-312-PC on 30/03/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import UIKit
import CoreGraphics

protocol storyUploaderDelegate:class{
    
    func storytobeUploaded(image:UIImage)
    
    
}




class StoryViewController: UIViewController {
  
    

    var captiontextView = UITextView()
    @IBOutlet weak var storyImageView: UIImageView!
    var seletedImage: UIImage?
    weak var delegate:storyUploaderDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.storyImageView.image = seletedImage
        captiontextView.frame = CGRect(x: 20, y: 20, width: self.view.frame.size.width - 40, height: 100)
        captiontextView.text = " "
        captiontextView.textColor = .white
        captiontextView.font  = UIFont.boldSystemFont(ofSize: 24)
        captiontextView.isUserInteractionEnabled  = true
        self.storyImageView.addSubview(captiontextView)
        captiontextView.backgroundColor = UIColor.clear
        self.storyImageView.isUserInteractionEnabled = true
    
    
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture))
        self.captiontextView.addGestureRecognizer(panGesture)
       
    }

    
    
    @objc func panGesture(sender: UIPanGestureRecognizer){
        let point = sender.location(in: view)
        let panGesture = sender.view
        panGesture?.center = point
        print(point)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
         self.captiontextView.resignFirstResponder()
        let storyImage = createImage(imageView: self.storyImageView)
        dismiss(animated: true) {
             self.delegate?.storytobeUploaded(image: storyImage)
        }
       
    
    }
    @IBAction func addcaptionAction(_ sender: Any) {
        self.captiontextView.becomeFirstResponder()
    }
    
    
    @IBAction func changeTextstyleAction(_ sender: Any) {
         self.captiontextView.resignFirstResponder()
        let fontFamilyNames = UIFont.familyNames
        let  number = Int(arc4random_uniform(UInt32(fontFamilyNames.count)))
        
        self.captiontextView.font = UIFont.init(name: fontFamilyNames[number], size: 25)
   
    }
    @IBAction func changeTextcoloraction(_ sender: Any) {
        self.captiontextView.resignFirstResponder()
        self.captiontextView.textColor =  UIColor().getRandomColor()
   
     
    }
    
    func createImage(imageView:UIImageView) ->UIImage{
        
        var image = UIImage()
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        imageView.layer.render(in: context!)
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}

extension StoryViewController:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
 
    }
}
