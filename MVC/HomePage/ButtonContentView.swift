//
//  ButtonContentView.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/24.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit

///通过点击改变Cell的高度
protocol ChangeCellHeight:class{
    func changeHeight(moreHeight:CGFloat,tag:Int,openArray:(Set<Int>,Set<Int>))
}


class ButtonContentView: UIView {
    
    
    weak var delegate:ChangeCellHeight?
    
    var openArray = Set<Int>(){
        didSet{
            for item in openArray{
                (self.subviews[item] as! CantouchContentView).isOpen = true
            }
        }
    }
    
    var closeArray = Set<Int>(){
        didSet{
            for item in closeArray{
                (self.subviews[item] as! CantouchContentView).isOpen = false
            }
        }
    }

    
    

    var titles:[PointModel]? = nil{
        didSet{
            //移除
            for item in self.subviews{
                item.removeFromSuperview()
            }
            
            for (i,item) in titles!.enumerate() {
                
                let contentView = CantouchContentView()
                contentView.tag = i
                
                contentView.textLabel.text = item.inspiration_activity?.topic
                contentView.textLabel.font = UIFont.boldSystemFontOfSize(15)
                
                
                
                let time = item.inspiration_activity?.visit_tip
                if time != ""{
                    contentView.subTextLabel.text = item.inspiration_activity!.destination!.name + "·" + "建议游玩\(time!)"
                }else{
                    
                    contentView.subTextLabel.text = item.inspiration_activity?.destination!.name
                }
                
                
                contentView.subTextLabel.font = UIFont.systemFontOfSize(12)
                contentView.subTextLabel.textColor = UIColor.lightGrayColor()
                
                
                let height = ToolManager.calulateStringSize(item.inspiration_activity!.introduce, maxW: screenW-20, maxH: 1000, fontSize: 13).height
                contentView.contentLabelHeight = height
                contentView.contentLabel.font = UIFont.systemFontOfSize(13)
                contentView.contentLabel.numberOfLines = 0
                contentView.contentLabel.text = item.inspiration_activity!.introduce
                
                contentView.imageUrl = item.inspiration_activity!.photo!.photo_url
                
                contentView.addTraget(self, action: "openDetail:")
                
                self.addSubview(contentView)
            }
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        var openCount = 0
        var otherHeight:CGFloat = 0
        for (i,item) in self.subviews.enumerate(){
            
            let Btn_W = self.frame.size.width
            let Btn_H = self.frame.size.height
            let count = CGFloat(self.subviews.count)
            
            let x:CGFloat = 0
            var y = CGFloat(i)*50
            let w = Btn_W - 10
            let h = Btn_H/count
            
            
            if openCount > 0{
                y = CGFloat(i)*50 + otherHeight
            }
            
            item.frame = CGRectMake(x, y, w, h)
            
            if (item as! CantouchContentView).isOpen {
                openCount += 1
                otherHeight += (item as! CantouchContentView).contentLabelHeight+screenW*0.6+15
            }
            
            if i == self.subviews.count - 1{
                (item as! CantouchContentView).isHideLine = true
            }
        }
    }
    func openDetail(btn:CantouchContentView){
            btn.isOpen = !btn.isOpen
        
            var moreHeight:CGFloat = 0
            //获取多出来的高度
//            for item in self.subviews{
//                if let btn = item as? CantouchContentView{
//                    if btn.isOpen{
//                        moreHeight += btn.contentLabelHeight + screenW*0.6 + 15
//                    }
//                }
//            }
        
            if btn.isOpen{
                moreHeight = btn.contentLabelHeight + screenW*0.6 + 15
                self.closeArray.remove(btn.tag)
                self.openArray.insert(btn.tag)
            }else{
                self.closeArray.insert(btn.tag)
                self.openArray.remove(btn.tag)
                moreHeight = -(btn.contentLabelHeight + screenW*0.6 + 15)
            }
        
            
            
            self.delegate?.changeHeight(moreHeight,tag: self.tag,openArray:(self.openArray,self.closeArray))
    }
}
