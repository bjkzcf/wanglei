//
//  SLCSettingItem.swift
//  SLC
//
//  Created by 123 on 16/6/15.
//  Copyright © 2016年 WangLei. All rights reserved.
//

import Foundation

class SLCSettingItem: NSObject {

    var title:String!
    var icon :String!

    var optionalBlock :(() ->())!
    

    class func itemWithIcon(icon:String?, title:String) ->AnyObject{
        let item = SLCSettingItem()
        item.icon = icon
        item.title = title
        return item
    }
    
    class func itemWithTitle(title:String) ->AnyObject {
        return itemWithIcon(nil, title: title)
    }
    
}
