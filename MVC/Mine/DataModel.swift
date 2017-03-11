//
//  DataModel.swift
//  MyNotes
//
//  Created by 千锋1 on 16/9/18.
//  Copyright © 2016年 PengJiLi. All rights reserved.
//

import UIKit

class DataModel: NSObject {
    var title = ""
    var summary = ""
    var time = ""
    init(title:String?,summary:String?,time:String?) {
        
        self.title = title ?? ""
        self.summary = summary ?? ""
        self.time = time ?? ""
    }
}
