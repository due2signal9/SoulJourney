//
//  IdeaViewController.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/31.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit

class IdeaViewController: UIViewController {
    
    let textView = UITextView()
    
    let textField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationSetting()
        
        self.view.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 241/255, alpha: 1)
        self.title = "意见反馈"
        
        textView.frame = CGRectMake(0, 10, screenW, 150)
        
        self.view.addSubview(textView)
        
        textField.frame = CGRectMake(0, 170, screenW, 40)
        textField.placeholder = "  请留下你的QQ或Email"
        textField.backgroundColor = UIColor.whiteColor()
        textField.font = UIFont.systemFontOfSize(15)
        self.view.addSubview(textField)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func navigationSetting(){
        
        let barBtn = UIBarButtonItem(title: "发送", style: .Plain, target: self, action: #selector(IdeaViewController.sendAction))
        // barBtn.setTitleTextAttributes([NSFontAttributeName:UIColor(red: 21/255, green: 176/255, blue: 138/255, alpha: 0.8)], forState: .Normal)
        
        self.navigationItem.rightBarButtonItem = barBtn
    }
    
    func sendAction(){
        KVNProgress.showSuccessWithStatus("发送成功")
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    

}
