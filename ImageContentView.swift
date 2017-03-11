//
//  ImageContentView.swift
//  MovieFansDemo1
//
//  Created by 千锋1 on 16/9/29.
//  Copyright © 2016年 琼极无限. All rights reserved.
//

import UIKit

protocol ImageContentViewDelegate:class{
    func showAllImage(imageArray:[String],selectIndex:Int)
}

class ImageContentView: UIView {

   //MAKR: - 属性
    //代理
    weak var delegate:ImageContentViewDelegate? = nil
    
    
    //图片地址
    var imageUrls:[String]? = nil{
        didSet{
            //移除
            for item in self.subviews{
                item.removeFromSuperview()
            }
            
            var i = 1
            
            for item in imageUrls!{
                let imageView = CanTouchImageView()
                imageView.kf_setImageWithURL(NSURL(string: item)!, placeholderImage: UIImage(named: "movie_default_light_760x570.png"))
                imageView.addtarget(self, action: "imageAction:")
                imageView.tag = i
                self.addSubview(imageView)
                i += 1
            }
        }
    }

}
extension ImageContentView{
    func imageAction(imageView:CanTouchImageView){
        self.delegate?.showAllImage(self.imageUrls!, selectIndex: imageView.tag)
    }
}


extension ImageContentView{
    override func layoutSubviews() {
        super.layoutSubviews()
        //获取图片张数
        let count = self.imageUrls?.count
        //间距
        let margin:CGFloat = 2
        //容器的宽高
        let contentW = self.frame.size.width
        let contentH = self.frame.size.height
        //1.一张图
        if count == 1{
            let x = margin
            let y = margin
            let w = contentW
            let h = contentH
            for item in self.subviews{
                item.frame = CGRectMake(x, y, w, h)
            }
        }
        //2.两张/四张
        if count == 2 || count == 4{
            let w = (contentW - margin*3)/2
            let h = (contentH - margin*CGFloat(count!/2+1))/CGFloat(count!/2)
            for (i,item) in self.subviews.enumerate(){
                let x = margin + (margin+w) * CGFloat(i%2)
                let y = margin + (margin+h) * CGFloat(i/2)
                item.frame = CGRectMake(x, y, w, h)
            }
        }
        //3.三张或四张以上
        if count == 3 || count > 4{
            let w = (contentW-4*margin)/3
            let line = CGFloat((count!-1)/3 + 1)
            let h = (contentH - CGFloat(line+1)*margin)/CGFloat(line)
            
            for (i,item) in self.subviews.enumerate(){
                let x = margin + (margin+w)*CGFloat(i%3)
                let y = margin + (margin+h)*CGFloat(i/3)
                item.frame = CGRectMake(x, y, w, h)
            }
        }
    }
}