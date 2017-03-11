//
//  TableViewController.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/24.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit
import Alamofire

class TableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UMSocialUIDelegate{
    
    //MARK: - 控件属性
    //1.上方地图
    var mapView = MAMapView()
    
    var tableView = UITableView()
    
    let joinTrcakBtn = UIButton(type: .Custom)
    
    
    //数据源数组
    var classicLineDetailFrameModel = [ClassicLineDetailFrameModel]()
    
    var model:lineModel? = nil{
        didSet{
            for item1 in model!.days!{
                let frameModel = ClassicLineDetailFrameModel(model: item1)
                
                self.classicLineDetailFrameModel.append(frameModel)
            }
            self.addPoints(model!.days![0].points)
            
            self.tableView.reloadData()
        }
    }
    
    var photoUrl = ""
    
    var id = ""
    
    
    //打开和关闭下标集合
    var openArrays = [((Set<Int>,Set<Int>),Int)]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatUI()
        
        if model == nil{
            self.getNetData(id)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        ToolManager.memoryClean()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        //ToolManager.memoryClean()
    }
    
    
    //MARK: - 界面相关
    func creatUI(){
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "分享", style: .Plain, target: self, action: "shareAction")
        
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, screenW, screenH), style: .Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        mapView.frame  = CGRectMake(0, 0, screenW, 200)
        
        mapView.delegate = self
        mapView.showsLabels = false
        mapView.showsScale = false
        
        
        
        
        self.tableView.tableHeaderView = mapView
        
        self.view.addSubview(tableView)
        
        
        joinTrcakBtn.frame = CGRectMake(0, screenH-50, screenW, 50)
        joinTrcakBtn.setTitle("加入行程单", forState: .Normal)
        //joinTrcakBtn.setTitleColor(UIColor(red: 21/255, green: 176/255, blue: 138/255, alpha: 0.8), forState: .Normal)
        joinTrcakBtn.backgroundColor = UIColor(red: 21/255, green: 176/255, blue: 138/255, alpha: 0.8)
        joinTrcakBtn.addTarget(self, action: "joinTrcakAction", forControlEvents: .TouchDown)
        
        self.view.addSubview(joinTrcakBtn)
    }
    
    //MARK: - 分享
    func shareAction(){
        let text = model?.title
        var image = UIImage()
        if let url = NSURL(string: photoUrl){
            let data = NSData.init(contentsOfURL:url)
            if data != nil{
                image = UIImage(data: data!)!
            }
        }
        //let urlResource = UMSocialUrlResource(snsResourceType: UMSocialUrlResourceTypeWeb, url: "http://q.chanyouji.com/plans/\(model!.id).html?from=singlemessage&isappinstalled=1")
//        let data = UMSocialWechatSessionData()
//        data.title = text
//        data.url = "http://q.chanyouji.com/plans/\(model!.id).html?from=singlemessage&isappinstalled=1"
        
        UMSocialData.defaultData().extConfig.wechatSessionData.url = "http://q.chanyouji.com/plans/\(model!.id).html?from=singlemessage&isappinstalled=1"
        UMSocialData.defaultData().extConfig.wechatTimelineData.url = "http://q.chanyouji.com/plans/\(model!.id).html?from=singlemessage&isappinstalled=1"
        
        
        UMSocialSnsService.presentSnsIconSheetView(self, appKey: "5779d71f67e58eb2fa001ffe", shareText: text, shareImage:image, shareToSnsNames: [UMShareToWechatSession,UMShareToWechatTimeline], delegate: self)
    }
    
    
    //MARK: - 按钮点击
    func joinTrcakAction(){
        
       let item = ToolManager.queryOne(model!.title)
        if item == nil{
            ToolManager.addTrack(model!,photoUrl: photoUrl)
            KVNProgress.showSuccessWithStatus("加入行程成功")
        }else{
            KVNProgress.showErrorWithStatus("已在行程单中")
        }
        
        
    }
    
    
   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if model != nil{
            return (model?.days?.count)!
        }
        
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? ClassicLineDetailTableViewCell
        
        if cell == nil{
            cell = ClassicLineDetailTableViewCell(style: .Subtitle, reuseIdentifier: "cell")
        }
        
        cell?.selectionStyle = .None
        
        if model != nil{
           
            
            cell!.dataModel = model!.days![indexPath.section]
            cell?.frameModel = classicLineDetailFrameModel[indexPath.section]
            cell?.btnView.delegate = self
            cell?.btnView.tag = indexPath.section
            
            
            if openArrays.count > indexPath.section{
                for i in openArrays{
                    if i.1 == indexPath.section{
                        cell?.btnView.openArray = i.0.0
                        cell?.btnView.closeArray = i.0.1
                    }
                }
            }
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.classicLineDetailFrameModel.count > 0{
            return self.classicLineDetailFrameModel[indexPath.section].cellHeight
        }
        return 0
    }
   
}


//MARK: - 按钮点击改变cell高度协议
extension TableViewController:ChangeCellHeight{
    func changeHeight(moreHeight: CGFloat,tag:Int,openArray:(Set<Int>,Set<Int>)) {
        if openArray.0.count > 0 || openArray.1.count > 0{
            self.classicLineDetailFrameModel[tag].cellHeight += moreHeight
            
            self.classicLineDetailFrameModel[tag].btnFrame.size.height += moreHeight
            
            
            
            self.tableView.reloadData()
            
            let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: tag)) as! ClassicLineDetailTableViewCell
            cell.btnView.openArray = openArray.0
            
            cell.btnView.closeArray = openArray.1
            
            self.openArrays.append((openArray,tag))
        }
    }
}
//MARK: - 获取网络数据
extension TableViewController{
    func getNetData(id:String){
        Alamofire.request(.GET, URL_HomePageDetail+"\(id).json", parameters: nil, encoding: .URL, headers: nil).responseJSON { (data) -> Void in
            if let json = data.result.value {
                if let dataDic = json.objectForKey("data") as? NSDictionary{
                    if let sections = dataDic["sections"] as? [NSDictionary]{
                        for item in sections{
                            if (item["type"] as? String) == "Plan"{
                                if let models = item["models"] as? NSArray{
                                    self.model = lineModel.yy_modelWithJSON(models[0])
                                    
                    
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
}

//MARK: - 地图相关

extension TableViewController:MAMapViewDelegate{
    //MARK: -添加点标记
    func addPoints(pois:[PointModel]){
        
        var points = [CLLocationCoordinate2D]()
        
        var annotations = [MAPointAnnotation]()
        
        
        for item in pois{
            let point = MAPointAnnotation()
            point.coordinate = CLLocationCoordinate2DMake(Double(item.poi!.lat)!,Double(item.poi!.lng)!)
            point.title = item.poi!.name
            mapView.addAnnotation(point)
            points.append(CLLocationCoordinate2DMake(Double(item.poi!.lat)!,Double(item.poi!.lng)!))
            annotations.append(point)
        }
        //显示所有的标注
        mapView.showAnnotations(annotations, animated: false)
        //绘制折线
        let line = MAPolyline(coordinates: &points, count: UInt(points.count))
        
        self.mapView.addOverlay(line)
        
    }
    //MARK: - 改变标注样式
    //协议方法，设置气泡的样式
    func mapView(mapView: MAMapView!, viewForAnnotation annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation .isKindOfClass(MAPointAnnotation){
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("view") as? MAPinAnnotationView
            if annotationView == nil{
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: "view")
            }
            annotationView?.image = UIImage(named: "dingwei")
            annotationView!.canShowCallout = true
            annotationView!.animatesDrop = true
            
            
            return annotationView
        }
        return nil
    }
    
    //协议方法，设置折线的类型
    func mapView(mapView: MAMapView!, rendererForOverlay overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay.isKindOfClass(MAPolyline.self){
            let polyLine = MAPolylineRenderer(overlay: overlay)
            polyLine.lineWidth = 3
            polyLine.strokeColor = UIColor.redColor()
            //连接处的样式
            polyLine.lineJoinType = kMALineJoinRound
            //设置线断电
            polyLine.lineCapType = kMALineCapArrow
            
            return polyLine
        }
        return nil
    }
    //标注被点击时候时候调用
    func mapView(mapView: MAMapView!, didSelectAnnotationView view: MAAnnotationView!) {
        view.image = UIImage(named: "dingwei_select")
    }
    //标注取消点击的时候
    func mapView(mapView: MAMapView!, didDeselectAnnotationView view: MAAnnotationView!) {
        view.image = UIImage(named: "dingwei")
        
    }
    
    func mapView(mapView: MAMapView!, didSingleTappedAtCoordinate coordinate: CLLocationCoordinate2D) {
        let vc =  MapViewController()
        vc.model = self.model
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
