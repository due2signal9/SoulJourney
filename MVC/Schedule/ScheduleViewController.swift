//
//  ScheduleViewController.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/18.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    var tipLabel = UILabel()
    
    var tableView = UITableView()
    

    lazy var dataModel:[TrackLineModel] = {
        let tempModel = ToolManager.queryAll()
        
        return tempModel
    }()
    
    //MARK: - 控件属性
    var imageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        creatUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let tempModel = ToolManager.queryAll()
        
        dataModel = tempModel
        
        
        self.tableView.reloadData()
    }
    
    //MARK: - 界面相关
    func creatUI(){
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        imageView.frame = self.view.bounds
        
        let path = NSBundle.mainBundle().pathForResource("xingchengBg", ofType: "png")
        imageView.image = UIImage(contentsOfFile: path!)
        
        self.view.addSubview(imageView)
        
        
        tipLabel.frame = CGRectMake(0, 100, screenW, 21)
        tipLabel.textAlignment = .Center
        tipLabel.textColor = UIColor.grayColor()
        tipLabel.text = "将精品路线加入行程单"
        tipLabel.font = UIFont.systemFontOfSize(13)
        self.view.addSubview(tipLabel)
        
        tableView = UITableView(frame:CGRectMake(0, 64, screenW, screenH-64-49), style: .Plain)
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        tableView.rowHeight = 100
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        tableView.registerNib(UINib(nibName: "ScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView)
    }

}
extension ScheduleViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ScheduleTableViewCell
        
        cell.model = dataModel[indexPath.row]
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.count
    }

    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        ToolManager.deleteTrack(self.dataModel[indexPath.row].title!)
        
        self.dataModel.removeAtIndex(indexPath.row)
        
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Middle)
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = TableViewController()
        vc.id = dataModel[indexPath.row].id!
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

