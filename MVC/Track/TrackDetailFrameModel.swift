//
//  TrackDetailFrameModel.swift
//  SoulJourney
//
//  Created by PengJiLi on 16/10/28.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit

class TrackDetailFrameModel: NSObject {
    var topViewFrame = CGRectZero
    
    var collectionFrame = CGRectZero
    
    var titleFrame = CGRectZero
    
    var contentFrame = CGRectZero
    
    var moreBtnFrame = CGRectZero
    
    var cellHeight:CGFloat = 0
    
    init(model:TrackModel) {
        let bili = Double(model.contents![0].height)!/Double(model.contents![0].width)!
        
        let topX:CGFloat = 0
        let topY = topX
        let topW = screenW
        let topH = screenW*CGFloat(bili)
        
        topViewFrame = CGRectMake(topX, topY, topW, topH)
        
        let colX = topX
        let colY = topY + topH + 3
        let colW = screenW
        let colH:CGFloat = 80
        
        collectionFrame = CGRectMake(colX, colY, colW, colH)
        
        let titX:CGFloat = 10
        let titY = colY + colH + 5
        let titW = screenW-20
        let titH = ToolManager.calulateStringSize(model.topic, maxW: screenW-20, maxH: 10000, fontSize: 17).height
        
        titleFrame = CGRectMake(titX,titY,titW,titH)
        
        let contX = titX
        let contY = titY + titH + 5
        let contW = screenW - 20
        let contH = ToolManager.calulateStringSize(model.content, maxW: screenW-20, maxH: 10000, fontSize: 13).height
        
        contentFrame = CGRectMake(contX, contY, contW, contH)
        
        let moreX = titX
        let moreY = contY + contH + 5
        let moreW = screenW - 10
        let moreH:CGFloat = 20
        
        moreBtnFrame = CGRectMake(moreX, moreY, moreW, moreH)
     
        cellHeight = moreY + moreH
    }
}
