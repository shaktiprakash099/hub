//
//  SearchViewController.swift
//  SocialHub
//
//  Created by GLB-312-PC on 13/03/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage
import SDWebImage
import CodableFirebase
import ProgressHUD

class SearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
    
   
    @IBOutlet weak var usersTableview: UITableView!
    
    var users = [Users]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchuserdetails()
        
       }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userProfileViewSegueID"{
            let userVC  = segue.destination as! UserProfileViewController
            userVC.userIdstring = sender as? String
    
        }
        
    }
    
      func fetchuserdetails(){
         self.usersTableview.isHidden = true
        ProgressHUD.show("Loading..", interaction: false)
    

        DispatchQueue.global(qos: .userInitiated).async {
               let userRef = FBdatabaseProvider.shareinstance.userRef
                userRef.queryOrderedByKey().observeSingleEvent(of: .value) { snapshots in
                
                var newItems: [Users] = []
                
                for item in snapshots.children {
                    let userdetails = Users(snapshot: item as! DataSnapshot)
                    newItems.append(userdetails)
                }
                
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                    self.users  =  newItems.filter({($0.userid != Auth.auth().currentUser?.uid )})
                    self.usersTableview.isHidden = false
                    self.usersTableview.reloadData()
                }
            }
        }
     
       
    }
    

    //MARK: TABLE VIERW DELEGATE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DicoveryTableViewCell", for: indexPath) as! DicoveryTableViewCell
        cell.userNameLabel.text = users[indexPath.row].name
        cell.userEmailLabel.text = users[indexPath.row].email
        if let imageUrl = users[indexPath.row].profileimageUrl {
             cell.userProfilePic.sd_setImage(with: URL(string:imageUrl), placeholderImage: UIImage.init(named: "defaultUser"))
        }
    
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let users = self.users[indexPath.row]
      self.performSegue(withIdentifier: "userProfileViewSegueID", sender: users.userid)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
