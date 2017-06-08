//
//  ScorecardScroll.swift
//  MyCaddie
//
//  Created by Kevin Liao on 6/6/17.
//  Copyright © 2017 Liao & Mauz. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import UIKit

class ScorecardScroll: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    lazy var VCArray: [UIViewController] = {
        return [self.VCInstance(name: "FrontNine"), self.VCInstance(name: "BackNine")]
    }()
    
    private func VCInstance(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        if let firstScroll = VCArray.first{
            setViewControllers([firstScroll], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            }
            else if view is UIPageControl {
                view.backgroundColor = UIColor.clear
            }
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCArray.index(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return VCArray.last
        }
        
        guard VCArray.count > previousIndex else {
            return nil
        }
        
        return VCArray[previousIndex]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        guard let viewControllerIndex = VCArray.index(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < VCArray.count else {
            return VCArray.first
        }
        
        guard VCArray.count > nextIndex else {
            return nil
        }
        
        return VCArray[nextIndex]
    }
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return VCArray.count
    }
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int{
        guard let ScorecardScroll = viewControllers?.first, let firstViewControllerIndex = VCArray.index(of: ScorecardScroll) else {
            return 0
        }
        return firstViewControllerIndex
    }
    
    
}
