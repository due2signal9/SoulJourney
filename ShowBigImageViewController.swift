//
//  ShowBigImageViewController.swift
//  MovieFansDemo1
//
//  Created by 千锋 on 16/10/13.
//  Copyright © 2016年 琼极无限. All rights reserved.
//

import UIKit
import Kingfisher

class ShowBigImageViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    //图片数组
    var imageUrls:[String] = []
    var selectIndex:Int = 0
    //当前所有的图片数组
    lazy var imageArray:[UIImage] = {
        return [UIImage]()
    }()
    //是否隐藏顶部
    var isHide = true
    
    var model:[PhotoModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        topView.hidden = true
//        saveBtn.hidden = true
        
        
        self.collectionView.registerClass(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.pagingEnabled = true
        
        collectionView.contentOffset = CGPointMake(CGFloat(selectIndex-1)*screenW, 0)
        
        titleLabel.text = "\(selectIndex)/\(imageUrls.count)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func completeAction(sender: AnyObject) {
        let image = self.imageArray.last
        //将图片保存到相册
        UIImageWriteToSavedPhotosAlbum(image!, self, "errorAction:error:contextInfo:", nil)
    }


    
    func errorAction(image:UIImage,error:NSError,contextInfo:AnyObject){
        
            KVNProgress.showSuccessWithStatus("保存成功")
       
    }
    
    
   
}
extension ShowBigImageViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ImageCollectionViewCell
        
        //imageview.contentMode = .ScaleAspectFill
        if imageUrls.count > 0 {
            
            
            
            cell.imageView.kf_setImageWithURL(NSURL(string: imageUrls[indexPath.row])!, placeholderImage: nil, optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) -> () in
                
                
                
                if let size = image?.size{
                    //将加载出来的图片添加到图片数组
                    self.imageArray.append(image!)
                    let bili = size.height/size.width
                    let height = screenW*bili
                    cell.imageSize = CGSizeMake(screenW, height)
                }
            })
//            cell.imageView.sd_setImageWithURL(NSURL(string: imageUrls[indexPath.row])!, placeholderImage: nil, completed: { (image, error, cacheType, imageURL) -> Void in
//                if let size = image?.size{
//                    //将加载出来的图片添加到图片数组
//                    self.imageArray.append(image!)
//                    let bili = size.height/size.width
//                    let height = screenW*bili
//                    cell.imageSize = CGSizeMake(screenW, height)
//                }
//            })
           
            
        }
        if model != nil{
            cell.model = model![indexPath.row]
        }
        
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(screenW, screenH)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if isHide {
            topView.hidden = false
            
        }else{
            topView.hidden = true
        }
        isHide = !isHide
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x/screenW)
        
        
        titleLabel.text = "\(index+1)/\(imageUrls.count)"
    }
}