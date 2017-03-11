//
//  MineViewController.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/18.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit

class MineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    let imageView = UIImageView()
    
    let iconImageView = UIImageView()
    
    let namelabel = UILabel()
    
    var tableView = UITableView()
    
    var dataModel = [["我的记事本","意见反馈"],["关于应用","开发者信息"],["清理缓存"]]
    var imageModel = [["笔记","意见-2"],["关于","icon-开发者信息"],["清理缓存"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.translucent = false
        
        self.navigationController?.navigationBar.titleTextAttributes  = [NSFontAttributeName:UIFont.boldSystemFontOfSize(17)]
        
        imageView.frame = CGRectMake(0, 0, screenW, 200)
        let path = NSBundle.mainBundle().pathForResource("bizhi", ofType: "jpg")
        imageView.image = UIImage(contentsOfFile: path!)
        iconImageView.frame = CGRectMake(0, 0, 80, 80)
        iconImageView.center = imageView.center
        iconImageView.image = UIImage(named: "Image_head")
        iconImageView.layer.cornerRadius = 40
        
        namelabel.frame = CGRectMake(0, iconImageView.frame.origin.y+iconImageView.frame.size.height+20, screenW, 20)
        namelabel.textAlignment = .Center
        namelabel.text = "点击登录"
        namelabel.textColor = UIColor.whiteColor()
        
        
        self.imageView.addSubview(namelabel)
        self.imageView.addSubview(iconImageView)
        
        let button = UIButton(frame: CGRectMake(0, 0, screenW, 200))
        button.addTarget(self, action: "btnAction", forControlEvents: .TouchDown)
        
        
        
        tableView = UITableView(frame: self.view.bounds, style: .Grouped)
        tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 5
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView)
        
        self.view.addSubview(imageView)
        
        self.view.addSubview(button)
        
    }
    func btnAction(){
        if NSUserDefaults.standardUserDefaults().boolForKey(UD_LoginStatus){
            let user = UserInfoViewController()
            user.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(user, animated: true)
        }else{
            let login = LoginViewController()
            
            login.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(login, animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let isLogin = NSUserDefaults.standardUserDefaults().boolForKey(UD_LoginStatus)
        if isLogin {
            //显示当前账号
            let userName = NSUserDefaults.standardUserDefaults().objectForKey(UD_CurrentUserName) as! String
            namelabel.text = userName
            if let userImageUrl = NSUserDefaults.standardUserDefaults().objectForKey(UD_UserImageUrl) as? String{
                if userImageUrl != ""{
                    self.iconImageView.sd_setImageWithURL(NSURL(string: userImageUrl), placeholderImage: nil, completed: { (image, error,cacheType, url) -> Void in
                        self.iconImageView.layer.masksToBounds = true
                        self.iconImageView.layer.cornerRadius = 40
                    })
                }else{
                    iconImageView.image = UIImage(named: "Image_head")
                }
                
            }
        }else{
            iconImageView.image = UIImage(named: "Image_head")
            namelabel.text = "点击登录"
        }

    }
    
    
    //tableView的协议代理
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel[section].count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataModel.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section{
        case 0:
            if indexPath.row == 0{
                if NSUserDefaults.standardUserDefaults().boolForKey(UD_LoginStatus){
                
                let vc = UIStoryboard(name: "Note", bundle: nil).instantiateInitialViewController()
                
                vc!.hidesBottomBarWhenPushed = true
                
                self.navigationController?.pushViewController(vc!, animated: true)
                }else{
                    KVNProgress.showErrorWithStatus("请登录")
                }
            }else{
                let vc = IdeaViewController()
                
                vc.hidesBottomBarWhenPushed = true
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 1:
            if indexPath.row == 0{
                let vc = AboutViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = DeveloperViewController()
                vc.hidesBottomBarWhenPushed = true
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 2:
            if indexPath.row == 0{
                cleanDask()
            }
        default:
            break
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = dataModel[indexPath.section][indexPath.row]
        cell.imageView?.image = UIImage(named: imageModel[indexPath.section][indexPath.row])
        cell.selectionStyle = .         None
        
        return cell
    }
    
    //MARK: - 清除缓存
    func cleanDask(){
        //获取缓存文件的路径----沙盒目录下Library文件夹下的Cache文件夹
        let cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
        
        
        //定义变量，用于计算所有子文件的大小
        var size = Double()
        
        //获取Cache文件夹下的所有文件
        //NSFileManager系统文件管理类
        let fileArray = NSFileManager.defaultManager().subpathsAtPath(cachePath!)
        
        //遍历数组，计算每个子文件的大小
        for fileName in fileArray!{
            //拼接每个子文件的路径
            let filePath = cachePath! + "/\(fileName)"
            //获取每个子文件的属性
            let fileAttribute = try! NSFileManager.defaultManager().attributesOfItemAtPath(filePath)
            
            for (fileAtt,fileSize) in fileAttribute{
                if fileAtt == NSFileSize{
                    size = size + fileSize.doubleValue //单位为字节
                }
            }
        }
        //提示框---保留小数点后两位,单位为M
        let message = String(format: "当前有%.2fM缓存", size/1024/1024)
        
        
        let alertVC = UIAlertController(title: "提示", message: message, preferredStyle: .Alert)
        
        let conformAction = UIAlertAction(title: "确定", style: .Default) { (action) -> Void in
            for fileName in fileArray!{
                //拼接每个子文件的路径
                let filePath = cachePath! + "/\(fileName)"
                //判断当前路径下的文件存在的情况下
                if NSFileManager.defaultManager().fileExistsAtPath(filePath){
                    do{
                        try NSFileManager.defaultManager().removeItemAtPath(filePath)
                        KVNProgress.showSuccessWithStatus("清除成功")
                    }catch{
                        
                    }
                    
                }
            }
        }
        let cancleAction = UIAlertAction(title: "取消", style: .Default, handler: nil)
        
        alertVC.addAction(conformAction)
        alertVC.addAction(cancleAction)
        
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
}
