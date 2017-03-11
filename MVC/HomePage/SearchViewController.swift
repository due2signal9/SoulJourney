//
//  SearchViewController.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/27.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class SearchViewController: UIViewController {

    var tableView = UITableView()
    
    var searchBar = UISearchBar()
    
    var dataModel = [RelatedContentModel]()
    
    var frameModel = [RelatedFrameModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        tableView.frame = self.view.bounds
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerClass(RelatedTableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView)
        
        navigationSetting()
        
        self.searchBar.becomeFirstResponder()
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        //ToolManager.memoryClean()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        ToolManager.memoryClean()
    }
    func navigationSetting(){
        
        searchBar = UISearchBar(frame: CGRectMake(10,20,screenW - 50,25))
        
        searchBar.barStyle = .Black
        
        
        searchBar.placeholder = "搜索目的地、游记"
        
        searchBar.delegate = self
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationItem.titleView = searchBar
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "cancleAction")
    }
    //MARK: - 按钮点击
    func cancleAction(){
        searchBar.endEditing(true)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
   
}
//MARK: - 搜索框的协议代理
extension SearchViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
        getNetdata(searchBar.text!)
    }
}
//MARK: - tableView协议代理
extension SearchViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! RelatedTableViewCell
        
        cell.dataModelOther = dataModel[indexPath.row]
        cell.frameModel = frameModel[indexPath.row]
        cell.bottomBtn.setTitle("更多相关游记", forState: .Normal)
        cell.coverImageView.delegate = self
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if frameModel.count > 0{
            return frameModel[indexPath.row].cellHeight
        }
        return 0
    }
}
//MARK: - 点击看大图代理
extension SearchViewController:ImageContentViewDelegate{
    func showAllImage(imageArray: [String], selectIndex: Int) {
        let showVC = ShowBigImageViewController()
        showVC.imageUrls = imageArray
        showVC.selectIndex = selectIndex
        showVC.model = dataModel[0].contents
        
        self.presentViewController(showVC, animated: true, completion: nil)
    }
}

extension SearchViewController{
    //MARK: - 获取网络数据
    func getNetdata(str:String){
        let url = "http://q.chanyouji.com/api/v2/search.json?q=\(str)"
        
        let encodeUrl = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        print(encodeUrl)
        
        Alamofire.request(.GET, encodeUrl!, parameters: nil, encoding: .URL, headers: nil).responseJSON { (data) -> Void in
            if let json = data.result.value{
                if let dataDic = json.objectForKey("data") as? NSDictionary{
                    if let hitted = dataDic["hitted"] as? NSDictionary
                    {
                        if let destination = hitted["destination"] as? NSDictionary{
                            let detailVC = HomePageDetailViewController()
                            let id = destination.objectForKey("id")
                            detailVC.id = String(id!)
                            self.navigationController?.pushViewController(detailVC, animated: true)
                        }
                        else{
                            if let sections = dataDic["sections"] as? [NSDictionary]{
                                
                                if sections.count == 0{
                                    KVNProgress.showErrorWithStatus("没有搜索到结果")
                                    return
                                }
                                
                                for item in sections{
                                    if (item["type"] as! String) == "UserActivity"{
                                        if let models = item["models"] as? [NSDictionary]{
                                            self.frameModel.removeAll()
                                            self.dataModel.removeAll()
                                            for i in models{
                                                let model = RelatedContentModel.yy_modelWithJSON(i)
                                                
                                                
                                                let frameModel = RelatedFrameModel(model: model)
                                                
                                                self.frameModel.append(frameModel)
                                                self.dataModel.append(model)
                                            }
                                            self.tableView.reloadData()
                                        }
                                    }else{
                                        KVNProgress.showErrorWithStatus("没有搜索到结果")
                                        return
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
        }
    }
}
