//
//  LocalVideoView.swift
//  SocialHub
//
//  Created by GLB-312-PC on 20/04/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import AVFoundation
import UIKit
class LocalVideoView: UIView{

    var videoLayer: AVCaptureVideoPreviewLayer?
    public init(withPreviewLayer layer:AVCaptureVideoPreviewLayer){
        super.init(frame:.zero)
        
        self.videoLayer = layer
        self.videoLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.layer.insertSublayer(layer, at: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.videoLayer?.frame = self.bounds
    }
    
}
