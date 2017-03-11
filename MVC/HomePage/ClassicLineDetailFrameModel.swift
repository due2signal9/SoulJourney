//
//  ClassicLineDetailFrameModel.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/24.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit

class ClassicLineDetailFrameModel: NSObject {
    var topFrame = CGRectZero
    
    var btnFrame = CGRectZero
    
    
    var cellHeight:CGFloat = 0


    init(model:DayModel) {
        let top_X:CGFloat = 10
        let top_Y = top_X
        let W = screenW - 20
        let H = ToolManager.calulateStringSize(model.content, maxW: screenW-20, maxH: 10000, fontSize: 13).height
        topFrame = CGRectMake(top_X, top_Y, W, H)
        
        let btn_X:CGFloat = 0
        let btn_Y = H + top_Y + 15
        let btn_W = screenW
        let btn_H = CGFloat(model.points.count) * 50
        btnFrame = CGRectMake(btn_X, btn_Y, btn_W, btn_H)
        
        cellHeight = btn_Y + btn_H 
    }
}
