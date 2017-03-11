//
//  ImageCollectionViewCell.swift
//  MovieFansDemo1
//
//  Created by 千锋 on 16/10/13.
//  Copyright © 2016年 琼极无限. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    var imageSize = CGSizeZero
    
    var imageView = UIImageView()
    
    var label = UILabel()
    
    var model:PhotoModel? = nil{
        didSet{
            label.text = model?.caption
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(label)
        
        self.contentView.addSubview(imageView)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRectMake(0,0,imageSize.width,imageSize.height)
        imageView.center = self.contentView.center
        
        label.frame = CGRectMake(10, screenH-60, screenW-20, 60)
        label.font = UIFont.systemFontOfSize(13)
        label.textColor = UIColor.whiteColor()
        label.numberOfLines = 0
    }
    
    
    
}
