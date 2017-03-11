//
//  TrackDetailTableViewCell.swift
//  SoulJourney
//
//  Created by PengJiLi on 16/10/28.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit
import Kingfisher
///CollectionView在TableViewCell中，CollectionViewCell的点击跳转协议
protocol CollectionViewInTableViewCellPush:class{
    func presentOtherController(index:Int)
}


class TrackDetailTableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var topImageView = CanTouchImageView()
    
    var collectionView:UICollectionView?
    
    var titleLabel = UILabel()
    
    var contentLabel = UILabel()
    
    var moreButton = UIButton()
    
    weak var delegate:CollectionViewInTableViewCellPush?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(topImageView)
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.backgroundColor = UIColor.whiteColor()
        
        layout.minimumLineSpacing = 3
        layout.scrollDirection = .Horizontal
        
        self.contentView.addSubview(collectionView!)
        
        self.contentView.addSubview(titleLabel)
        
        self.contentView.addSubview(contentLabel)
        
        self.contentView.addSubview(moreButton)
        
    }
    
    var dataModel:TrackModel? = nil{
        didSet{
            
            topImageView.kf_setImageWithURL(NSURL(string: (dataModel?.contents![0].photo_url)!)!, placeholderImage: nil)
            //topImageView.sd_setImageWithURL(NSURL(string: (dataModel?.contents![0].photo_url)!)!, placeholderImage: nil)
            
            titleLabel.text = dataModel?.topic
            
            contentLabel.text = dataModel?.content
            
            let btnName = dataModel!.user.name + ":" + dataModel!.districts![0].name + "足迹(\(dataModel!.parent_district_count)篇)"
            moreButton.setTitle(btnName, forState: .Normal)
            
            self.collectionView?.reloadData()
        }
    }
    var frameModel:TrackDetailFrameModel? = nil{
        didSet{
            topImageView.frame = frameModel!.topViewFrame
            
            
            collectionView?.frame = frameModel!.collectionFrame
            
            titleLabel.frame = frameModel!.titleFrame
            titleLabel.font = UIFont.systemFontOfSize(17)
            titleLabel.numberOfLines = 0
            
            contentLabel.frame = frameModel!.contentFrame
            contentLabel.font = UIFont.systemFontOfSize(13)
            contentLabel.numberOfLines = 0
            
            moreButton.frame = frameModel!.moreBtnFrame
            moreButton.titleLabel?.font = UIFont.systemFontOfSize(13)
            moreButton.setTitleColor(UIColor.greenColor(), forState:.Normal)
            moreButton.contentHorizontalAlignment = .Left
        
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MAKR: - 协议方法
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
        let imageView = UIImageView()
        if dataModel != nil {
            imageView.kf_setImageWithURL(NSURL(string: (dataModel?.contents![indexPath.row+1].photo_url)!)!, placeholderImage: nil, optionsInfo: nil, completionHandler: { (image, error, cacheType, imageURL) -> () in
                
                
                if image != nil{
                    let model = self.dataModel?.contents![indexPath.row]
                    imageView.image = ToolManager.cutImageWithRect(image!, model: model!, height: cell.frame.height, width: cell.frame.width)
                }
            })
//            imageView.sd_setImageWithURL(NSURL(string: (dataModel?.contents![indexPath.row+1].photo_url)!)!, placeholderImage: nil, completed: { (image, error, cacheType, imageURL) -> Void in
//                if image != nil{
//                    let model = self.dataModel?.contents![indexPath.row]
//                    imageView.image = ToolManager.cutImageWithRect(image!, model: model!, height: cell.frame.height, width: cell.frame.width)
//                }
//            })
            
        }
        
        cell.backgroundView = imageView
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataModel != nil{
            return (dataModel?.contents?.count)!-1
        }
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if frameModel != nil{
            return CGSizeMake(150, collectionView.frame.size.height)
        }
        return CGSizeZero
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.presentOtherController(indexPath.row+2)
    }
}
