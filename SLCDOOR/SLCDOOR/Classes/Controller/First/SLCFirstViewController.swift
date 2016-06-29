//
//  SLCFirstViewController.swift
//  SLC
//
//  Created by 123 on 16/6/6.
//  Copyright © 2016年 WangLei. All rights reserved.
//

import UIKit

class SLCFirstViewController: UIViewController {
    enum btnStatesEnum {
        /// 开门状态
        case DidOn
        /// 关门状态
        case DidOff
        /// 保持开门状态
        case DidLongOn
    }
    /// 当前状态
    var status : btnStatesEnum!
    
    var isSelected :Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.hidden = true
        customUI()
    }
    func customUI() {
       
        view.addSubview(titleLabal)
        view.addSubview(switchBtn)
        view.addSubview(setBtn)
        view.addSubview(seviceList)
        status = btnStatesEnum.DidOn
        WLLog("开门状态")
        seviceList.SLC_AlignInner(type: SLC_AlignType.BottomLeft, referView: view, size: CGSize(width:100,height:50),offset: CGPoint(x: 30, y: -50))
        setBtn.SLC_AlignInner(type: SLC_AlignType.BottomRight, referView: view, size: CGSize(width:100,height:50),offset: CGPoint(x: -30, y: -50))
        let btnW = SLCScreenW*2/3
        switchBtn.SLC_AlignInner(type: SLC_AlignType.Center, referView: self.view, size: CGSize(width: btnW, height:btnW))

    }
    //点击开关
    func onClick(btn :UIButton){
        if status == btnStatesEnum.DidOff || status == btnStatesEnum.DidLongOn {
            status = btnStatesEnum.DidOn
        }else{
            status = btnStatesEnum.DidOff
        }
        print(btnStatesEnum)
      btn.selected = !btn.selected
      isSelected = btn.selected
        if btn.selected {
            print("关门状态")
            btn.setBackgroundImage(UIImage(named: "zhuangtai"), forState: .Normal)
        }else{
            print("开门状态")
        }
    }
    //出发长按手势
    func longPress(longPress:UILongPressGestureRecognizer) {
        switch longPress.state {
        case UIGestureRecognizerState.Began:
            switchBtn.setBackgroundImage(UIImage(named: "zhuangtaichangan"), forState: UIControlState.Normal)
//            switchBtn.selected = false
            print("保持开门状态")
        case UIGestureRecognizerState.Ended:
            status = btnStatesEnum.DidLongOn
        default:
            break
        }
//        if longPress.state == UIGestureRecognizerState.Began {
//            status = btnStatesEnum.DidLongOn
//            switchBtn.setBackgroundImage(UIImage(named: "zhuangtaichangan"), forState: UIControlState.Normal)
//           switchBtn.selected = false
//        }
    }
    /**
     设备列表点击事件
     */
    func seviceListBtnClick() {
        print("--------")
        navigationController?.popViewControllerAnimated(true)
    }
    /**
     设置点击事件
     */
    func setBtnClick(){
        let second = SLCSecondViewController()
        
        navigationController?.pushViewController(second, animated: true)
    }
    //MARK:--懒加载
    /// 标题
    private lazy var titleLabal:UILabel = {
        let titleLabal = UILabel(frame: CGRect(x: 60, y: 30, width: SLCScreenW -  120, height: 40))
        titleLabal.font = UIFont.systemFontOfSize(24)
        titleLabal.text = "My exterior door"
        titleLabal.textAlignment = .Center
        titleLabal.textColor = UIColor.darkGrayColor()
        return titleLabal
    }()
    /// 开关
    private lazy var switchBtn :UIButton = {
        let switchBtn = UIButton(type: .Custom)
        switchBtn.adjustsImageWhenHighlighted = false
        switchBtn.setBackgroundImage(UIImage(named: "zhuangtai"), forState: UIControlState.Normal)
        switchBtn.setBackgroundImage(UIImage(named: "zhuangtaiHeightLight"), forState: UIControlState.Selected)
        switchBtn.addTarget(self, action:#selector(SLCFirstViewController.onClick(_:)) , forControlEvents: .TouchUpInside)
        //添加长按手势
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(SLCFirstViewController.longPress(_:)))
        longPress.minimumPressDuration = 1
        switchBtn.addGestureRecognizer(longPress)
        return switchBtn
    }()
    /// 设备列表
    private lazy var seviceList:UIButton = {
        let btn = UIButton(type: .Custom)
        btn.set(image: UIImage(named: "shebeiliebiao"), title: "设备列表", titlePosition: UIViewContentMode.Bottom, additionalSpacing: 10.0, state: UIControlState.Normal)
        btn.addTarget(self, action: #selector(SLCFirstViewController.seviceListBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    /// 后台设置
    private lazy var setBtn:UIButton = {
        let btn = UIButton(type: UIButtonType.Custom)
        btn.set(image: UIImage(named:"set"),title:"后台设置", titlePosition: UIViewContentMode.Bottom, additionalSpacing: 10.0, state: UIControlState.Normal)
        btn.addTarget(self, action: #selector(SLCFirstViewController.setBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()

}

