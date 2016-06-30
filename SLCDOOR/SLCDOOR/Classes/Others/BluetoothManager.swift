
//
//  BluetoothManager.swift
//  BluetoothManagerdanli
//
//  Created by xiaoniu on 16/4/20.
//  Copyright © 2016年 xieshizhi. All rights reserved.
//

import UIKit
import CoreBluetooth

enum statusenum {
    ///蓝牙已经打开
    case PoweredOn
    ///未授权
    case Unauthorized
    ///蓝牙已经关闭
    case PoweredOff
    ///中央管理器没有改变状态
    case UnknowCentral
}

class BluetoothManager: NSObject {
    private var manager: CBCentralManager!
    private var channel:AnyObject!
    private static let instance:BluetoothManager = BluetoothManager()
    ///保存搜到的蓝牙设备
    var deviceList = [CBPeripheral]()
    ///当前连接的设备
    var peripheral: CBPeripheral!
    var status: statusenum!
    ///写特征
    var writeCharacteristic: CBCharacteristic!
    
    ///单例 参数channel：区别哪个界面接收数据
    class func shareManager(channel: AnyObject) -> BluetoothManager {
        instance.channel = channel
        return instance
    }
    
    override init() {
        super.init()
        let options = [CBCentralManagerOptionShowPowerAlertKey : true , CBCentralManagerOptionRestoreIdentifierKey : "bluetoothRestore"]
        let backgroundModes = NSBundle.mainBundle().infoDictionary! as NSDictionary
        let modes = backgroundModes.objectForKey("UIBackgroundModes")
        if ((modes?.containsObject("bluetooth-central")) != nil) {
             NSLog("后台模式")
            manager = CBCentralManager(delegate: self, queue: nil, options: options)
        }else{
             NSLog("非后台模式")
            manager = CBCentralManager(delegate: self, queue: nil)
        }
        //TODO: 读取信号值
        peripheral.readRSSI()
    }
    
    ///检查运行这个App的设备是不是BLE
    func bluetoothcentralDidUpdateState(centralDidUpdateState:(status: statusenum, channel: AnyObject) -> ()) {
        self.centralDidUpdateState = centralDidUpdateState
    }
    
    ///扫描外设
    func bluetoothscanForPeripheralsWithServices(serviceUUIDs: [CBUUID]?, options: [String : AnyObject]?, compliant:(central: CBCentralManager, peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber, channel: AnyObject) -> ()) {
        self.didDiscoverPeripheral = compliant
        //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
        manager.scanForPeripheralsWithServices(serviceUUIDs, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
    }
    
    ///扫描到外设
    func bluetoothDidDiscoverPeripheral(didDiscoverPeripheral:(central: CBCentralManager, peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber, channel: AnyObject) -> ()) {
        self.didDiscoverPeripheral = didDiscoverPeripheral
    }
    
    ///连接外设
    func bluetoothconnectPeripheral(peripheral: CBPeripheral, options: [String : AnyObject]?, success:(central: CBCentralManager, peripheral: CBPeripheral, channel: AnyObject) -> (), failure:(central: CBCentralManager, peripheral: CBPeripheral, error: NSError?, channel: AnyObject) -> ()) {
        self.didConnectPeripheral = success
        self.didFailToConnectPeripheral = failure
        manager.connectPeripheral(peripheral, options: options)
    }
    ///读取RSSI
    func bluetoothDidReadRSSI(didReadRSSI:(peripheral: CBPeripheral,RSSI: NSNumber, error: NSError?) ->()){
        
        self.didReadRSSI = didReadRSSI
    }
    ///停止扫描外设
    func bluetoothstopScan() {
        manager.stopScan()
    }
    
    ///取消连接外设
    func bluetoothcancelPeripheralConnection() {
        if peripheral != nil {
            manager.cancelPeripheralConnection(peripheral)
        }
    }
    
    ///外设已断开连接
    func bluetoothdidDisconnectPeripheral(didDisconnectPeripheral:(central: CBCentralManager, peripheral: CBPeripheral, error: NSError?, channel: AnyObject) -> ()) {
        self.didDisconnectPeripheral = didDisconnectPeripheral
    }
    
    ///请求发现服务 serviceUUIDs为nil 默认发现所有服务
    func bluetoothdiscoverServices(serviceUUIDs: [CBUUID]?) {
        self.peripheral.discoverServices(serviceUUIDs)
    }
    
    ///已经发现服务 请求服务去发现特征
    func bluetoothdidDiscoverServices(didDiscoverServices:(peripheral: CBPeripheral, error: NSError?, channel: AnyObject) -> ()) {
        self.didDiscoverServices = didDiscoverServices
    }
    
    ///请求发现特征
    func bluetoothdiscoverCharacteristics(characteristicUUIDs: [CBUUID]?, forService: CBService) {
        peripheral.discoverCharacteristics(characteristicUUIDs, forService: forService)
    }
    
    ///已经发现特征 对不同的特征发送不同的指令
    func bluetoothdidDiscoverCharacteristicsForService(didDiscoverCharacteristicsForService:(peripheral: CBPeripheral, service: CBService, error: NSError?, channel: AnyObject) -> ()) {
        self.didDiscoverCharacteristicsForService = didDiscoverCharacteristicsForService
    }
    
    ///写入数据
    func bluetoothWritevalue(serviceUUID: String, characteristicUUID: String, peripheral: CBPeripheral!, data: NSData!) {
        peripheral.writeValue(data, forCharacteristic: self.writeCharacteristic, type: CBCharacteristicWriteType.WithResponse)
        print("手机向蓝牙发送的数据为:\(data)")
    }
    
    ///发送通知
    func bluetoothSetNotifyValue(enabled: Bool, forCharacteristic: CBCharacteristic) {
        peripheral.setNotifyValue(enabled, forCharacteristic: forCharacteristic)
    }
    
    ///读
    func bluetoothReadValueForCharacteristic(characteristic: CBCharacteristic) {
        peripheral.readValueForCharacteristic(characteristic)
    }
    
    ///发送指令后，对于不同的特征，接收到不同的返回数据
    func bluetoothdidUpdateValueForCharacteristic(didUpdateValueForCharacteristic:(peripheral: CBPeripheral, characteristic: CBCharacteristic, error: NSError?, channel: AnyObject) -> ()) {
        self.didUpdateValueForCharacteristic = didUpdateValueForCharacteristic
    }
    
    ///扫描到的设备添加到deviceList deviceList中已经存在的外设不再保存
    private func addPeripheralToDevicelist(peripheral: CBPeripheral) {
//        print("扫描到的peripheral:\(peripheral)")
        //查找到的设备是否在设备列表中
        if self.deviceList.count == 0 {
            self.deviceList.append(peripheral)
        }else {
            var nameArr1: [String] = []
            
            for device in self.deviceList {
                nameArr1.append(device.identifier.description)
            }
            if !nameArr1.contains(peripheral.identifier.description) {
                self.deviceList.append(peripheral)
            }
        }
    }
    
    private var didDiscoverPeripheral:((central: CBCentralManager, peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber, channel: AnyObject) -> ())!
    private var didConnectPeripheral:((central: CBCentralManager, peripheral: CBPeripheral, channel: AnyObject) -> ())!
    private var didFailToConnectPeripheral:((central: CBCentralManager, peripheral: CBPeripheral, error: NSError?, channel: AnyObject) -> ())!
    private var didDisconnectPeripheral:((central: CBCentralManager, peripheral: CBPeripheral, error: NSError?, channel: AnyObject) -> ())!
    private var didDiscoverServices:((peripheral: CBPeripheral, error: NSError?, channel: AnyObject) -> ())!
    private var didDiscoverCharacteristicsForService:((peripheral: CBPeripheral, service: CBService, error: NSError?, channel: AnyObject) -> ())!
    private var didUpdateValueForCharacteristic:((peripheral: CBPeripheral, characteristic: CBCharacteristic, error: NSError?, channel: AnyObject) -> ())!
    private var centralDidUpdateState:((status: statusenum, channel: AnyObject) -> ())!
    private var didReadRSSI:((peripheral: CBPeripheral,RSSI: NSNumber, error: NSError?) ->())!
}

extension BluetoothManager: CBCentralManagerDelegate {
    /**
     *  2 检查运行这个App的设备是不是BLE，代理方法
     */
    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch central.state {
        case CBCentralManagerState.PoweredOn:
            status = statusenum.PoweredOn
            print("蓝牙已经打开，请扫描外设")
            manager.scanForPeripheralsWithServices(nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
//            manager.stopScan()
        case CBCentralManagerState.Unauthorized:
            print("这个程序是无权使用蓝牙低功耗")
            status = statusenum.Unauthorized
        case CBCentralManagerState.PoweredOff:
            print("蓝牙目前已关闭")
            status = statusenum.PoweredOff
        default:
            print("中央管理器没有改变状态")
            status = statusenum.UnknowCentral
        }
        centralDidUpdateState?(status: status, channel: self.channel)
    }
    
    /**
     *  3 查到外设后，停止扫描，连接设备
     *  广播、扫描的响应数据保存在advertisementData 中，可以通过CBAdvertisementData 来访问它。
     */
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {

        //这里需要判断扫描到的设备是否是自己需要到
        addPeripheralToDevicelist(peripheral)
        didDiscoverPeripheral?(central: central, peripheral: peripheral, advertisementData: advertisementData, RSSI: RSSI, channel: self.channel)
        print("peripheral:\(peripheral.name)")
    }
    
    /**
     *  4.连接外设成功，开始发现服务
     */
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        self.peripheral = peripheral
        self.peripheral.delegate = self
        //连接外设成功 停止扫描
        self.manager.stopScan()
        didConnectPeripheral?(central: central, peripheral: peripheral, channel: self.channel)
    }
    
    /**
     *  连接外设失败
     */
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        didFailToConnectPeripheral?(central: central, peripheral: peripheral, error: error, channel: self.channel)
    }
    
    /**
     *  意外断开连接
     */
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        //断开连接 继续扫描
        self.manager.scanForPeripheralsWithServices(nil, options: nil)
        didDisconnectPeripheral?(central: central, peripheral: peripheral, error: error, channel: self.channel)
    }
}

extension BluetoothManager: CBPeripheralDelegate {
    /**
     *  5.请求周边去寻找它的服务所列出的特征
     */
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        didDiscoverServices?(peripheral: peripheral, error: error, channel: self.channel)
        if error != nil {
            print("错误的服务特征:\(error?.localizedDescription)")
            return
        }
        for service in peripheral.services! {
            let thisService = service as CBService
            peripheral.discoverCharacteristics(nil, forService: thisService)
        }
    }
    func peripheral(peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: NSError?) {
        if error != nil {
            print("错误的RSSI：\(error?.localizedDescription)")
            return
        }
        didReadRSSI?(peripheral: peripheral, RSSI: RSSI, error: error)
    }
    /**
     *  6.已搜索到Characteristics
     */
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        didDiscoverCharacteristicsForService?(peripheral: peripheral, service: service, error: error, channel: self.channel)
//        // 标识这个characteristic的属性是广播
//        CBCharacteristicPropertyBroadcast= 0x01,
//        // 标识这个characteristic的属性是读
//        CBCharacteristicPropertyRead= 0x02,
//        // 标识这个characteristic的属性是写-没有响应
//        CBCharacteristicPropertyWriteWithoutResponse= 0x04,
//        // 标识这个characteristic的属性是写
//        CBCharacteristicPropertyWrite= 0x08,
//        // 标识这个characteristic的属性是通知
//        CBCharacteristicPropertyNotify= 0x10,
//        // 标识这个characteristic的属性是声明
//        CBCharacteristicPropertyIndicate= 0x20,
//        // 标识这个characteristic的属性是通过验证的
//        CBCharacteristicPropertyAuthenticatedSignedWrites= 0x40,
//        // 标识这个characteristic的属性是拓展
//        CBCharacteristicPropertyExtendedProperties= 0x80,
//        // 标识这个characteristic的属性是需要加密的通知
//        CBCharacteristicPropertyNotifyEncryptionRequiredNS_ENUM_AVAILABLE(NA, 6_0)= 0x100,
//        // 标识这个characteristic的属性是需要加密的申明
//        CBCharacteristicPropertyIndicateEncryptionRequiredNS_ENUM_AVAILABLE(NA, 6_0)= 0x200
//        
//        CBCharacteristicPropertyBroadcast: 允许一个广播特性值,用于描述特性配置，不允许本地特性
//        CBCharacteristicPropertyRead: 允许读一个特性值
//        CBCharacteristicPropertyWriteWithoutResponse: 允许写一个特性值，没有反馈
//        CBCharacteristicPropertyWrite: 允许写一个特性值
//        CBCharacteristicPropertyNotify: 允许通知一个特性值，没有反馈
//        CBCharacteristicPropertyIndicate: 允许标识一个特性值
//        CBCharacteristicPropertyAuthenticatedSignedWrites: 允许签名一个可写的特性值
//        CBCharacteristicPropertyExtendedProperties: 如果设置后，附加特性属性为一个扩展的属性说明，不允许本地特性
//        CBCharacteristicPropertyNotifyEncryptionRequired: 如果设置后，仅允许信任的设备可以打开通知特性值
//        CBCharacteristicPropertyIndicateEncryptionRequired: 如果设置后，仅允许信任的设备可以打开标识特性值

        
//        最后一个参数是属性的读、写、加密权限，有以下几种：
//        
//        CBAttributePermissionsReadable
//        CBAttributePermissionsWriteable
//        CBAttributePermissionsReadEncryptionRequired
//        CBAttributePermissionsWriteEncryptionRequired
    }
    
    /**
     *  用于检测中心向外设写数据是否成功
     */
    func peripheral(peripheral: CBPeripheral, didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        print("didWriteValueForCharacteristic:\(characteristic)")
        if(error != nil){
            print("发送数据失败!error信息:\(error)")
        }else{
            print("发送数据成功\(characteristic)")
        }
    }
    
    /**
     *  7.这个是接收蓝牙通知，很少用。读取外设数据主要用下面那个方法didUpdateValueForCharacteristic。
     */
    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if error != nil {
            print("更改通知状态错误：\(error!.localizedDescription)")
        }
        print("收到的特性数据：\(characteristic.value)")
        //开始通知
        if characteristic.isNotifying {
            print("开始的通知\(characteristic)")
            peripheral.readValueForCharacteristic(characteristic)
        }else{
            //通知已停止
            //所有外设断开
            print("characteristic 不是 isNotifying 属性")
//            print("通知\(characteristic)已停止设备断开连接")
//            self.manager.cancelPeripheralConnection(self.peripheral)
        }
    }
    
    /**
     *  8.获取外设发来的数据，不论是read和notify,获取数据都是从这个方法中读取。
     */
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        didUpdateValueForCharacteristic?(peripheral: peripheral, characteristic: characteristic, error: error, channel: self.channel)
    }
    /**
     ios 8以前
     */
    func peripheralDidUpdateRSSI(peripheral: CBPeripheral, error: NSError?) {
//        if error != nil {
//            print("错误的RSSI：\(error?.localizedDescription)")
//            return
//        }
//        didReadRSSI?(peripheral: peripheral, error: error)
    }
    func peripheral(peripheral: CBPeripheral, didDiscoverDescriptorsForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        print("didDiscoverDescriptorsForCharacteristic:\(characteristic)")
        for descriptor in characteristic.descriptors! {
            print("descriptor:\(descriptor)")
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForDescriptor descriptor: CBDescriptor, error: NSError?) {
        print("didUpdateValueForDescriptor:\(descriptor.value)")
        

    }
    
    func peripheral(peripheral: CBPeripheral, didWriteValueForDescriptor descriptor: CBDescriptor, error: NSError?) {
        print("didWriteValueForDescriptor:\(descriptor)")
    }
    
}