//
//  ClassicLineDetailTableViewCell.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/24.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit

class ClassicLineDetailTableViewCell: UITableViewCell {
    //1.上方文本
    var topLabel = UILabel()
    
    //2.按钮视图
    var btnView = ButtonContentView()
    
    //3.数据模型
    var frameModel:ClassicLineDetailFrameModel? = nil {
        didSet{
            topLabel.frame = (frameModel?.topFrame)!
            topLabel.font = UIFont.systemFontOfSize(13)
            topLabel.numberOfLines = 0
            
            btnView.frame = frameModel!.btnFrame
        
            
        }
    }
    var dataModel:DayModel? = nil{
        didSet{
            topLabel.text = dataModel?.content
            
            btnView.titles = dataModel?.points
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(topLabel)
        self.contentView.addSubview(btnView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
