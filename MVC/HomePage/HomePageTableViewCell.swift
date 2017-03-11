//
//  HomePageTableViewCell.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/18.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit
import Kingfisher
protocol PushOtherControllerDelegate:class{
    func pushController(section:Int,index:Int)
    
    func pushAllLandController(region:String)
}


class HomePageTableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    //用于保存是第几组的cell
    var section = 0
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkAllBtn: UIButton!
    
    @IBOutlet weak var MainImageView: CanTouchImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model:HomePageModel? = nil{
        didSet{
            nameLabel.text = model?.name
            checkAllBtn.setTitle(model?.button_text, forState: .Normal)
//            MainImageView.kf_setImageWithURL(NSURL(string: (model!.destinations![1].photo?.photo_url)!)!, placeholderImage: nil, optionsInfo: nil) { (image, error, cacheType, imageURL) -> () in
//                
//            }
            MainImageView.sd_setImageWithURL(NSURL(string: (model!.destinations![1].photo?.photo_url)!)!, placeholderImage: nil) { (image, error, cacheType, imageUrl) -> Void in
                if image != nil{
                    self.MainImageView.image = ToolManager.cutImageWithRect(image!, model: self.model!.destinations![1].photo!, height: self.MainImageView.frame.height, width: self.MainImageView.frame.width)
                }
            }
            self.collectionView.reloadData()
        }
    }
    //设置代理
    weak var delegate:PushOtherControllerDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        collectionView.registerNib(UINib(nibName: "HomePageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: - 按钮点击
    
    @IBAction func checkAllAction(sender: UIButton) {
        
        self.delegate?.pushAllLandController(model!.region)
    }
    
    //MARK: -协议
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! HomePageCollectionViewCell
        if model != nil{
            cell.model = model?.destinations![indexPath.row]
        }
        
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if model != nil{
            if self.section == 0{
                return 6
            }
            return (model?.destinations?.count)!
        }
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((screenW - 40)/3, collectionView.frame.size.height)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 10)
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.pushController(section,index:indexPath.row)
    }
}
