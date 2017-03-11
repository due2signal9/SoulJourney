//
//  TrackDetailViewController.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/27.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit

class TrackDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UMSocialUIDelegate{
    
    var tableView = UITableView()
    
    var frameModel:TrackDetailFrameModel?
    
    
    var model = TrackModel(){
        didSet{
            frameModel = TrackDetailFrameModel(model: model)
        }
    }
    lazy var imageUrls:[String] = {
        var tempArray = [String]()
        for item in self.model.contents!{
            tempArray.append(item.photo_url)
        }
        return tempArray
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.frame = CGRectMake(0, 0, screenW, screenH - 64)
        
        tableView.delegate = self
        tableView.dataSource = self

        tableView.registerClass(TrackDetailTableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.title = model.districts![0].name
        
        
        self.view.addSubview(tableView)
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "分享", style: .Plain, target: self, action: "shareToWechat")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        ToolManager.memoryClean()
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        //ToolManager.memoryClean()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    //MARK: - 分享到微信
    func shareToWechat(){
        UMSocialData.defaultData().extConfig.wxMessageType = UMSocialWXMessageTypeImage
        UMSocialData.defaultData().extConfig.wechatSessionData.shareImage = ToolManager.viewForImage(self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))!)
        UMSocialSnsService.presentSnsIconSheetView(self, appKey: "5779d71f67e58eb2fa001ffe", shareText: nil, shareImage: nil, shareToSnsNames: [UMShareToWechatSession,UMShareToWechatTimeline], delegate: self)
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TrackDetailTableViewCell
        
        cell.dataModel = model
        
        cell.frameModel = frameModel
        
        cell.topImageView.addtarget(self, action: "imageAction")
        
        cell.delegate = self
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return frameModel!.cellHeight
    }
    
    
    //MARK: - 按钮点击
    func imageAction(){
        
        
        let bigVC = ShowBigImageViewController()
        bigVC.imageUrls = imageUrls
        bigVC.selectIndex = 1
        bigVC.model = model.contents
        
        self.presentViewController(bigVC, animated: true, completion: nil)
    }
}
// collectionCell点击跳转的协议
extension TrackDetailViewController:CollectionViewInTableViewCellPush{
    func presentOtherController(index: Int) {
        let bigVC = ShowBigImageViewController()
        bigVC.imageUrls = imageUrls
        bigVC.selectIndex = index
        bigVC.model = model.contents
        
        self.presentViewController(bigVC, animated: true, completion: nil)
    }
}
