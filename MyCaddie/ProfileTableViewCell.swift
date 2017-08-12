//
//  ProfileTableViewCell.swift
//  MyCaddie
//
//  Created by Kevin Liao on 8/12/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileCellLabel: UILabel!
    @IBOutlet weak var profileCellImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
