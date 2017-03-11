//
//  HeaderView.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/18.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit

class HeaderView: UIView{
    //MARK: - 属性
    @IBOutlet weak var ImageCollectionView: UICollectionView!
   
    @IBOutlet weak var NumPage: UIPageControl!
    
    var model:HeaderModel? = nil{
        didSet{
        }
    }
   

}
