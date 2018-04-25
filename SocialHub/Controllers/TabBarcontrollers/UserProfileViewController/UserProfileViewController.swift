//
//  UserProfileViewController.swift
//  SocialHub
//
//  Created by GLB-312-PC on 23/03/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import ProgressHUD
import Quickblox
import QuickbloxWebRTC
class UserProfileViewController: UIViewController {

    @IBOutlet weak var userMediaDetailsCollectionView: UICollectionView!
    @IBOutlet weak var userMediaDetailsTableView: UITableView!
    @IBOutlet weak var messageButton: CustomButtom!
    @IBOutlet weak var followButton: CustomButtom!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var followingsCount: UILabel!
    @IBOutlet weak var postsCount: UILabel!
    @IBOutlet weak var userProfilepic: CustomImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userBiolabel: UILabel!
    var currentQuickblocksUser : QBUUser?
    var userDeatils : Users?
    var postDetails = [Posts]()
    var intUpdatedFollowersCount: Int = 0
    var userIdstring: String?
    override func viewDidLoad() {
        super.viewDidLoad()

       self.userMediaDetailsTableView.isHidden = true
        let userRef = FBdatabaseProvider.shareinstance.userRef
        userRef.child(userIdstring!).queryOrderedByKey().observeSingleEvent(of: .value) { (snapshots) in
            self.userDeatils = Users(snapshot: snapshots as! DataSnapshot)
            
             self.checkFollowingStatus()
            
            self.setUPUserDeatils()
     
        }
        userRef.removeAllObservers()
    }
    
    //MARK : show grid like structure
    @IBAction func showGridLikeStructure(_ sender: Any) {
          self.userMediaDetailsTableView.isHidden = true
          self.userMediaDetailsCollectionView.isHidden = false
        
    }
    
    // MARK: show list like structure
    @IBAction func showListLikeStructure(_ sender: Any) {
          self.userMediaDetailsTableView.isHidden = false
          self.userMediaDetailsCollectionView.isHidden = true
        
        
    }
    
    @IBAction func callingAction(_ sender: Any) {
        ProgressHUD.show("checking Network establishment")
        QBRequest.logIn(withUserLogin: (Auth.auth().currentUser?.uid)!, password: (Auth.auth().currentUser?.uid)!, successBlock: { (response, currentuser) in
            self.currentQuickblocksUser = currentuser;
            print("\(currentuser.login)")
            QBChat.instance.connect(with: currentuser, completion: { error in
                let userid:String = (self.userDeatils?.userid)!
            
                QBRequest.users(withLogins: [userid],page:nil, successBlock: { (responsss, p, users) in
                    print(users)
                    self.performSegue(withIdentifier: "showcallsegueID", sender: users)
                }, errorBlock: { (responseError) in
                    
                    print("error")
                })
                
            })
            
        }) { (error) in
            
            print("Error occred \(error )")
            
        }
        
        
        
//        self.performSegue(withIdentifier: "showcallsegueID", sender: nil)
    }
    //MARK: Prepare segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showcallsegueID"{
            let callVc = segue.destination as! CallViewController
            callVc.opponents = sender as? [QBUUser]
            callVc.curreentUser = self.currentQuickblocksUser
        }
    }
    
    func checkFollowingStatus() {
        let userId = Auth.auth().currentUser?.uid
        let userref = FBdatabaseProvider.shareinstance.userRef
        userref.child(userId!).child("following").queryOrderedByKey().observeSingleEvent(of: .value) { snapshot  in
            if let following = snapshot.value as? [String : AnyObject] {
                for (_, value) in following {
                    if value as? String == self.userIdstring {
                        
                       print("I am following ")
                        DispatchQueue.main.async {
                            self.followButton.isSelected = true
                        }
                        break
                    }
                    else{
                       
                         print("I am not  following ")
                       
                    }
                }
            }
            
        }
        userref.removeAllObservers()
        
    }
    
    func setUPUserDeatils(){
        self.followButton.isSelected = false
        self.userEmail.text = userDeatils?.email
        self.userNameLabel.text = userDeatils?.name
        
        if let imageUrl = userDeatils?.profileimageUrl{
            self.userProfilepic.sd_setImage(with: URL(string:imageUrl), placeholderImage: UIImage.init(named: "defaultUser"))
        }
        
        if let followers = userDeatils?.followers{
            self.followersCount.text = "\(followers.count)"
            intUpdatedFollowersCount = followers.count
        }
        else{
             self.followersCount.text = "0"
             intUpdatedFollowersCount = 0
        }
     
        if let posts = userDeatils?.posts{
            self.postsCount.text = "\(posts.count)"
            self.fetchUserMediadetails()
        }
        else{
               self.postsCount.text = "0"
        }
        if let followings = userDeatils?.following{
            self.followingsCount.text = "\(followings.count)"
        }
        else{
             self.followingsCount.text  = "0"
        }
    }
    
    func fetchUserMediadetails(){
        ProgressHUD.show("fetching user media details ..", interaction: false)
        DispatchQueue.global(qos: .userInitiated).async {
            let userRef = FBdatabaseProvider.shareinstance.userRef
            userRef .child(self.userIdstring!).child(Constants.POSTS).queryOrderedByKey().observeSingleEvent(of: .value) { (snapshots ) in
                var postsItem : [Posts] = []
                for post in snapshots.children{
                    print("\(post)")
                    let postDetail = Posts(snapshots: post as! DataSnapshot)
                    postsItem.append(postDetail)
                }
                
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                    self.postDetails = postsItem
                    self.userMediaDetailsCollectionView.reloadData()
                    self.userMediaDetailsTableView.reloadData()
                }
                
            }
            userRef.removeAllObservers()
        }
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func followUnfollowAction(_ sender: Any) {
        let uid = Auth.auth().currentUser!.uid
        let userref = FBdatabaseProvider.shareinstance.userRef
        let key = userref.childByAutoId().key
        
        var isFollower = false
      userref.child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (ke, value) in following {
                    if value as? String == self.userIdstring{
                        isFollower = true
                        (sender as! UIButton).isSelected = false
                        userref.child(uid).child("following/\(ke)").removeValue()
                        userref.child(self.userIdstring!).child("followers/\(ke)").removeValue()
                        if let followers = self.userDeatils?.followers{
                            self.intUpdatedFollowersCount = self.intUpdatedFollowersCount - 1
                            self.followersCount.text = "\( self.intUpdatedFollowersCount )"
                        }
                        else{
                             self.intUpdatedFollowersCount = self.intUpdatedFollowersCount - 1
                            self.followersCount.text = "\( self.intUpdatedFollowersCount)"
                        }
                    }
                }
            }
            if !isFollower {
                let following = ["following/\(key)" : self.userIdstring]
                let followers = ["followers/\(key)" : uid]
                 (sender as! UIButton).isSelected = true
                userref.child(uid).updateChildValues(following)
                userref.child(self.userIdstring!).updateChildValues(followers)
                if let followers = self.userDeatils?.followers{
                    self.intUpdatedFollowersCount = self.intUpdatedFollowersCount + 1
                    self.followersCount.text = "\( self.intUpdatedFollowersCount )"
                }
                else{
                    self.intUpdatedFollowersCount = self.intUpdatedFollowersCount + 1
                    self.followersCount.text = "\( self.intUpdatedFollowersCount )"
                }
                
            }
        })
        userref.removeAllObservers()
        
    
    }
    
}
extension  UserProfileViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UsermediaDetailsCollectionViewCell", for: indexPath) as! UsermediaDetailsCollectionViewCell
        if let imageUrl = postDetails[indexPath.row].shareimageUrl {
            cell.usermediaImageView.sd_setImage(with: URL(string:imageUrl), placeholderImage: UIImage.init(named: "placeholder"))
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
        
        let height = self.userMediaDetailsCollectionView.frame.size.width / 3
        return CGSize(width: height - 2, height: height - 2)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.userMediaDetailsCollectionView.isHidden = true
        self.userMediaDetailsTableView.isHidden = false
        self.autoscrollMediatableView(row: indexPath.row, section: 0)
        

    }
    func autoscrollMediatableView(row: Int,section:Int){
        let indexPath = IndexPath(row: row, section: section)
        self.userMediaDetailsTableView.scrollToRow(at: indexPath, at: .top, animated: true)
       
        
    }
    
}
extension UserProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return postDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "UserMediadetailsTableViewCell", for: indexPath) as! UserMediadetailsTableViewCell
        self.userNameLabel.text = userDeatils?.name
        
        if let userimageUrl = userDeatils?.profileimageUrl{
            cell.userPicture.sd_setImage(with: URL(string:userimageUrl), placeholderImage: UIImage.init(named: "defaultUser"))
        }
        cell.usernameLabel.text = userDeatils?.name
        if let imageUrl = postDetails[indexPath.row].shareimageUrl {
            cell.userMediaPicture.sd_setImage(with: URL(string:imageUrl), placeholderImage: UIImage.init(named: "placeholder"))
        }
        if let currentTime = postDetails[indexPath.row].postTimeStamp{
            
            cell.postTimestampLabel.text = cell.checkDateofpost(dateofposted: currentTime)
        }
        else{
              cell.postTimestampLabel.text = "2 days ago"
        }
        cell.captionLabel.text = postDetails[indexPath.row].shareimagecaption
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300 ;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
}
