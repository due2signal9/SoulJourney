//
//  HomePageViewController.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/18.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire

class HomePageViewController: UIViewController {
    //MARK: - 属性
    var timer:NSTimer?
    
    //定位服务
    //初始化定位
    var locationManager = AMapLocationManager()
    
    //MARK: - 控件属性
    var tableView = UITableView()
    
    //创建一个collection用来轮播图
    var collectionView:UICollectionView?
    
    //pageControll
    var pageControll = UIPageControl()
    
    //头视图
    let header = UIView()
    
    ///创建一个毛玻璃对象
    var effectView = UIVisualEffectView()
    
    
    //头视图数据源数组
    lazy var headerDataArray:[HeaderModel] = {
        return [HeaderModel]()
    }()
    //tableView的总数据
    lazy var dataArray:[HomePageModel] = {
        return [HomePageModel]()
    }()
    
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        //增加定时器
        timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: "nextPage", userInfo: nil, repeats: true)
        
        
        
        //设置导航条的透明度
        setNavegationAlpha(0)
        
        creatUI()
        
        navigationSetting()
        
        getNetData()
        
        getTableViewData()
        
        //开始定位
        location()
        
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        ToolManager.memoryClean()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if tableView.contentOffset.y <= -64{
            setNavegationAlpha(0)
            timer?.fireDate = NSDate.distantPast()
        }else{
            setNavegationAlpha(1)
            
        }
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let nav = self.navigationController?.navigationBar{
            if let bgView = nav.valueForKey("_backgroundView") as? UIView{
                bgView.alpha = 1
            }
        }
        timer?.fireDate = NSDate.distantFuture()
        
        
        
    }
    
    deinit{
        timer?.invalidate()
    }
}
//MARK: - 设置导航条的透明度
extension HomePageViewController{
    func setNavegationAlpha(alpha:CGFloat){
        if let nav = self.navigationController?.navigationBar{
            if let bgView = nav.valueForKey("_backgroundView") as? UIView{
                bgView.alpha = 0
            }
            if alpha == 1{
                nav.titleTextAttributes = [NSForegroundColorAttributeName:UIColor(red:1, green: 1, blue: 1, alpha: 1)]
            }else{
                nav.titleTextAttributes = [NSForegroundColorAttributeName:UIColor(red:1, green: 1, blue: 1, alpha: 0)]
            }
        }
        
    }
}
//MARK: - 界面相关
extension HomePageViewController{
    func creatUI(){
        
        //设置
        
        
        //设置tableView
        tableView = UITableView(frame: CGRectMake(0, 0, screenW, screenH-49), style: .Plain)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(UINib(nibName: "HomePageTableViewCell", bundle: nil), forCellReuseIdentifier: "cell1")
        
        tableView.rowHeight = 400
        
        tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0)
        
        tableView.showsVerticalScrollIndicator = false
        
        //设置collectionView
        let layout = UICollectionViewFlowLayout()
        
        collectionView = UICollectionView(frame: CGRectMake(0,0,self.view.bounds.width,200), collectionViewLayout: layout)
        
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView?.pagingEnabled = true
        self.collectionView?.contentOffset = CGPointMake(5000*CGFloat(self.headerDataArray.count)*screenW, 0)
        
        
        collectionView?.showsHorizontalScrollIndicator = false
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        layout.scrollDirection = .Horizontal
        
        //设置page
        pageControll.frame = CGRectMake(0, 180, screenW, 20)
        pageControll.currentPageIndicatorTintColor = UIColor.whiteColor()
        
        
        
        
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.addSubview(tableView)
        
        
        //头
        header.frame = CGRectMake(0, 0, screenW, 200)
        header.addSubview(collectionView!)
        header.addSubview(pageControll)
        
        self.view.addSubview(header)
        
        
        
        //毛玻璃
        let blur = UIBlurEffect(style: .Light)
        effectView = UIVisualEffectView(effect: blur)
        effectView.frame = CGRectMake(0, 0, screenW, 64)
        effectView.hidden = true
        
        self.view.addSubview(effectView)
        
    }
    // 头视图的轮播
    ///用于定时器轮播的触发的函数
    func nextPage(){
        if headerDataArray.count > 0 {
            self.collectionView?.setContentOffset(CGPointMake(collectionView!.contentOffset.x+screenW, 0), animated: true)
            let current = Int(collectionView!.contentOffset.x/screenW+1)%headerDataArray.count
            self.pageControll.currentPage = Int(current)
        }
    }
    ///导航条的设置
    func navigationSetting(){
        let rightBtn = UIBarButtonItem(image: UIImage(named: "search.png")?.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: "SearchAction")
        
        self.navigationItem.rightBarButtonItem = rightBtn
    }
}
//MARK: - collectionView的协议
extension HomePageViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
        if headerDataArray.count > 0{
            let model = headerDataArray[indexPath.row%headerDataArray.count]
            let imageView = UIImageView()
            //imageView.kf_setImageWithURL(NSURL(string:model.photo!.photo_url)!, placeholderImage: nil)
            imageView.sd_setImageWithURL(NSURL(string:model.photo!.photo_url)!, placeholderImage: nil)
            
            cell.backgroundView = imageView
            
            
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10000
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(screenW, collectionView.frame.size.height)
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView == collectionView{
            if headerDataArray.count > 0{
                self.pageControll.currentPage = Int(collectionView!.contentOffset.x/self.view.bounds.width)%headerDataArray.count
            }
        }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == tableView{
            if scrollView.contentOffset.y <= -64 && scrollView.contentOffset.y > -200{
                self.header.frame.origin.y = -(scrollView.contentOffset.y + 200)
                self.setNavegationAlpha(0)
                effectView.hidden = true
                timer?.fireDate = NSDate.distantPast()
            }else if scrollView.contentOffset.y <= -200 {
                self.header.frame.origin.y = -(scrollView.contentOffset.y + 200)
            }
            else if scrollView.contentOffset.y > -64{
                self.header.frame.origin.y = -136
                self.setNavegationAlpha(1)
                effectView.hidden = false
                timer?.fireDate = NSDate.distantFuture()
            }
        }
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let topVC = TopDetailViewController()
        topVC.id = self.headerDataArray[indexPath.row%3].target_id
        
        topVC.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(topVC, animated: true)
    }
}
//MARK: - 获取网络数据
extension HomePageViewController{
    func getNetData(){
        Alamofire.request(.GET, URL_Header, parameters: nil, encoding: .URL, headers: nil).responseJSON(options: .MutableContainers) { (data) -> Void in
            if let json = data.result.value {
                if let dataArray = json.objectForKey("data") as? NSArray{
                    for item in dataArray{
                        let model = HeaderModel.yy_modelWithJSON(item)
                        
                        
                        
                        self.headerDataArray.append(model)
                        
                        print(model.id)
                        
                    }
                    
                    self.collectionView?.reloadData()
                    
                    self.pageControll.numberOfPages = self.headerDataArray.count
                    
                }
            }
        }
    }
    func getTableViewData(){
        Alamofire.request(.GET, URL_HomePage, parameters: nil, encoding: .URL, headers: nil).responseJSON(options: .MutableContainers) { (data) -> Void in
            if let json = data.result.value{
                if let dataArr = json.objectForKey("data") as? NSArray{
                    for item in dataArr{
                        let model = HomePageModel.yy_modelWithJSON(item)
                        
                        self.dataArray.append(model)
                        
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    func getNearData(lat:String,lng:String){
        Alamofire.request(.GET, URL_NearList, parameters: ["lat":"\(lat)","lng":"\(lng)"], encoding: .URL, headers: nil).responseJSON { (data) -> Void in
            if let json = data.result.value{
                if let dataArr = json.objectForKey("data") as? NSArray{
                    let model = HomePageModel()
                    var homeListModes = [HomePageListModel]()
                    for item in dataArr{
                        let pageModel = HomePageListModel.yy_modelWithJSON(item)
                        homeListModes.append(pageModel)
                    }
                    model.button_text = "附近\(homeListModes.count)处景点"
                    model.destinations = homeListModes
                    model.name = "附近景点"
                    model.region = "near"
                    self.dataArray.insert(model, atIndex: 0)
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
}
//MARK: - tableView协议
extension HomePageViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! HomePageTableViewCell
        if dataArray.count > 0{
            cell.model = dataArray[indexPath.section]
            cell.delegate = self
            cell.section = indexPath.section
            cell.MainImageView.tag = indexPath.section
            cell.MainImageView.addtarget(self, action: "pushAction:")
        }
        
        cell.selectionStyle = .None
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func pushAction(imageView:CanTouchImageView){
        let detailVC = HomePageDetailViewController()
        detailVC.hidesBottomBarWhenPushed = true
        
        detailVC.name = dataArray[imageView.tag].destinations![1].name
        detailVC.id = dataArray[imageView.tag].destinations![1].id
        detailVC.photoUrl = dataArray[imageView.tag].destinations![1].photo!.photo_url
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
//MARK: - 跳转其他控制器协议
extension HomePageViewController:PushOtherControllerDelegate{
    func pushController(section: Int, index: Int) {
        let detailVC = HomePageDetailViewController()
        detailVC.hidesBottomBarWhenPushed = true
        
        detailVC.name = dataArray[section].destinations![index].name
        detailVC.id = dataArray[section].destinations![index].id
        detailVC.photoUrl = dataArray[section].destinations![index].photo!.photo_url
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    func pushAllLandController(region: String) {
        let allVC = AllLandViewController()
        allVC.region = region
        if region == "near"{
            allVC.model = self.dataArray[0].destinations
        }
        
        allVC.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(allVC, animated: true)
    }
}
//MARK: - 点击相关
extension HomePageViewController{
    func SearchAction(){
        let searchVC = SearchViewController()
        
        searchVC.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(searchVC, animated: true)
        
    }
}

//MARK: - 定位相关
extension HomePageViewController:AMapLocationManagerDelegate{
    func location(){
        
        locationManager.delegate = self
        
        //locationManager.startUpdatingLocation()
        
        
        //一次定位误差在百米左右
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        //开始定位，带有地理信息
        locationManager.requestLocationWithReGeocode(true) { (location, regeocode, error) -> Void in
            if (error != nil) {
                print("定位失败： \(error)")
            }
            
            if location != nil{
                print(location.coordinate.latitude,location.coordinate.longitude)
                
                self.getNearData(String(location.coordinate.latitude), lng:String(location.coordinate.longitude))
                
                self.locationManager.stopUpdatingLocation()
            }
            
            if (regeocode != nil) {
                print("定位信息： \(regeocode)")
            }
        }
    }
}

