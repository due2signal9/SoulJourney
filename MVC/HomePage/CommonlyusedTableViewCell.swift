//
//  CommonlyusedTableViewCell.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/20.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit

class CommonlyusedTableViewCell: UITableViewCell {

    @IBOutlet weak var termBtn: UIButton!
    @IBOutlet weak var freeBtn: UIButton!
    @IBOutlet weak var airBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        airBtn.tag = 0
        freeBtn.tag = 1
        termBtn.tag = 2
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
