//
//  ScheduleTableViewCell.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/31.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit
import Kingfisher

class ScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayCountLabel: UILabel!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    
    var model:TrackLineModel? = nil{
        didSet{
            dateLabel.text = model?.date
            dayCountLabel.text = String(model!.daycount!) + "天"
            //coverImageView.kf_setImageWithURL(NSURL(string: model!.photo_url!)!, placeholderImage: nil)
            coverImageView.sd_setImageWithURL(NSURL(string: model!.photo_url!)!, placeholderImage: nil)
            mainTitleLabel.text = model?.title
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
