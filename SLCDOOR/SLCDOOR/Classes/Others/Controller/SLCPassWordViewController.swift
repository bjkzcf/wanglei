//
//  SLCPassWordViewController.swift
//  SLC
//
//  Created by 123 on 16/6/7.
//  Copyright © 2016年 WangLei. All rights reserved.
//

import UIKit

class SLCPassWordViewController: UIViewController {
    var index = 0
    @IBOutlet weak var pwImageView: UIImageView!
    
    //数字按钮
    var passwordNum:NSMutableArray = []
    
    @IBAction func numBtn(sender: UIButton) {
        if passwordNum.count < 6 {
            let value = sender.titleLabel?.text
            passwordNum.addObject(value!)
            index = passwordNum.count
            let imageView = view.viewWithTag(10 + index) as! UIImageView
            imageView.backgroundColor = UIColor.blackColor()
        }
        if(passwordNum.count == 6){
          let passWord =  NSUserDefaults.standardUserDefaults().objectForKey("array") as! NSArray
            if passWord.isEqualToArray(passwordNum as [AnyObject]) {
                    //密码正确
                    print("密码正确")
            }else{
                
            }
        }
        
    }
    //删除按钮
    
    @IBAction func deleteBtn(sender: UIButton) {
        if passwordNum.count > 0 {
            let imageView = view.viewWithTag(10 + index) as! UIImageView
            passwordNum.removeLastObject()
            index = passwordNum.count
            imageView.backgroundColor = UIColor.clearColor()
        }
      
    }
    
    
    //手机丢失按钮
    @IBAction func phoneLostBtn(sender: UIButton){
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let array = ["1","2","3","4","5","6"]
        
        NSUserDefaults.standardUserDefaults().setObject(array, forKey: "array")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
