//
//  SLCSettingCell.swift
//  SLC
//
//  Created by 123 on 16/6/15.
//  Copyright © 2016年 WangLei. All rights reserved.
//

import UIKit

class SLCSettingCell: UITableViewCell {

    var item:SLCSettingItem?{
        didSet{
            //设置数据
            setupData()
            //设置右边数据
            setupRightContent()
        }
    }
    /**
     设置右边数据
     */
    func setupRightContent(){
        if item!.isKindOfClass(SLCSettingArrowItem) {
            accessoryView = arrowIv
        }else if item!.isKindOfClass(SLCSettingSwitchItem){
            // 恢复存储的状态
            switchBtn.on = NSUserDefaults.standardUserDefaults().boolForKey(item!.title!)
            accessoryView = switchBtn
            accessoryType = .None
            selectionStyle = .None
        }else if item!.isKindOfClass(SLCSettingLabelItem){
            let labelItem = item as! SLCSettingLabelItem
            labelView.text = labelItem.detailTitle
            accessoryView = labelView
            selectionStyle = .None
            accessoryType = .None
        }else{
            //防止循环引用
            accessoryView = nil
        }
        
    }
    /**
     设置数据
     */
    func setupData(){
        if let str = item?.icon {
            imageView?.image = UIImage(named: str)
        }
        textLabel?.text = item!.title
    }
  
    class func cellWithTableView(tableView:UITableView) ->SLCSettingCell {
        let settingReuseIdentifier = "SLCSettingReuseIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(settingReuseIdentifier) as? SLCSettingCell
        if cell == nil{
            cell = SLCSettingCell(style: UITableViewCellStyle.Default, reuseIdentifier: settingReuseIdentifier)
            
        }
                 return cell!
    }
    
    
    func switchBtnChange(){
        NSUserDefaults.standardUserDefaults().setBool(switchBtn.on, forKey: item!.title!)
    }
    //MARK:--懒加载
    /// 箭头
    private lazy var arrowIv : UIImageView = {
        let arrow = UIImageView(image: UIImage(named: "CellArrow"))
        return arrow
    }()
    /// 开关
    private lazy var switchBtn :UISwitch = {
        let switchBtn = UISwitch()
        switchBtn.addTarget(self, action: #selector(SLCSettingCell.switchBtnChange), forControlEvents: UIControlEvents.ValueChanged)
        return switchBtn
    }()
    /// 标签
    private lazy var labelView:UILabel = {
        let label = UILabel()
        label.bounds = CGRect(x: 0, y: 0, width: 80, height: 30)
        label.textAlignment = .Right
        return label
    }()

}