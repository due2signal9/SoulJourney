//
//  TrackModel.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/18.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit

class TrackModel: NSObject,YYModel{
    var contents:[PhotoModel]? = nil
    var created_at = ""
    var content = ""
    //地区id
    var district_id = ""
    var districts:[DistrictModel]?
    var id = ""
    var likes_count = ""
    var topic = ""
    var user = UserModel()
    var parent_district_count = ""
    var parent_district_id = ""
    
    static func modelContainerPropertyGenericClass() -> [NSObject : AnyObject]! {
        return ["contents":PhotoModel.self,"districts":DistrictModel.self]
    }
    //将设置模型里面的值和json中的key值不同
    static func modelCustomPropertyMapper() -> [NSObject : AnyObject]! {
        return ["content":"description"]
    }
}
class DistrictModel:NSObject,YYModel {
    var destination_id = ""
    var id = ""
    var is_in_china = ""
    var is_valid_destination = ""
    var lat = ""
    var lng = ""
    var name = ""
    var name_en = ""
    var path = ""
    var published = ""
    var user_activities_count = ""
}
class UserModel: NSObject,YYModel {
    var gender = ""
    var id = ""
    var name = ""
    var photo_url = ""
}