//
//  HomePageDetailViewController.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/19.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit
import Alamofire

class HomePageDetailViewController: UIViewController {
    
    //MARK: - 属性
    var name = ""
    var id = ""
    //MARK: - 控件属性
    var header = UIView()
    
    var tableView = UITableView()
    
    var headerModel = HomePageListModel(){
        didSet{
            if let view = header as? DetailHeaderView{
                //view.CoverImageView.kf_setImageWithURL(NSURL(string: (headerModel.photo?.photo_url)!)!, placeholderImage: nil)
                view.CoverImageView.sd_setImageWithURL(NSURL(string: (headerModel.photo?.photo_url)!)!, placeholderImage: nil)
                view.titleLabel.text = headerModel.name
                view.subTitleLabel.text = headerModel.name_en
            }
        }
    }
    var classicLineModel:lineModel?
    
    var relatedModel:RelatedModel?
    
    var relatedFrameModle:RelatedFrameModel?
    
    var otherLinkModel = [OtherLinkModel]()
    
    var totalType = [String]()
    
    var photoUrl = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatUI()
        getNetData()
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        
        //ToolManager.memoryClean()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit{
        ToolManager.memoryClean()
    }
    

   //MARK: - 界面相关
    func creatUI(){
        self.view.backgroundColor = UIColor.clearColor()
        
        self.navigationItem.title = name
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor(red: 0, green: 0, blue: 0, alpha: 1)]
        
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        
        //头视图
        header = UINib(nibName: "DetailHeaderView", bundle: nil).instantiateWithOwner(self, options: nil).first as! DetailHeaderView
        
        header.frame = CGRectMake(0, 64, screenW, 200)
        
        header.hidden = true
        
        //tableView
        tableView = UITableView(frame: CGRectMake(0, 0, screenW, screenH), style: .Grouped)
        
        tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.showsVerticalScrollIndicator = false
        tableView.registerNib(UINib(nibName: "ClassicLineTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        tableView.registerClass(RelatedTableViewCell.self, forCellReuseIdentifier: "cell1")
        
        tableView.registerNib(UINib(nibName: "CommonlyusedTableViewCell", bundle: nil), forCellReuseIdentifier: "cell2")
        
        
        
        self.view.addSubview(tableView)
        
        self.view.addSubview(header)
    }
    
    //MARK: - 获取网络数据
    func getNetData(){
        print(URL_HomePageDetail+"\(id).json")
        Alamofire.request(.GET, URL_HomePageDetail+"\(id).json", parameters: nil, encoding: .URL, headers: nil).responseJSON { (data) -> Void in
            if let json = data.result.value {
                if let dataDic = json.objectForKey("data") as? NSDictionary{
                    
                    self.headerModel = HomePageListModel.yy_modelWithJSON(dataDic["destination"])
                    
                    
                    
                    if let sections = dataDic["sections"] as? [NSDictionary]{
                        for item in sections{
                            if (item["type"] as? String) == "Plan"{
                                if let models = item["models"] as? NSArray{
                                    self.classicLineModel = lineModel.yy_modelWithJSON(models[0])
                                    
                                   
                                    
                                }
                                 self.totalType.append("Plan")
                            }else if (item["type"] as? String) == "UserActivity"{
                                self.relatedModel = RelatedModel.yy_modelWithJSON(item)
                                print(self.relatedModel?.models![0].contents)
                                self.relatedFrameModle = RelatedFrameModel(model: (self.relatedModel?.models![0])!)
                                 self.totalType.append("UserActivity")
                            }
                        }
                    }
                    ///goods
                    if let goods = dataDic["goods"] as? [NSDictionary]{
                        for item in goods{
                            let model = OtherLinkModel.yy_modelWithJSON(item)
                            
                            self.otherLinkModel.append(model)
                        }
                        self.totalType.insert("goods", atIndex: 0)
                    }
                    
                    self.tableView.reloadData()
                    self.header.hidden = false
                }
            }
        }
    }
}
//MARK: - tableView协议
extension HomePageDetailViewController:UITableViewDataSource,UITableViewDelegate{
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == tableView{
            self.header.frame.origin.y = -200-scrollView.contentOffset.y
        }
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        if totalType[indexPath.section] == "goods"{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! CommonlyusedTableViewCell
            cell.airBtn.addTarget(self, action: "btnAction:", forControlEvents: .TouchDown)
            cell.freeBtn.addTarget(self, action: "btnAction:", forControlEvents: .TouchDown)
            cell.termBtn.addTarget(self, action: "btnAction:", forControlEvents: .TouchDown)
            
            cell.selectionStyle = .None
            
            return cell
        }
        else if totalType[indexPath.section] == "Plan"{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ClassicLineTableViewCell
            
            
            if classicLineModel != nil{
                let count = classicLineModel!.days_count
            
                cell.daysLabel.text = " \(count)天行程"
                cell.model = classicLineModel
            }
            cell.selectionStyle = .None
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! RelatedTableViewCell
            
            cell.selectionStyle = .None
            if self.relatedModel != nil{
                cell.dataModel = self.relatedModel
                cell.frameModel = self.relatedFrameModle
                cell.coverImageView.delegate = self
        
            }
            
            return cell
        }
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.totalType.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if totalType[indexPath.section] == "goods" {
            return 200
        }else if  totalType[indexPath.section] == "Plan"{
            return 250
        }
        else{
            if let hight = relatedFrameModle?.cellHeight{
                return hight
            }else{
                return 0 
            }
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1{
            let tableVC = TableViewController()
            
            
            tableVC.model = classicLineModel
            tableVC.photoUrl = photoUrl
            
            
            
            self.navigationController?.pushViewController(tableVC, animated: true)
        }
    }
}
//MARK: - 按钮点击
extension HomePageDetailViewController{
    func btnAction(btn:UIButton){
        
        let otherVC = OtherLinkViewController()
        
        var url = ""
        var title = ""
        
        for item in otherLinkModel{
            if item.title == btn.titleLabel!.text{
                url = item.url
                title = item.title
            }
        }
        otherVC.url = url
        otherVC.title = title
        self.navigationController?.pushViewController(otherVC, animated: true)
    }
}

//MARK: - 点击看大图的协议
extension HomePageDetailViewController:ImageContentViewDelegate{
    func showAllImage(imageArray: [String], selectIndex: Int) {
        let showVC = ShowBigImageViewController()
        showVC.imageUrls = imageArray
        showVC.selectIndex = selectIndex
        showVC.model = self.relatedModel?.models![0].contents
        
        self.presentViewController(showVC, animated: true, completion: nil)
    }
}