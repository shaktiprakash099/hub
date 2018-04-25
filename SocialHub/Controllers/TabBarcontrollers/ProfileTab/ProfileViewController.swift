//
//  ProfileViewController.swift
//  SocialHub
//
//  Created by GLB-312-PC on 13/03/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import ProgressHUD
import AVKit
import Photos
class ProfileViewController: UIViewController {
    
    @IBOutlet weak var followersCountLabel: UILabel!
    
    @IBOutlet weak var followingsCountLabel: UILabel!
    
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var nosavedPostsView: CustomView!
    @IBOutlet weak var mynameLable: UILabel!
    
    
    @IBOutlet weak var mymediaCollectionView: UICollectionView!
    @IBOutlet weak var myprofilePicture: CustomImageView!
    
    let picker = UIImagePickerController()
    var userDeatils : Users?
    var postDetails = [Posts]()
    var isReload = true
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStoryvcsegueID"{
            
          let storyVC =  segue.destination as! StoryViewController
            storyVC.seletedImage = sender as? UIImage
            storyVC.delegate = self
        }
  
    }
    
    fileprivate func updatecurrentUserdetails() {
        let userRef = FBdatabaseProvider.shareinstance.userRef
        userRef.child((Auth.auth().currentUser?.uid)!).queryOrderedByKey().observeSingleEvent(of: .value) { (snapshots) in
            self.userDeatils = Users(snapshot: (snapshots as? DataSnapshot)!)
            self.setUPUserDeatils()
        }
        
        userRef.removeAllObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isReload == true {
            
        updatecurrentUserdetails()
            
        }
        else{
            isReload = true
        }
       
    }
    func setUPUserDeatils(){
   
     self.mynameLable.text = userDeatils?.name
        
        if let imageUrl = userDeatils?.profileimageUrl{
            self.myprofilePicture.sd_setImage(with: URL(string:imageUrl), placeholderImage: UIImage.init(named: "defaultUser"))
        }
        
        if let followers = userDeatils?.followers{
            self.followersCountLabel.text = "\(followers.count)"
           
        }
        else{
            self.followingsCountLabel.text = "0"
     
        }
        
        if let posts = userDeatils?.posts{
            self.postCountLabel.text = "\(posts.count)"
            self.fetchUserMediadetails()
        }
        else{
            self.postCountLabel.text = "0"
        }
        if let followings = userDeatils?.following{
            self.followingsCountLabel.text = "\(followings.count)"
        }
        else{
            self.followingsCountLabel.text  = "0"
        }
    }
    
    
    func fetchUserMediadetails(){
        ProgressHUD.show("fetching user media details ..", interaction: false)
        DispatchQueue.global(qos: .userInitiated).async {
            let userRef = FBdatabaseProvider.shareinstance.userRef
            userRef .child((Auth.auth().currentUser?.uid)!).child(Constants.POSTS).queryOrderedByKey().observeSingleEvent(of: .value) { (snapshots ) in
                var postsItem : [Posts] = []
                for post in snapshots.children{
                    print("\(post)")
                    let postDetail = Posts(snapshots: post as! DataSnapshot)
                    postsItem.append(postDetail)
                }
                
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                    self.postDetails = postsItem
                    self.mymediaCollectionView.reloadData()
                 
                }
                
            }
            userRef.removeAllObservers()
        }
        
        
    }
    
    @IBAction func updateProfileAction(_ sender: Any) {
        
    }
    
    
    @IBAction func showmediaCollectionViewAxtion(_ sender: Any) {
        self.mymediaCollectionView.isHidden = false
        self.nosavedPostsView.isHidden = true
    }
    
   
    @IBAction func showSavedPostAction(_ sender: Any) {
        self.mymediaCollectionView.isHidden = true
        self.nosavedPostsView.isHidden = false
    }
    
    
    @IBAction func profileImageTapAction(_ sender: Any) {
   self.openGalleryAction()
//        self.performSegue(withIdentifier: "showStoryvcsegueID", sender: nil)
        
    }
    
    func openGalleryAction(){
        isReload = false
        let pickerController  = UIImagePickerController()
        pickerController.delegate = self
        self.present(pickerController, animated: true, completion: nil)
        
    }
    
}


extension ProfileViewController:storyUploaderDelegate{
    func storytobeUploaded(image: UIImage) {
             ProgressHUD.show("Uploading your story please wait ...", interaction: false)
        if let imageData = UIImageJPEGRepresentation(image, 0.8){
      
            AuthProvider.shareinstance.postsStory(storyImageData: imageData, userId: (Auth.auth().currentUser?.uid)!, userImageUrl: (userDeatils?.profileimageUrl)!, user: (userDeatils?.name)!, onSuccessCallback: {
                
                   ProgressHUD.showSuccess("Your story has been uploaded successfully")
                
            }, onerrorCallback: { (error) in
                
                ProgressHUD.showError(error)

            })
           
        }
        
        
        
    }
}



extension ProfileViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        dismiss(animated: true) {
        self.isReload = false
        self.performSegue(withIdentifier: "showStoryvcsegueID", sender: info[UIImagePickerControllerOriginalImage] as? UIImage)
        }
    }
}

extension  ProfileViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MymediaCollectionViewCell", for: indexPath) as! MymediaCollectionViewCell
        if let imageUrl = postDetails[indexPath.row].shareimageUrl {
            cell.myMediaImageView.sd_setImage(with: URL(string:imageUrl), placeholderImage: UIImage.init(named: "placeholder"))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = self.mymediaCollectionView.frame.size.width / 3
        return CGSize(width: height - 2, height: height - 2)
        
}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
    }
    
}
