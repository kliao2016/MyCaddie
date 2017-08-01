//
//  CourseInfoTableViewCell.swift
//  MyCaddie
//
//  Created by Kevin Liao on 7/31/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit

class CourseInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var roundNumber: UILabel!
    @IBOutlet weak var roundTees: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
