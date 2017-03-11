//
//  AllLandViewController.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/26.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit
import Alamofire

class AllLandViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    
    var collectionView:UICollectionView?
    
    var region = ""{
        didSet{
            if region != "near"{
                getNetData(region)
            }
        }
    }
    var model:[HomePageListModel]? = nil{
        didSet{
            
        }
    }
    
    var dataArray = [HomePageListModel]()
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        //ToolManager.memoryClean()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        collectionView?.registerNib(UINib(nibName: "LandsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        collectionView?.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(collectionView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        ToolManager.memoryClean()
    }
    //MARK: - 网络请求
    func getNetData(region:String){
        Alamofire.request(.GET, URL_AreaList, parameters: ["area":region], encoding: .URL, headers: nil).responseJSON { (data) -> Void in
            if let json = data.result.value{
                if let dataArr = json.objectForKey("data") as? NSArray{
                    for item in dataArr{
                        let model = HomePageListModel.yy_modelWithJSON(item)
                        
                        self.dataArray.append(model)
                    }
                    self.collectionView?.reloadData()
                }
                
            }
        }
    }
    
    
    
    //MARK: - 协议方法
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if model != nil{
            return model!.count
        }
        return dataArray.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! LandsCollectionViewCell
        if model != nil{
            cell.model = self.model![indexPath.row]
        }
        if dataArray.count > 0 {
            cell.model = self.dataArray[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((screenW-40)/2,(screenW-40)/2*0.8947)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 15, 0, 15)
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = HomePageDetailViewController()
        if model != nil{
            vc.name = model![indexPath.row].name
            vc.id = model![indexPath.row].id
            vc.photoUrl = model![indexPath.row].photo!.photo_url
        }
        if dataArray.count > 0 {
            vc.name = dataArray[indexPath.row].name
            vc.id = dataArray[indexPath.row].id
            vc.photoUrl = dataArray[indexPath.row].photo!.photo_url
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
