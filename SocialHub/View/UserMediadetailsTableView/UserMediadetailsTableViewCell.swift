//
//  UserMediadetailsTableViewCell.swift
//  SocialHub
//
//  Created by GLB-312-PC on 29/03/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import UIKit

class UserMediadetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var postTimestampLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var userMediaPicture: UIImageView!
    @IBOutlet weak var userPicture: CustomImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    func checkDateofpost(dateofposted:Double)->String{
        let date = Date(timeIntervalSince1970: dateofposted)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation()! )
        //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }

}
