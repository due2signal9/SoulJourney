//
//  TrackTableViewCell.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/18.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit
import Kingfisher

class TrackTableViewCell: UITableViewCell {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var actorNameLabel: UILabel!

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var MainTitleLabel: UILabel!
    
   
    
    var model:TrackModel? = nil{
        didSet{
//            bgImageView.kf_setImageWithURL(NSURL(string: model!.contents![0].photo_url)!, placeholderImage: nil, optionsInfo: nil) { (image, error, cacheType, imageURL) -> () in
//                
//                if image != nil{
//                
//                    self.bgImageView.image = ToolManager.cutImageWithRect(image!, model:self.model!.contents![0], height: self.frame.height, width: self.frame.width)
//                }
//            }
            bgImageView.sd_setImageWithURL(NSURL(string: model!.contents![0].photo_url)!, placeholderImage: nil) { (image, error, cacheType, imageURL) -> Void in
                if image != nil{
                    
                    self.bgImageView.image = ToolManager.cutImageWithRect(image!, model:self.model!.contents![0], height: self.frame.height, width: self.frame.width)
                }
            }
            actorNameLabel.text = model?.user.name
            iconImageView.kf_setImageWithURL(NSURL(string: (model?.user.photo_url)!)!, placeholderImage: nil)
            
            let time = ToolManager.transform(model!.created_at)
            dataLabel.text = time
            MainTitleLabel.text = model?.topic
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
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.iconImageView.layer.masksToBounds = true
        self.iconImageView.layer.cornerRadius = 20
    }
}
