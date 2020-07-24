//
//  FriendTableViewCell.swift
//  StayInTouch
//
//  Created by Jennifer Liang on 2020-07-23.
//  Copyright © 2020 Jennifer Liang. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //print("hi")
        // Configure the view for the selected state
    }
    
}
