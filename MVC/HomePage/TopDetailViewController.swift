//
//  TopDetailViewController.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/27.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit
import Alamofire

class TopDetailViewController: UIViewController {
    
    
    var tableView = UITableView()
    
    var id = ""
    
    lazy var modelArray:[RelatedContentModel] = {
        return [RelatedContentModel]()
    }()
    
    lazy var frameModels:[RelatedFrameModel] = {
        return [RelatedFrameModel]()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        
        getNetData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        ToolManager.memoryClean()
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        //ToolManager.memoryClean()
    }
    
    //MAKR: - 获取网络数据
    func getNetData(){
        Alamofire.request(.GET, "http://q.chanyouji.com/api/v1/albums/\(id).json", parameters: nil, encoding: .URL, headers: nil).responseJSON { (data) -> Void in
            if let json = data.result.value{
                if let dataDic = json.objectForKey("data") as? NSDictionary{
                    if let items = dataDic["items"] as? [NSDictionary]{
                        for item in items{
                            if let dic = item["user_activity"] as? NSDictionary{
                                let model = RelatedContentModel.yy_modelWithJSON(dic)
                                
                                let frameModel = RelatedFrameModel(model: model)
                                
                                self.modelArray.append(model)
                                self.frameModels.append(frameModel)
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
   

}
extension TopDetailViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var  cell =  tableView.dequeueReusableCellWithIdentifier("cell") as? RelatedTableViewCell
        
        if cell == nil{
            cell = RelatedTableViewCell(style: .Default, reuseIdentifier: "cell")
        }
        
        if modelArray.count > 0 {
        
            cell?.dataModelOther = self.modelArray[indexPath.row]
            
            cell?.frameModel = self.frameModels[indexPath.row]
            
            cell?.coverImageView.delegate = self
            
        }
        
        return cell!
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.frameModels[indexPath.row].cellHeight
    }
}

//MARK: - 图片点击协议
extension TopDetailViewController:ImageContentViewDelegate{
    func showAllImage(imageArray: [String], selectIndex: Int) {
        let showVC = ShowBigImageViewController()
        showVC.imageUrls = imageArray
        showVC.selectIndex = selectIndex
        
        self.presentViewController(showVC, animated: true, completion: nil)
    }
}