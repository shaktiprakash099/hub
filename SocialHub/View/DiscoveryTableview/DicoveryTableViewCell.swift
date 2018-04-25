//
//  DicoveryTableViewCell.swift
//  SocialHub
//
//  Created by GLB-312-PC on 19/03/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import UIKit

class DicoveryTableViewCell: UITableViewCell {

    @IBOutlet weak var userFollowUnfollowButton: UIButton!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userProfilePic: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateUI()
    }
    func updateUI(){
        
      self.userProfilePic.clipsToBounds = true
      self.userProfilePic.layer.cornerRadius = 25
      self.userProfilePic.layer.borderWidth = 2
      self.userProfilePic.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
