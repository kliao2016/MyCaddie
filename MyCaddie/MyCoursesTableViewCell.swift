//
//  MyCoursesTableViewCell.swift
//  MyCaddie
//
//  Created by Kevin Liao on 7/22/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import UIKit

class MyCoursesTableViewCell: UITableViewCell {

    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var courseName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.courseImage.contentMode = .scaleAspectFill
        self.courseImage.layer.cornerRadius = self.courseImage.frame.size.width / 2
        self.courseImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
