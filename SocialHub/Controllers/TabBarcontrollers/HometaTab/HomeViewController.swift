//
//  HomeViewController.swift
//  SocialHub
//
//  Created by GLB-312-PC on 13/03/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import ProgressHUD

class HomeViewController: UIViewController {
    
    @IBOutlet weak var storyCollectionView: UICollectionView!
    var storyDetails = [Storys]()
    var Oparationqueue = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchstory()
    }
    deinit {
        print("HomeController deinitilized")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "storyDetailSegueID"{
            let  storyDetailsVC = segue.destination as! StoryDetailsViewController
            storyDetailsVC.storyDetails = sender as? Storys
        }
    }
    
    
    
    func  fetchstory(){

        ProgressHUD.show("Loading..", interaction: false)
        Oparationqueue = OperationQueue()
        
        
          Oparationqueue.addOperation {
            let storyRef = FBdatabaseProvider.shareinstance.storyRef
            storyRef.queryOrderedByKey().observeSingleEvent(of: .value) { (snapshots) in
                print("\(snapshots)")
                
                
                var newItems: [Storys] = []
                
                for item in snapshots.children {
                    let userdetails = Storys(snapshots: item as! DataSnapshot)
                    newItems.append(userdetails)
                }
                
                OperationQueue.main.addOperation {
                     ProgressHUD.dismiss()
                    self.storyDetails = newItems
                    self.storyCollectionView.reloadData()
                }
                
            }
           
        }
        
    }
    
  
    @IBAction func LogOutButtonAction(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            
            self.tabBarController?.dismiss(animated: true, completion:nil)
          
        } catch  let logouterror {
            
            print("\(logouterror)")
        }
        
    }
}
extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.storyDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryCollectionViewCell", for: indexPath) as! StoryCollectionViewCell
        if let storyImageUrl = self.storyDetails[indexPath.row].storyimageUrl{
            cell.userStoryImageView.sd_setImage(with: URL(string:storyImageUrl), placeholderImage: UIImage.init(named: "defaultUser"))

        }
        if let userImageUrl = self.storyDetails[indexPath.row].storyUserPicUrl{
              cell.userProfileImageView.sd_setImage(with: URL(string:userImageUrl), placeholderImage: UIImage.init(named: "defaultUser"))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storydetails = self.storyDetails[indexPath.row]
        self.performSegue(withIdentifier: "storyDetailSegueID", sender: storydetails)
    }
    
}
