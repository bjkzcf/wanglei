//
//  AppDelegate.swift
//  SLC
//
//  Created by 123 on 16/6/6.
//  Copyright © 2016年 WangLei. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        let na = SLCNavigationController(rootViewController: SLCBluetoothViewController())
        window?.rootViewController = na
        window?.makeKeyAndVisible() 
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
//需要配置 build setting --custom fla--Debug -- -D DEBUG
//函数的默认值：如果调用者没有传递对应的参数，那么系统会使用默认值，如果调用者传递了参数，那么就会使用传递的参数
//由于编译器可以通过赋值的类型自动推导出数据的真实类型，所有在swift开发中，能不写数据类型就不要写数据也类型
/**
 泛型
 - parameter message:    T 传什么类型就是什么类型
 */
func WLLog<T>(message:T, methodName: String = #function, lineNumber: Int = #line) {
    #if DEBUG
        print("\(methodName)[\(lineNumber)]:\(message)")
    #endif
}

