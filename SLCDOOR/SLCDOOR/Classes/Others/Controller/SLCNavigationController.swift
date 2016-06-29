//
//  SLCNavigationController.swift
//  SLC
//
//  Created by 123 on 16/6/6.
//  Copyright © 2016年 WangLei. All rights reserved.
//

import UIKit

class SLCNavigationController: UINavigationController {

    override class func initialize(){
        
//        let navBar = UINavigationBar.appearance()
//        navBar.backgroundColor = UIColor(red: 8/255.0, green: 65/255.0, blue: 68/255.0, alpha: 1.0)
//                navBar.tintColor = UIColor.whiteColor()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        
        let btn = UIButton(type: UIButtonType.Custom)
        btn.setImage(UIImage(named: "navigationButtonReturn"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "navigationButtonReturnClick"), forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(SLCNavigationController.popSelf), forControlEvents: UIControlEvents.TouchUpInside)
        btn.sizeToFit()
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
        
        super.pushViewController(viewController, animated: animated)
    }
    
    func popSelf() {
        popViewControllerAnimated(true)
    }
    
}
