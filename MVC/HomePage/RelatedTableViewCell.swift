//
//  RelatedTableViewCell.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/20.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit

class RelatedTableViewCell: UITableViewCell {
    
    var headerLabel = UILabel()
    
    var coverImageView = ImageContentView()
    
    var contentTitleLabel = UILabel()
    
    var contentLabel = UILabel()
    
    var bottomBtn = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier:reuseIdentifier)
        self.contentView.addSubview(headerLabel)
        self.contentView.addSubview(coverImageView)
        self.contentView.addSubview(contentTitleLabel)
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(bottomBtn)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var frameModel:RelatedFrameModel? = nil{
        didSet{
            headerLabel.frame = (frameModel?.headerLabelFrame)!
            headerLabel.font = UIFont.systemFontOfSize(13)
            headerLabel.textColor = UIColor.lightGrayColor()
            
            coverImageView.frame = (frameModel?.coverImageViewFrame)!
            
            contentTitleLabel.frame = (frameModel?.contentTitleLabelFrame)!
            contentTitleLabel.font = UIFont.boldSystemFontOfSize(21)
            contentTitleLabel.textColor = UIColor.blackColor()
            contentTitleLabel.numberOfLines = 0
            
            contentLabel.frame = (frameModel?.contentLabelFrame)!
            contentLabel.font = UIFont.systemFontOfSize(13)
            contentLabel.textColor = UIColor.blackColor()
            contentLabel.numberOfLines = 0
            
            bottomBtn.frame = (frameModel?.bottomBtnFrame)!
            bottomBtn.setTitleColor(UIColor(red: 56/255.0, green: 162/255.0, blue: 249/255.0, alpha: 1), forState: .Normal)
            bottomBtn.titleLabel?.font = UIFont.systemFontOfSize(13)
        }
    }
    
    var dataModel:RelatedModel? = nil{
        didSet{
            headerLabel.text = "相关足迹"
            
            var imageUrls = [String]()
            for i in (dataModel?.models![0].contents)!{
                imageUrls.append(i.photo_url)
            }
            coverImageView.imageUrls = imageUrls
            
            contentTitleLabel.text = dataModel?.models![0].topic
            
            contentLabel.text = dataModel?.models![0].summary
            
            bottomBtn.setTitle(dataModel?.button_text, forState: .Normal)
            
        }
    }
    var dataModelOther:RelatedContentModel? = nil{
        didSet{
            headerLabel.text = dataModelOther?.user?.name
            
            var imageUrls = [String]()
            for item in dataModelOther!.contents!{
                imageUrls.append(item.photo_url)
            }
            coverImageView.imageUrls = imageUrls
            
            contentTitleLabel.text = dataModelOther?.topic
            
            contentLabel.text = dataModelOther?.textContent
            
            
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
