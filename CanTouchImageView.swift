//
//  CanTouchImageView.swift
//  MovieFansDemo1
//
//  Created by 千锋 on 16/10/13.
//  Copyright © 2016年 琼极无限. All rights reserved.
//

import UIKit

class CanTouchImageView: UIImageView {

    //MARK: - 属性
    var target:AnyObject?
    var action:Selector?
    
    //添加事件
    func addtarget(target:AnyObject,action:Selector){
        //打开用户交互
        self.userInteractionEnabled = true
        //
        self.target = target
        self.action = action
    }
    //
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.target != nil {
            self.target?.performSelector(self.action!, withObject: self)
        }
    }

}
