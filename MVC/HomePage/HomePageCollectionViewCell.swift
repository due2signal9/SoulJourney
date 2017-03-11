//
//  HomePageCollectionViewCell.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/18.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit

class HomePageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var CoverImageView: UIImageView!
    
    var model:HomePageListModel? = nil{
        didSet{
            subLabel.text = model?.name_en
            titleLabel.text = model?.name
            //CoverImageView.kf_setImageWithURL(NSURL(string: model!.photo!.photo_url)!, placeholderImage: nil)
            CoverImageView.sd_setImageWithURL(NSURL(string: model!.photo!.photo_url)!, placeholderImage: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
