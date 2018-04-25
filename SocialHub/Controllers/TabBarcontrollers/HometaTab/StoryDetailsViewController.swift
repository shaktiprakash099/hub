//
//  StoryDetailsViewController.swift
//  SocialHub
//
//  Created by GLB-312-PC on 06/04/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import UIKit

class StoryDetailsViewController: UIViewController {

    @IBOutlet weak var usernamelabel: UILabel!
    @IBOutlet weak var userImage: CustomImageView!
    @IBOutlet weak var storyImageView: UIImageView!
    var storyDetails : Storys?
      let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
//        let bezierPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
      let   path = UIBezierPath()
        
        // Specify the point that the path should start get drawn.
        path.move(to: CGPoint(x: 0, y: 30.0))
        
        // Create a line between the starting point and the bottom-left side of the view.
        path.addLine(to: CGPoint(x: view.frame.size.width, y: 30.0))
        shapeLayer.path = path.cgPath
            //UIBezierPath(roundedRect: CGRect(x: 64, y: 64, width: 360, height: 5), cornerRadius: 0).cgPath
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 5
         shapeLayer.strokeEnd = 0
        shapeLayer.fillColor = UIColor.white.cgColor
   
    
       self.view.layer.addSublayer(shapeLayer)
     
        
       self.customizeView()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.5) {
            self.dismiss(animated: true, completion: nil)
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
           startAnimation()
    }
    
    func startAnimation(){
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1;
        animation.duration = 3
        animation.repeatCount = 0
        animation.autoreverses = false
        shapeLayer.add(animation, forKey: "animation")
    }
    
    
    @IBAction func pauseAction(_ sender: Any) {
        self.pauseLayer(layer: shapeLayer)
    }
    
    @IBAction func Resume(_ sender: Any) {
          self.resumeLayer(layer: shapeLayer)
    }
    
    func customizeView(){
        
      self.usernamelabel.text = storyDetails?.storyUserName
        if let storyImageUrl = self.storyDetails?.storyimageUrl{
            self.storyImageView.sd_setImage(with: URL(string:storyImageUrl), placeholderImage: UIImage.init(named: "defaultUser"))
            
        }
        if let userImageUrl = self.storyDetails?.storyUserPicUrl{
            self.userImage.sd_setImage(with: URL(string:userImageUrl), placeholderImage: UIImage.init(named: "defaultUser"))
        }
        
        
    }
    func pauseLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    func resumeLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    


}
