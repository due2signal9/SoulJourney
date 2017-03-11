//
//  AboutViewController.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/31.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        

        let label = UILabel(frame: CGRectMake(10,0,screenW-20,150))
        label.text = "如今旅游业已经今非昔比，随着智能终端、移动网络的高度发展，传统旅游行业与移动互联网产业的融合速度加快，用户只需动动手指，就可以随时把握最新的旅游资讯、旅游攻略、景点，实时查机票、酒店、订门票等服务，移动旅游成为了当下旅游业的关键词。对于游客来说，移动旅游的兴起大大提升了出行体验度，对于拉动地方旅游业、餐饮业、娱乐业的发展同样有着积极作用。"
        label.font = UIFont.systemFontOfSize(13)
        label.numberOfLines = 0
        
        self.view.addSubview(label)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
