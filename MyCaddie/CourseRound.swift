//
//  Round.swift
//  MyCaddie
//
//  Created by Weston Mauz on 6/12/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import Foundation

class CourseRound: NSObject {
    
    var holeStats = HoleStats()
    
    var courseName = ""
    var tees = ""
    var greenBunkers = 0
    var fairwayBunkers = 0
    var hazards = 0
    var obs = 0
    var rights = false
    var lefts = false
    var fringes = 0
    var fairways = false
    var greensInReg = false    
}
