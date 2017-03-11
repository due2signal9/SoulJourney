//
//  RelatedModel.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/20.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit

class RelatedModel: NSObject,YYModel {
    var button_text = ""
    var models:[RelatedContentModel]?
    
    static func modelContainerPropertyGenericClass() -> [NSObject : AnyObject]! {
        return ["models":RelatedContentModel.self]
    }
}
class RelatedContentModel:NSObject,YYModel {
    var contents:[PhotoModel]?
    var district_id = ""
    var districts:[HomePageListModel]?
    var id = ""
    var summary = ""
    var topic = ""
    var textContent = ""
    var user:UserModel?
    static func modelContainerPropertyGenericClass() -> [NSObject : AnyObject]! {
        return ["districts":HomePageListModel.self,"contents":PhotoModel.self]
    }
    static func modelCustomPropertyMapper() -> [NSObject : AnyObject]! {
        return ["textContent":"description"]
    }
}
