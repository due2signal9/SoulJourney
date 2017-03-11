//
//  LandsCollectionViewCell.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/26.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit
import Kingfisher

class LandsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var subNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var model:HomePageListModel? = nil{
        didSet{
            self.subNameLabel.text = model?.name_en
            self.nameLabel.text = model?.name
            //self.coverImageView.kf_setImageWithURL(NSURL(string: model!.photo!.photo_url)!, placeholderImage: nil)
            self.coverImageView.sd_setImageWithURL(NSURL(string: model!.photo!.photo_url)!, placeholderImage: nil)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.coverImageView.layer.masksToBounds = true
        self.coverImageView.layer.cornerRadius = 5
    }

}
