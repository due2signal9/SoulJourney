//
//  HomePageListModel.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/18.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit

class HomePageListModel: NSObject,YYModel {
    var district_id = ""
    var has_airport = false
    var id = ""
    var is_in_china = true
    var lat = ""
    var lng = ""
    var level = ""
    var name = ""
    var name_en = ""
    var path = ""
    var photo:PhotoModel? = nil
    var published = true
    var score = ""
    var summary = ""
    var tip:String?
    var title = ""
    var visit_tip:String?
}
