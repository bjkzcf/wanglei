//
//  SLCButton.swift
//  SLC
//
//  Created by 123 on 16/6/15.
//  Copyright © 2016年 WangLei. All rights reserved.
//

import UIKit

class SLCButton: UIButton {
    /// 图标比例
    let SLCButtonImageRatio:CGFloat = 0.7
    class func createButton(title:String, imageName:String, target:AnyObject, action:Selector) ->SLCButton {
        let btn = SLCButton()
        btn.titleLabel?.font = UIFont.systemFontOfSize(14)
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        titleLabel?.textAlignment = .Center
//        imageView?.contentMode = UIViewContentMode.Center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        let imageH = contentRect.size.height * SLCButtonImageRatio
        let imageW = imageH
        let imageX = (contentRect.size.width - imageW)/2
        
//        adjustsImageWhenHighlighted = false
        return CGRect(x: imageX, y: 0, width: imageW, height: imageH)
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        let titleY = contentRect.size.height * SLCButtonImageRatio
        let titleW = contentRect.size.width
        let titleH = contentRect.size.height - titleY
        return CGRect(x: 0, y: titleY, width: titleW, height: titleH)
    }
}
