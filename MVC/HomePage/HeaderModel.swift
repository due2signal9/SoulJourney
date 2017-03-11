//
//  HeaderModel.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/18.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit

class HeaderModel: NSObject,YYModel{
    var advert_type = ""
    var id = ""
    var market = ""
    var open_in_browser = ""
    var target_id = ""
    var topic = ""
    var photo:PhotoModel? = nil
}
class PhotoModel:NSObject,YYModel{
    var caption = ""
    var height = ""
    var width = ""
    var photo_url = ""
}