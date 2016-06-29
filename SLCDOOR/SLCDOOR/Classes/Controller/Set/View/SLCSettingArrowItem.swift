//
//  SLCSettingArrowItem.swift
//  SLC
//
//  Created by 123 on 16/6/15.
//  Copyright © 2016年 WangLei. All rights reserved.
//

import UIKit

class SLCSettingArrowItem: SLCSettingItem {

     var destVcClass :UIViewController?
    class func arrowItemWithIcon(icon:String?, title:String, destVcClass:UIViewController?) ->SLCSettingArrowItem {
        let item = SLCSettingArrowItem()
        item.icon = icon
        item.title = title
        item.destVcClass = destVcClass
        return item
    }
    class func arrowtemWithTitle(title:String, destVcClass:UIViewController?) ->SLCSettingArrowItem{
        return arrowItemWithIcon(nil, title: title, destVcClass: destVcClass)
    }
    class func arrowItemWithTitle(titile: String) ->SLCSettingArrowItem{
        return arrowItemWithIcon(nil, title: titile, destVcClass: nil)
    }
    
}
