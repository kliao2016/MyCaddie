//
//  Courses.swift
//  MyCaddie
//
//  Created by Kevin Liao on 6/7/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import Foundation

class Course: NSObject {
    
    private var name: String?
    private var rating: String?
    private var slope: String?
    private var tees: String?
    
    public func getName() -> String {
        return self.name!
    }
    
    public func getRating() -> String {
        return self.rating!
    }
    
    public func getSlope() -> String {
        return self.slope!
    }
    
    public func getTees() -> String {
        return self.tees!
    }
    
    public func setName(name: String) {
        self.name = name
    }
    
    public func setRating(rating: String) {
        self.rating = rating
    }
    
    public func setSlope(slope: String) {
        self.slope = slope
    }
    
    public func setTees(tees: String) {
        self.tees = tees
    }
    
}
