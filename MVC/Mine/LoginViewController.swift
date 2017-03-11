//
//  LoginViewController.swift
//  MovieFansDemo1
//
//  Created by 千锋1 on 16/10/8.
//  Copyright © 2016年 琼极无限. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    //MARK: - 属性
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarItemSetting()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
//MARK: - 界面相关
extension LoginViewController{
    
    func navigationBarItemSetting() {
        self.navigationItem.title = "登录"
        
        let rightItem = UIBarButtonItem(title: "注册", style: .Plain, target: self, action: #selector(LoginViewController.registerAction))
        
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
}


//MARK: - 登录按钮点击事件
extension LoginViewController{
    
    @IBAction func loginAction(sender: UIButton) {
        if userName.text != "" && passWord.text != ""{
            KVNProgress.showWithStatus("正在登录...")
            ToolManager.BmobUserLogin(userName.text!, passWord: passWord.text!) { (bool, str) -> Void in
                if bool{
                    //1.存储当前账号
                    NSUserDefaults.standardUserDefaults().setObject(self.userName.text!, forKey: UD_CurrentUserName)
                    //2.存储登录状态
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: UD_LoginStatus)
                    //3.回到上一个界面
                    self.navigationController?.popViewControllerAnimated(true)
                    
                    NSUserDefaults.standardUserDefaults().setObject("", forKey: UD_UserImageUrl)
                    
                    KVNProgress.showSuccessWithStatus(str)
                }else{
                    KVNProgress.showErrorWithStatus(str)
                }
            }
        }else{
            KVNProgress.showErrorWithStatus("账号或密码为空")
        }
    }
    ///微信登录
    @IBAction func wechatLogin(sender: AnyObject) {
        
        //确定登录的平台名称
        let platform = UMSocialSnsPlatformManager.getSocialPlatformWithName(UMShareToWechatSession)
        
        //响应事件
        //参数1：执行操作的控制器
        //参数2：当前控制器的指定操作服务
        //参数3：开启当前控制器的指定操作服务
        //参数4：登录完成之后的回调
        platform.loginClickHandler(self,UMSocialControllerService.defaultControllerService(),true,{response in
            if response.responseCode == UMSResponseCodeSuccess{
                print("登录成功")
                //获取用户主体
                let dic = UMSocialAccountManager.socialAccountDictionary()
                
                let account = dic[platform.platformName] as! UMSocialAccountEntity
                
                
                NSUserDefaults.standardUserDefaults().setObject(account.userName, forKey: UD_CurrentUserName)
                
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: UD_LoginStatus)
                
                NSUserDefaults.standardUserDefaults().setObject(account.iconURL, forKey: UD_UserImageUrl)
                
                self.navigationController?.popToRootViewControllerAnimated(true)
            }else{
                print("登录失败")
            }
        })
        
    }
    
    ///注册按钮点击事件
    func registerAction(){
        let register = RegisterViewController()
        
        //实现闭包传值
        register.sendValue = {(value) in
        
            self.userName.text = value
        }
        
        
        self.navigationController?.pushViewController(register, animated: true)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}