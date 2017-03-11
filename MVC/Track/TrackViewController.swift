//
//  TrackViewController.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/18.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class TrackViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    
    //MARK: - 控件属性
    var tableView = UITableView()
    //MARK: - 数据源数组
    lazy var dataArray:[TrackModel] = {
        return [TrackModel]()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        creatUI()
        addRefresher()
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
    

    //MARK: - 界面相关
    func creatUI(){
        
        self.navigationController?.navigationBar.translucent = false
        
        self.navigationController?.navigationBar.titleTextAttributes  = [NSFontAttributeName:UIFont.boldSystemFontOfSize(17)]
        
        tableView.frame = CGRectMake(0, 0, screenW, screenH-64)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 200
        
        tableView.registerNib(UINib(nibName: "TrackTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .None
        
        
        
        
        self.view.addSubview(tableView)
    }
    //MARK:
    
    func addRefresher(){
        self.tableView.header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.dataArray.removeAll()
            self.getNetData()
        })
        self.tableView.footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.getNetData()
            
        })
    }
    
    //MARK: - 获取数据
    func getNetData(){
        Alamofire.request(.GET, URL_TrackList, parameters: ["page":dataArray.count/20+1,"per":20], encoding: .URL, headers: nil).responseJSON { (data) -> Void in
            if let json = data.result.value{
                if let dataArr = json.objectForKey("data") as? [NSDictionary]{
                    for item in dataArr{
                        if let activity = item["activity"]{
                            let model = TrackModel.yy_modelWithJSON(activity)
                            
                            self.dataArray.append(model)
                            
                        }
                        
                    }
                    self.tableView.header.endRefreshing()
                    self.tableView.footer.endRefreshing()
                    self.tableView.reloadData()
                }
            }else{
                self.tableView.header.endRefreshing()
                self.tableView.footer.endRefreshing()
            }
        }
    }
    
    //MARK: - 协议相关
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TrackTableViewCell
        if dataArray.count > 0{
        cell.model = dataArray[indexPath.row]
        }
        cell.selectionStyle = .None
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = TrackDetailViewController()
        
        detailVC.hidesBottomBarWhenPushed = true
        
        detailVC.model = dataArray[indexPath.row]
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
