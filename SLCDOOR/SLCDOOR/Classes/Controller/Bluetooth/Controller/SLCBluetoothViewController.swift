//
//  SLCBluetoothViewController.swift
//  SLCDOOR
//
//  Created by 123 on 16/6/29.
//  Copyright © 2016年 WangLei. All rights reserved.
//

import UIKit
import CoreBluetooth

let BluetoothViewControllerChannnel = "BluetoothViewControllerChannnel"

class SLCBluetoothViewController: UITableViewController {
    var bluetoothManager = BluetoothManager.shareManager(BluetoothViewControllerChannnel)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        view.backgroundColor = UIColor.darkGrayColor()
        // 初始化刷新
        refreshControl = XMGRefreshControl()
        /*
         1.UIRefreshControl只要拉到一定程度无论是否松手会都触发下拉事件
         2.触发下拉时间之后, 菊花不会自动隐藏
         3.想让菊花消失必须手动调用endRefreshing()
         4.只要调用beginRefreshing, 那么菊花就会自动显示
         5.如果是通过beginRefreshing显示菊花, 不会触发下拉事件
         */
        refreshControl?.addTarget(self, action: #selector(SLCBluetoothViewController.loadData), forControlEvents: UIControlEvents.ValueChanged)
//        refreshControl?.beginRefreshing()
    }
    func loadData() {
        WLLog("jizai")
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        bluetoothManager = BluetoothManager.shareManager(BluetoothViewControllerChannnel)
        delegate()
    }
    
    private func setupNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
         navigationItem.title = "附近的开门器"
    }
    @objc private func history() {
        WLLog("history")
    }
    private func delegate() {
        //发现设备，插入
        bluetoothManager.bluetoothDidDiscoverPeripheral { (central, peripheral, advertisementData, RSSI, channel) in
            if peripheral.name!.hasPrefix("") {
                self.insertTable(peripheral, advertisementData: advertisementData)
            }
        }
        bluetoothManager.bluetoothdidDiscoverServices { (peripheral, error, channel) in
            guard error == nil else{
                WLLog("Error discover services:\(error?.localizedDescription)")
                return
            }
            for service in peripheral.services! {
                if service.UUID.isEqual(CBUUID(string: "设备服务的UUID")) {
                self.bluetoothManager.bluetoothdiscoverCharacteristics(nil, forService: service)
                }
            }
        }
        //已经发现特征 对不同的特征发送不同的指令
        bluetoothManager.bluetoothdidDiscoverCharacteristicsForService { (peripheral, service, error, channel) in
            guard error == nil else {
                WLLog("DiscoverCharactersFor\(service.UUID.description)")
                return
            }
            for characters in service.characteristics! {
                switch characters.UUID.description {
                case "" : break
                default : break
                }
            }
        }
        //发送指令后，对于不同的特征，接收到不同的返回数据
        bluetoothManager.bluetoothdidUpdateValueForCharacteristic { (peripheral, characteristic, error, channel) in
            switch characteristic.UUID.description {
            case "" : break
            default : break
            }
        }
    }
    
    private func insertTable(peripheral: CBPeripheral, advertisementData: [String : AnyObject]){
        let historyArr = NSMutableArray()
        let newArry = NSMutableArray()
        guard !(peripherals.containsObject(peripheral)) else{
            return
        }
        
        var indexPaths = [NSIndexPath]()
        peripherals.addObject(peripheral)
        //第一次连接
        if connectAllPeripherals.count == 0 {
            let indexPath = NSIndexPath(forRow: peripherals.count, inSection: 0)
            indexPaths.append(indexPath)
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
            status.advertisementData = advertisementData
            status.peripheral = peripheral
            peripheralArray.addObject(status)
        }else{
            //是否是连结过的
            if connectAllPeripherals.containsObject(peripheral) {
                let indexPath = NSIndexPath(forRow: peripherals.count, inSection: 0)
                indexPaths.append(indexPath)
                status.advertisementData = advertisementData
                status.peripheral = peripheral
                historyArr.addObject(status)
                peripheralArray.insertObject(historyArr, atIndex: 0)
            }else{
                let indexPath = NSIndexPath(forRow: peripherals.count, inSection: 1)
                indexPaths.append(indexPath)
                status.advertisementData = advertisementData
                status.peripheral = peripheral
                newArry.addObject(status)
                peripheralArray.insertObject(newArry, atIndex: 1)
            }
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
    }
    /**
     连接设备
     */
    func  bluetoothconnectPeripheral(peripheral: CBPeripheral, options: [String : AnyObject]?) {
        dispatch_async(dispatch_get_main_queue(), {
            self.bluetoothManager.bluetoothconnectPeripheral(peripheral, options: nil, success: { (central, peripheral, channel) in
                print("连接成功")
                dispatch_async(dispatch_get_main_queue(), {
                    self.bluetoothManager.bluetoothstopScan()
                    NSLog("停止扫描")
                    self.bluetoothManager.bluetoothdiscoverServices(nil)
                })
                }, failure: { (central, peripheral, error, channel) in
                    print("连接失败")
            })
        })
        
    }

   //MARK:懒加载
    /// 发现所有的设备
    private lazy var status = SLCKeys()
    private lazy var peripherals = NSMutableArray()
    /// 数据源
    private lazy var peripheralArray = NSMutableArray()
    /// 广播包
    private lazy var historyPheripheralAD = NSMutableArray()
    private lazy var newPeripheralsAD = NSMutableArray()
    /// 已连接设备
    private lazy var historyPheripheralArr = NSMutableArray()
    /// 搜索到未连接设备
    private lazy var newPeripheralsArr = NSMutableArray()
    //TODO:数据库？？？？
    /// 曾经所有连接设备
    private lazy var connectAllPeripherals : NSArray = {
        let defaults = NSUserDefaults.standardUserDefaults()
        let connectAllPeripherals = defaults.objectForKey("connectAllPeripherals") as! NSArray
        return connectAllPeripherals
    }()
    private lazy var rightBtn :UIButton = {
        let btn = UIButton(type: UIButtonType.Custom)
        btn.bounds = CGRect(x: 0, y: 0, width: 35, height: 35)
        btn.addTarget(self, action: #selector(SLCBluetoothViewController.history), forControlEvents: UIControlEvents.TouchUpInside)
        btn.setImage(UIImage(named: "history"), forState: UIControlState.Normal)
        return btn
    }()
}

// MARK: - TableView
extension SLCBluetoothViewController {
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let num = peripheralArray.count > 0 ? peripheralArray.count : 1
        return num
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return peripheralArray[section].row
        return 3
    }
  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "reuseIdentifier"
        var cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        if peripheralArray.count > 0 {
            let statu = peripheralArray[indexPath.section][indexPath.row] as! SLCKeys
            let peripheral = statu.peripheral!
            let ad :NSDictionary = statu.advertisementData
            
            //peripheral的显示名称,优先用kCBAdvDataLocalName的定义，若没有再使用peripheral name
            //蓝牙名字
            let localName:String?
            if ((ad.objectForKey("kCBAdvDataLocalName")) != nil) {
                localName = ad.objectForKey("kCBAdvDataLocalName") as? String
            }else{
                localName = peripheral.name
            }
            cell.textLabel?.text = localName

        }
        cell.textLabel?.text = "DOOR"
        cell.imageView?.image = UIImage(named: "device")
        cell.backgroundColor = UIColor.darkGrayColor()
        return cell
     }
    
    //MARK: -Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        WLLog(indexPath)
//        let peripheral = peripheralArray[indexPath.section][indexPath.row] as! CBPeripheral
//        self.bluetoothconnectPeripheral(peripheral, options: nil)
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title :String?
        if peripheralArray.count == 0 {
            title = "陌生的开门器"
        }else{
            if section == 0 {
                title = "曾用的开门器"
            }else{
                title = "陌生的开门器"
            }
        }
        return title
    }
    
}
