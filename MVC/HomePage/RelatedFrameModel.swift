//
//  RelatedFrameModel.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/20.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit

class RelatedFrameModel: NSObject {
    var headerLabelFrame = CGRectZero
    
    var coverImageViewFrame = CGRectZero
    
    var contentTitleLabelFrame = CGRectZero
    
    var contentLabelFrame = CGRectZero
    
    var bottomBtnFrame = CGRectZero
    
    var cellHeight:CGFloat = 0
    
     init(model:RelatedContentModel) {
        //=====通用=====
        let margin:CGFloat = 15
        
        let headerX = margin
        let headerY:CGFloat = 10
        let headerW = screenW - 2*margin
        let headerH:CGFloat = 21
        
        headerLabelFrame = CGRectMake(headerX, headerY, headerW, headerH)
        
        //图片
        let imageX = margin
        let imageY = headerH + headerY + margin
        let imageW = screenW - 2*margin
        var imageH:CGFloat = 0
        
        //不同的图片个数对应的基本高度不同
        let H1:CGFloat = 200 //1
        let H2:CGFloat = 150 //2
        let H3:CGFloat = 100 //3
        
        //根据数据源模型图片数量来判断
        let count = model.contents!.count
        if count == 0{
            imageH = 0
        }
        else if count == 1 {
            imageH = H1
        }
        else if count == 2 || count == 4{
            imageH = H2*CGFloat(count/2)
        }else if  count == 3 || count >= 5{
            imageH = H3*CGFloat((count+2)/3)
        }
        coverImageViewFrame = CGRectMake(imageX, imageY, imageW, imageH)
        
        //标题
        let tilteX = margin
        let titleY = imageY + imageH
        let titleW = headerW
        let titleH = ToolManager.calulateStringSize(model.topic, maxW: titleW, maxH: 10000, fontSize: 21).height
        
        contentTitleLabelFrame = CGRectMake(tilteX, titleY, titleW, titleH)
        
        //内容
        let contentX = margin
        let contentY = titleY + titleH
        let contentW = headerW
        
        var contentH = ToolManager.calulateStringSize(model.summary, maxW: contentW,maxH: 10000, fontSize: 13).height
        if model.textContent != ""{
            contentH = ToolManager.calulateStringSize(model.textContent, maxW: contentW,maxH: 10000, fontSize: 13).height
        }
        
        contentLabelFrame = CGRectMake(contentX, contentY, contentW, contentH)
        
        //底部
        let buttonX:CGFloat = 0
        let buttonY = contentY + contentH
        let buttonW = screenW
        let buttonH:CGFloat = 30
        
        bottomBtnFrame = CGRectMake(buttonX, buttonY, buttonW, buttonH)
        
        cellHeight = buttonY + buttonH
        
        
    }
}
