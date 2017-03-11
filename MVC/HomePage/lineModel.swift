//
//  lineModel.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/19.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit

class lineModel: NSObject,YYModel {
    var created_at = ""
    var days:[DayModel]?
    var days_count = ""
    var destination:HomePageListModel?
    var destination_id = ""
    var id = ""
    var photo = PhotoModel()
    var title = ""
     static func modelContainerPropertyGenericClass() -> [NSObject : AnyObject]! {
        return ["days":DayModel.self]
    }
}
class DayModel:NSObject,YYModel {
    var content = ""
    var id = ""
    var plan_id = ""
    var points = [PointModel]()
    var position = ""
    static func modelContainerPropertyGenericClass() -> [NSObject : AnyObject]! {
        return ["points":PointModel.self]
    }
    static func modelCustomPropertyMapper() -> [NSObject : AnyObject]! {
        return ["content":"description"]
    }
}
class PointModel: NSObject,YYModel{
    var id = ""
    var inspiration_activity:InspirationModel?
    var is_custom = false
    var position = ""
    var time_cost = ""
    var poi:PoiModel?
}
class InspirationModel :NSObject,YYModel{
    var activity_collections:[CollectionsModel]?
    var address = ""
    var destination:HomePageListModel?
    var id = ""
    var introduce = ""
    var photo:PhotoModel?
    var price = 0
    var time_cost = 0
    var topic = ""
    var visit_tip = ""
    
     static func modelContainerPropertyGenericClass() -> [NSObject : AnyObject]! {
        return ["activity_collections":CollectionsModel.self]
    }
}
///地名和ID
class CollectionsModel:NSObject,YYModel{
    var id = ""
    var topic = ""
}
class PoiModel:NSObject,YYModel{
    var address = ""
    var blat = ""
    var blng = ""
    var business_id = ""
    var district_id = ""
    var h5_url = ""
    var id = ""
    var lat = ""
    var lng = ""
    var name = ""
    var youji_poi_id = ""
}