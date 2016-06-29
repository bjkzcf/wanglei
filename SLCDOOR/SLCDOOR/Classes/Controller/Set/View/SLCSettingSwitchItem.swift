//
//  SLCSettingSwitchItem.swift
//  SLC
//
//  Created by 123 on 16/6/15.
//  Copyright © 2016年 WangLei. All rights reserved.
//

import UIKit

class SLCSettingSwitchItem: SLCSettingItem {

    class func switchItemWithIcon(icon:String?, title:String) ->SLCSettingSwitchItem{
        let item = SLCSettingSwitchItem()
        item.icon = icon
        item.title = title
        return item
    }
    class func switchItemWithTitle(title:String) ->SLCSettingSwitchItem {
        return switchItemWithIcon(nil, title: title)
    }
}
