//
//  HomePageModel.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/18.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit

class HomePageModel: NSObject,YYModel {
    var button_text = ""
    var name = ""
    var region = ""
    var destinations:[HomePageListModel]? = nil
    
    static func modelContainerPropertyGenericClass() -> [NSObject : AnyObject]! {
        return ["destinations":HomePageListModel.self]
    }
}