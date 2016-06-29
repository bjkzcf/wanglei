//
//  SLCHomeViewController.swift
//  SLC
//
//  Created by 123 on 16/6/6.
//  Copyright © 2016年 WangLei. All rights reserved.
//

import UIKit



class SLCHomeViewController: UIViewController {
    override func viewDidAppear(animated: Bool) {
            super.viewDidAppear(animated)
            configerUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.hidden = true
        
    }

    func configerUI() {
        view.addSubview(qrBtn)
        let margin: CGFloat = 20
        let height: CGFloat = (SLCScreenH - margin*7)/4
        let width: CGFloat = height
        let centerX: CGFloat = SLCScreenW/2
        let titleArray = ["First","Second","Third","Fourth"]
        
        for i in 0..<4 {
            let centerY:CGFloat = height*0.5 + 2*margin + CGFloat(i) * (height + margin)
            let btn = UIButton(type: .Custom)
            btn.setTitle(titleArray[i], forState: UIControlState.Normal)
            btn.addTarget(self, action: #selector(SLCHomeViewController.onClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            btn.bounds = CGRect(x: 0, y: 0, width: width, height: height)
            btn.center = CGPoint(x: centerX, y: centerY)
            btn.backgroundColor = UIColor.purpleColor()
            btn.layer.cornerRadius = width*0.5
            btn.tag = 10 + i
            view.addSubview(btn)
        
        }
    }
    
    func btnOnClick() {
        let qrVC = SLCQRViewController()
        let nav = UINavigationController(rootViewController: qrVC)
        presentViewController(nav, animated: true, completion: nil)
        
    }
   
    func onClick(btn: UIButton){
        let firstVC = SLCFirstViewController()
        let secondVC = SLCSecondViewController()
        
        
        switch btn.tag {
        case 10:
//            let nav = UINavigationController(rootViewController: firstVC)
//            presentViewController(nav, animated: true, completion: nil)
            navigationController?.pushViewController(firstVC, animated: true)
        case 11:
            navigationController?.pushViewController(secondVC, animated: true)
        default: break
            
        }
    }
    //MARK: --懒加载
    private lazy var qrBtn:UIButton = {
        /// 二维码
        let qrBtn:UIButton = UIButton(type: UIButtonType.Custom)
        qrBtn.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        qrBtn.center = CGPoint(x: SLCScreenW-60, y: SLCScreenH-60)
        qrBtn.setBackgroundImage(R.image.erweima, forState: UIControlState.Normal)
        qrBtn.addTarget(self, action:#selector(SLCHomeViewController.btnOnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return qrBtn
    }()
 }

        
    


