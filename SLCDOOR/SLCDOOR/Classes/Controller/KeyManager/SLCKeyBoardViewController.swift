//
//  SLCKeyBoardViewController.swift
//  SLC
//
//  Created by 123 on 16/6/7.
//  Copyright © 2016年 WangLei. All rights reserved.
//

import UIKit
//- (void)layoutSubviews
//    {
//        [super layoutSubviews];
//        CGFloat imageW = self.bounds.size.width;
//        CGFloat imageH = imageW;
//        self.imageView.frame = CGRectMake(0, 0, imageW, imageH);
//        CGFloat titleY = imageH;
//        CGFloat titleW = imageW;
//        CGFloat titleH = self.bounds.size.height - titleY;
//        self.titleLabel.frame = CGRectMake(0, titleY, titleW, titleH);
//}
var vc :AnyObject!
class SLCKeyBoardViewController: UIViewController {
//    let keywordView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let array = ["2","2","2","2","2","2"]
        
        NSUserDefaults.standardUserDefaults().setObject(array, forKey: "array")
        view.backgroundColor = UIColor.purpleColor()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Reply, target: self, action: #selector(SLCQRViewController.close))
    }
    /**
     关闭
     */
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        customView()
    }

    func customView() {
        view.addSubview(titleLabel)
        view.addSubview(lostBtn)
        view.addSubview(deleteBtn)
        
        for i in 0 ..< 6 {
            let imageV = UIImageView(image: UIImage(named: "kongxin"))
            imageV.frame = CGRect(x:CGFloat( i * 30) + titleLabel.frame.minX + 12 , y: titleLabel.frame.maxY + 10, width: 15, height: 15)
            imageV.tag = 11 + i
            imageV.layer.cornerRadius = 15*0.5
            view.addSubview(imageV)
        }
        
        //键盘数组
        let btnArray = ["1","2","3","4","5","6","7","8","9","","0",""]
        //间隙
        let margin = SLCScreenW/10
        // 按钮宽、高
        let btnWH = 2*margin
        
        for i  in 0 ..< 4 {
            var btnMarginY:CGFloat = 0
            for j in 0 ..< 3 {
                let btn = UIButton(frame: CGRect(x: margin + btnMarginY , y: (titleLabel.frame.maxY+btnWH) + CGFloat(i) * (20 + btnWH )  , width: btnWH, height: btnWH))
                btnMarginY = btn.frame.maxX
//                btn.tag = i * 3 + j + 30
                btn.layer.borderWidth = 2
                btn.layer.cornerRadius = margin
                btn.titleLabel?.textAlignment = .Center
                btn.titleLabel?.font = UIFont.systemFontOfSize(28)
                btn.layer.borderColor = UIColor.whiteColor().CGColor
                btn.setTitle(btnArray[i * 3 + j], forState: UIControlState.Normal)
                btn.addTarget(self, action: #selector(SLCKeyBoardViewController.onClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                if (i == 3 && j == 0) || (i == 3 && j == 2) {
                    btn.hidden = true
                }
                view.addSubview(btn)
            }
        }
        lostBtn.SLC_AlignInner(type: SLC_AlignType.BottomLeft, referView: view, size: nil, offset: CGPoint(x: margin, y: -btnWH))
        deleteBtn.SLC_AlignInner(type: SLC_AlignType.BottomRight, referView: view, size: nil, offset: CGPoint(x: -margin, y: -btnWH))
    }
    
    var index = 0
    //数字按钮
    var passwordNum:NSMutableArray = []
    
    func onClick(sender: UIButton) {
        if passwordNum.count < 6 {
            let value = sender.titleLabel?.text
            passwordNum.addObject(value!)
            index = passwordNum.count
            let imageView = view.viewWithTag(10 + index) as! UIImageView
            imageView.backgroundColor = UIColor.blackColor()
        }
        if(passwordNum.count == 6){
            let passWord =  NSUserDefaults.standardUserDefaults().objectForKey("array") as! NSArray
            if passWord.isEqualToArray(passwordNum as [AnyObject]) {
                //密码正确
                print("密码正确")
                let firstVC = SLCFirstViewController()
                
                navigationController?.pushViewController(firstVC, animated: true)
            }else{
            
                print("密码错误")
                for _ in 0..<6 {
                    deleteBtnOnClick()
                }
            }
            
        }
        
    }
    //删除按钮
    
    func deleteBtnOnClick() {
        if passwordNum.count > 0 {
            let imageView = view.viewWithTag(10 + index) as! UIImageView
            passwordNum.removeLastObject()
            index = passwordNum.count
            imageView.backgroundColor = UIColor.clearColor()
        }
        
    }
    
    
    //手机丢失按钮
     func phoneLostBtn(){
        
    }

    //  MARK: - 懒加载
    /// 密码
    private lazy var titleLabel:UILabel = {
        let titleLabel = UILabel(frame: CGRect(x: SLCScreenW/2-95, y: 80, width: 190, height: 30))
        titleLabel.text = "请输入密码以进入设置"
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont.systemFontOfSize(17)
        return titleLabel
    }()
    /// 丢失按钮
    private lazy var lostBtn:UIButton = {
       let btn = UIButton()
        btn.setTitle("手机丢失", forState: UIControlState.Normal)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(SLCKeyBoardViewController.phoneLostBtn), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    /// 删除按钮
    private lazy var deleteBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("删除", forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(SLCKeyBoardViewController.deleteBtnOnClick), forControlEvents: UIControlEvents.TouchUpInside)
        btn.sizeToFit()
        return btn
    }()

}
