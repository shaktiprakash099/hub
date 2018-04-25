//
//  CallViewController.swift
//  SocialHub
//
//  Created by GLB-312-PC on 20/04/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import UIKit
import Quickblox
import QuickbloxWebRTC
import ProgressHUD

class CallViewController: UIViewController,QBRTCClientDelegate{

   
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var receiveButton: UIButton!
    @IBOutlet weak var rejectbutton: UIButton!
    
    open var opponents:[QBUUser]?
    open var curreentUser:QBUUser?
      var videoCapture:QBRTCCameraCapture!
      var session: QBRTCSession?
      var  remoteView :QBRTCRemoteVideoView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        QBRTCClient.initializeRTC()
        QBRTCClient.instance().add(self)
        configureVideo()
        configurreAudio()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.resumeVideoCapture()
    }
    
    //MARK:Back action
    @IBAction func backButtonAction(_ sender: Any) {
        
        ProgressHUD.show("Logout")
        QBChat.instance.disconnect { (err) in
            QBRequest .logOut(successBlock: { (r) in
                ProgressHUD.dismiss()
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
  

    @IBAction func callButtonAction(_ sender: Any) {
        
        if ((sender as? UIButton) != nil){
        
            let ids = self.opponents?.map({$0.id})
            self.session = QBRTCClient.instance().createNewSession(withOpponents: ids! as [NSNumber],
                                                                   with: .video)
            self.session?.localMediaStream.videoTrack.videoCapture = self.videoCapture
            self.session?.startCall(["info" : "user info"])
            
        }
      
        
        
    }
    
    @IBAction func reJectAction(_ sender: Any) {
        
        if self.session != nil {
            self.session?.hangUp(nil)
        }
        
    }
    
    //MARK: Configuration
    
    func configureVideo(){
        QBRTCConfig.mediaStreamConfiguration().videoCodec = .H264
        let videoFarmat  = QBRTCVideoFormat.init()
        videoFarmat.frameRate = 21
        videoFarmat.pixelFormat = .format420f
        videoFarmat.width = 640;
        videoFarmat.height = 480
        self.videoCapture = QBRTCCameraCapture.init(videoFormat: videoFarmat, position: .front)
        self.videoCapture.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        self.videoCapture.startSession {
            
            let localView = LocalVideoView.init(withPreviewLayer:self.videoCapture.previewLayer)
            self.stackView.addArrangedSubview(localView)
        
        }
        
    }
    //MARK: Configurations
    
    func configurreAudio(){
        
        QBRTCConfig.mediaStreamConfiguration().audioCodec =  .codecOpus
        QBRTCAudioSession.instance().initialize()
        QBRTCAudioSession.instance().currentAudioDevice = .speaker
        QBRTCAudioSession.instance().initialize { (configuration:QBRTCAudioSessionConfiguration)->() in
            
            var options = configuration.categoryOptions
            if #available(iOS 10.0, *){
                options = options.union(AVAudioSessionCategoryOptions.allowBluetoothA2DP)
                options = options.union(AVAudioSessionCategoryOptions.allowAirPlay)
            }
            else{
                options = options.union(AVAudioSessionCategoryOptions.allowBluetooth)
            }
            configuration.categoryOptions = options
            configuration.mode = AVAudioSessionModeVideoChat
        }
        
        
    }
    func resumeVideoCapture() {
        // ideally you should always stop capture session
        // when you are leaving controller in any way
        // here we should get its running state back
        if self.videoCapture != nil && !self.videoCapture.hasStarted {
            self.session?.localMediaStream.videoTrack.videoCapture = self.videoCapture
            self.videoCapture.startSession(nil)
        }
    }
    
    func handleIncomingCall() {
        
        let alert = UIAlertController.init(title: "Incoming video call", message: "Accept ?", preferredStyle: .actionSheet)
        
        let accept = UIAlertAction.init(title: "Accept", style: .default) { action in
            self.session?.localMediaStream.videoTrack.videoCapture = self.videoCapture
            self.session?.acceptCall(nil)
//            self.callBtn.isHidden = true
//            self.logoutBtn.isEnabled = false
        }
        
        let reject = UIAlertAction.init(title: "Reject", style: .default) { action in
            self.session?.rejectCall(nil)
        }
        
        alert.addAction(accept)
        alert.addAction(reject)
        self.present(alert, animated: true)
    }
    
    
    func removeRemoteView(with userID: UInt) {
        
        for view in self.stackView.arrangedSubviews {
            if view.tag == userID {
                self.stackView.removeArrangedSubview(view)
            }
        }
    }
    //MARK: delegate methods
    func didReceiveNewSession(_ session: QBRTCSession, userInfo: [String : String]? = nil) {
        
        if self.session == nil {
            self.session = session
            handleIncomingCall()
        }
    }
    
    func session(_ session: QBRTCBaseSession, connectedToUser userID: NSNumber) {
        
        if (session as! QBRTCSession).id == self.session?.id {
            if session.conferenceType == QBRTCConferenceType.video {
//                self.screenShareBtn.isHidden = false
            }
        }
    }
    
    func session(_ session: QBRTCSession, hungUpByUser userID: NSNumber, userInfo: [String : String]? = nil) {
        
        if session.id == self.session?.id {
            
            self.removeRemoteView(with: userID.uintValue)
            if userID == session.initiatorID {
                self.session?.hangUp(nil)
            }
        }
    }
    
    func session(_ session: QBRTCBaseSession, receivedRemoteVideoTrack videoTrack: QBRTCVideoTrack, fromUser userID: NSNumber) {
        
        if (session as! QBRTCSession).id == self.session?.id {
           
            let remoteView :QBRTCRemoteVideoView = QBRTCRemoteVideoView.init()
            remoteView.videoGravity = AVLayerVideoGravity.resizeAspect.rawValue
            remoteView.clipsToBounds = true
            remoteView.setVideoTrack(videoTrack)
            remoteView.tag = userID.intValue
            self.stackView.addArrangedSubview(remoteView)
        
        }
    }
    
    // MARK: QBRTCClientDelegate
    private func session(session: QBRTCSession!, rejectedByUser userID: NSNumber!, userInfo: [NSObject : AnyObject]!) {
        print("Rejected by user \(userID)")
    }
    
    private func session(session: QBRTCSession!, connectionClosedForUser userID: NSNumber!) {
        print("Connection is closed for user \(userID)")
    }
    
    private func session(session: QBRTCSession!, startedConnectingToUser userID: NSNumber!) {
        print("Started connecting to user \(userID)")
    }
    
    private func session(_ session: QBRTCSession!, connectionFailedForUser userID: NSNumber!) {
        print("Connection has failed with user \(userID)")
    }
    func session(_ session: QBRTCSession, userDidNotRespond userID: NSNumber) {
        print("User \(userID) did not respond to your call within timeout")
    }
    
    private func session(_ session: QBRTCSession!, disconnectedFromUser userID: NSNumber!) {
        print("Disconnected from user \(userID)");
    }
    func sessionDidClose(_ session: QBRTCSession) {
        print("Session close")
        if session.id == self.session?.id {
//            self.callBtn.isHidden = false
//            self.logoutBtn.isEnabled = true
//            self.screenShareBtn.isHidden = true
            let ids = self.opponents?.map({$0.id})
            for userID in ids! {
                self.removeRemoteView(with: userID)
            }
            self.session = nil
        }
    }
    
    
    
}


