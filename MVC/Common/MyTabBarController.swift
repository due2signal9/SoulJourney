//
//  MyTabBarController.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/18.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        creatViewControllers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///MARK: -  添加视图控制器
    func creatViewControllers(){
        let titles = ["首页","足迹","行程","我的"]
        let imageArray = ["shouye","zuji1","xingcheng2","wo"]
        
        let vc1 = HomePageViewController()
        let nav1 = UINavigationController(rootViewController: vc1)
        
        let vc2 = TrackViewController()
        let nav2 = UINavigationController(rootViewController: vc2)
        
        let vc3 = ScheduleViewController()
        let nav3 = UINavigationController(rootViewController: vc3)
        
        let vc4 = MineViewController()
        let nav4 = UINavigationController(rootViewController: vc4)
        
        let vcArray = [vc1,vc2,vc3,vc4]
        let navArray = [nav1,nav2,nav3,nav4]
        
        for i in 0...vcArray.count-1{
            
            navArray[i].tabBarItem.title = titles[i]
            navArray[i].tabBarItem.image = UIImage(named: imageArray[i])?.imageWithRenderingMode(.AlwaysOriginal)
            navArray[i].tabBarItem.selectedImage = UIImage(named: "\(imageArray[i])_selected")?.imageWithRenderingMode(.AlwaysOriginal)
            
            
            vcArray[i].navigationItem.title = titles[i]
            vcArray[i].navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.boldSystemFontOfSize(17)]
        }
        
        self.viewControllers = navArray
        
        //通用属性
     UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.greenColor()], forState: .Selected)
        
        self.tabBar.barTintColor = UIColor.whiteColor()
    }

}
