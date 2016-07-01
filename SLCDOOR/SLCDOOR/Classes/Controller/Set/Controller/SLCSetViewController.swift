//
//  SLCSetViewController.swift
//  SLC
//
//  Created by 123 on 16/6/15.
//  Copyright © 2016年 WangLei. All rights reserved.
//

import UIKit
class SLCSetViewController: SLCBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addItems()
    }
    
    func addItems(){

        let item1 = SLCSettingLabelItem.labelItemWithTitle("FRONT DOOR", detailTitle: "1.1.1")
        let item2 = SLCSettingSwitchItem.switchItemWithIcon("sound_Effect", title: "断电常开")
        let item3 = SLCSettingArrowItem.arrowtemWithTitle("推送和提醒", destVcClass: SLCFirstViewController())
        let item4 = SLCSettingArrowItem.arrowtemWithTitle("开门密码", destVcClass: SLCFirstViewController())
        let item5 = SLCSettingArrowItem.arrowtemWithTitle("近距离自动控锁", destVcClass: SLCFirstViewController())
        let item6 = SLCSettingArrowItem.arrowItemWithTitle("声效")
        item6.optionalBlock = {
//            SVProgressHUD.showWithStatus("不同的声音")
            WLLog("声效")
        }
        let item7 = SLCSettingArrowItem.arrowtemWithTitle("门锁校对", destVcClass: SLCFirstViewController())
        let item8 = SLCSettingArrowItem.arrowtemWithTitle("匹配新设备", destVcClass: SLCFirstViewController())
        let item9 = SLCSettingArrowItem.arrowtemWithTitle("自动上锁时间", destVcClass: SLCFirstViewController())
        let item10 = SLCSettingArrowItem.arrowtemWithTitle("恢复出厂设置", destVcClass: SLCFirstViewController())
                let group = SLCSettingGroup()
        group.items = [item1,item2,item3,item4,item5,item6,item7,item8,item9,item10]
        dates.addObject(group)
    }
}
