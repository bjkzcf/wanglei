//
//  SLCSettingLabelItem.swift
//  SLC
//
//  Created by 123 on 16/6/21.
//  Copyright © 2016年 WangLei. All rights reserved.
//

import UIKit

class SLCSettingLabelItem: SLCSettingItem {

    var detailTitle :String?
    class func labelItemWithIcon(icon:String?, title:String, detailTitle:String) ->SLCSettingLabelItem{
        let item = SLCSettingLabelItem()
        item.icon = icon
        item.title = title
        item.detailTitle = detailTitle
        return item
    }
    class func labelItemWithTitle(title:String, detailTitle:String) ->SLCSettingLabelItem{
        return labelItemWithIcon(nil, title: title, detailTitle: detailTitle)
    }

}
