//
//  CantouchContentView.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/24.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit
import Kingfisher

class CantouchContentView: UIView {

   var imageView = UIImageView(image: UIImage(named: "fangzi"))
    var textLabel = UILabel()
    var subTextLabel = UILabel()
    var line = UIView()
    var contentImageView = UIImageView()
    var contentLabel = UILabel()
    
    var isHideLine = false{
        didSet{
            if isHideLine{
                self.line.hidden = true
            }
        }
    }
    
    var contentLabelHeight:CGFloat = 0
    
    var imageUrl = ""
    
    var isOpen = false{
        didSet{
            if isOpen{
                //let imgY = self.subTextLabel.frame.height+self.subTextLabel.frame.origin.y + 5
                self.contentImageView.frame = CGRectMake(0,50, screenW, screenW*0.6)
                self.contentLabel.frame = CGRectMake(10, 60+screenW*0.6, screenW-20, contentLabelHeight)
                //self.contentImageView.kf_setImageWithURL(NSURL(string: imageUrl)!, placeholderImage: nil)
                self.contentImageView.sd_setImageWithURL(NSURL(string: imageUrl)!, placeholderImage: nil)
                
                self.frame.size.height = 50 + 10 + contentLabelHeight
            }else{
                self.frame.size.height = self.subTextLabel.frame.height + self.subTextLabel.frame.origin.y + 5
                self.contentLabel.frame = CGRectZero
                self.contentImageView.frame = CGRectZero
            }
        }
    }
    
    var target:AnyObject?
    var action:Selector?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(textLabel)
        self.addSubview(imageView)
        self.addSubview(subTextLabel)
        //self.addSubview(line)
        self.addSubview(contentImageView)
        self.addSubview(contentLabel)
    }
    


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imgX:CGFloat = 10
        let imgY = imgX
        let imgW:CGFloat = 32
        let imgH = imgW
        
        
        self.imageView.frame = CGRectMake(imgX, imgY, imgW, imgH)
        self.imageView.center = CGPointMake(25, imgW/2)
        
        let txtX = imgX + imgW + 15
        let txtY = self.imageView.frame.origin.y
        let txtW = screenH - txtX - 15
        let txtH = imgH/2
        self.textLabel.frame = CGRectMake(txtX, txtY, txtW, txtH)
        
        let subX = txtX
        let subY = self.imageView.center.y + 5
        let subW = txtW
        let subH = txtH
        self.subTextLabel.frame = CGRectMake(subX, subY, subW, subH)
        
        self.line.frame = CGRectMake(imgX, self.frame.size.height-5, screenW - 20, 0.5)
        self.line.backgroundColor = UIColor.lightGrayColor()
        
    }
    func addTraget(target:AnyObject,action:Selector){
        self.target = target
        self.action = action
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.target != nil{
            self.target?.performSelector(self.action!, withObject: self)
        }
    }
}
