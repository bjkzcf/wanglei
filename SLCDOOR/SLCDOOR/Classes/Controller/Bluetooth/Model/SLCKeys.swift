//
//  SLCKeys.swift
//  SLCDOOR
//
//  Created by 123 on 16/6/29.
//  Copyright © 2016年 WangLei. All rights reserved.
//

import UIKit
import CoreBluetooth
class SLCKeys: NSObject {
    var peripheral: CBPeripheral?
    var advertisementData = [String :AnyObject]()
}
