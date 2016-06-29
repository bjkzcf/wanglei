//
//  SLCSecondViewController.swift
//  SLC
//
//  Created by 123 on 16/6/6.
//  Copyright © 2016年 WangLei. All rights reserved.
//

import UIKit

class SLCSecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        title = "FRONT DOOR"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.hidden = false
        
        view.addSubview(keyManagerBtn)
        view.addSubview(setBtn)
        view.addSubview(timeList)
        timeList.SLC_AlignInner(type: SLC_AlignType.BottomLeft, referView: view, size: nil,offset: CGPoint(x: 30, y: -50))
        setBtn.SLC_AlignInner(type: SLC_AlignType.BottomRight, referView: view, size: CGSize(width:100,height:50),offset: CGPoint(x: -30, y: -50))
        let btnW = SLCScreenW*2/3
        keyManagerBtn.SLC_AlignInner(type: SLC_AlignType.Center, referView: self.view, size: CGSize(width: btnW, height:btnW))
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func btnOnclick(btn:UIButton) {
        let keyManager = SLCKeyManagerViewController()
        let history = SLCHistoryViewController()
        let set = SLCSetViewController()
        
        switch btn.tag {
        case 100: /// 钥匙管理
                navigationController?.pushViewController(keyManager, animated: true)
        case 101:/// 历史记录
                navigationController?.pushViewController(history, animated: true)
        case 102:/// 设置
//            let sb = UIStoryboard(name: "SLCSetViewController", bundle: nil)
//            let vc = sb.instantiateInitialViewController()
            
            navigationController?.pushViewController(set, animated: true)
        default:
            break
        }
    }

    // MARK: - 懒加载
    private lazy var keyManagerBtn:UIButton = {
        let btn = UIButton(type: UIButtonType.Custom)
        btn.setImage(UIImage(named: "keyManager"), forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(SLCSecondViewController.btnOnclick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btn.tag = 100
        return btn
    }()
    /// 历史记录
    private lazy var timeList:SLCButton = {
        let btn = SLCButton.createButton("历史记录", imageName: "lishijilu", target: self, action: #selector(SLCSecondViewController.btnOnclick(_:)))
        btn.tag = 101
        return btn
    }()
    /// 设置
    private lazy var setBtn:SLCButton = {
        let btn = SLCButton.createButton("设置", imageName: "set", target: self, action: #selector(SLCSecondViewController.btnOnclick(_:)))
        btn.tag = 102
        return btn
    }()

    

}
