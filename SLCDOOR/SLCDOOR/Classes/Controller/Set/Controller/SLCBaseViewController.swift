//
//  SLCBaseViewController.swift
//  SLC
//
//  Created by 123 on 16/6/16.
//  Copyright © 2016年 WangLei. All rights reserved.
//

import UIKit

class SLCBaseViewController: UITableViewController {
//    var dates = []
    
    init() {
        super.init(style: UITableViewStyle.Grouped)
    }

    override init(style: UITableViewStyle) {
        super.init(style: UITableViewStyle.Grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.showsVerticalScrollIndicator = false
    }
   
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dates.count
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let group = dates[section] as! SLCSettingGroup
        return (group.items?.count)!
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
//        return (SLCScreenH-64)/10
//    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> SLCSettingCell {

        let cell = SLCSettingCell.cellWithTableView(tableView)
        let group = dates[indexPath.section] as! SLCSettingGroup
        let item = group.items![indexPath.row] as! SLCSettingItem
        cell.item = item
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //取消选中这行
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //模型数据
        let group = dates[indexPath.section] as! SLCSettingGroup
        let item =  group.items![indexPath.row] as! SLCSettingItem
        
        if (item.optionalBlock != nil) {
            item.optionalBlock()
        }else if item.isKindOfClass(SLCSettingArrowItem) {
            let arrowItem = item as! SLCSettingArrowItem
//            if arrowItem.destVcClass != nil {
                let vc = arrowItem.destVcClass
                navigationController?.pushViewController(vc!, animated: true)
//            }
        }
    }
   
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let group = dates[section] as! SLCSettingGroup
        return group.headerTitle
    }
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let group = dates[section] as! SLCSettingGroup
        return group.foorerTitle
    }
    
//    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return  0.00000001
//    }
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0.000001
//    }
    
 

    // MARK: - 懒加载
    /// 数据源
    lazy var dates  = NSMutableArray()
}