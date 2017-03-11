//
//  ToolManager.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/18.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit
import Kingfisher

//MARK: - 全局变量

//MARK: - NSUserDefualts的key
///当前用户名
let UD_CurrentUserName = "UD_CurrentUserName"
///当前的登录状态
let UD_LoginStatus = "UD_LoginStatus"
///用户头像
let UD_UserImageUrl = "UD_UserImageUrl"


///屏幕宽度
let screenW = UIScreen.mainScreen().bounds.size.width
///屏幕高度
let screenH = UIScreen.mainScreen().bounds.size.height


//MARK: -数据接口
///首页的头视图
let URL_Header = "http://q.chanyouji.com/api/v1/adverts.json"
///首页
let URL_HomePage = "http://q.chanyouji.com/api/v2/destinations.json"
///首页列表  area=china  area为参数名，值有china，asia，europe
let URL_HomeList = "http://q.chanyouji.com/api/v2/destinations/list.json"
///足迹列表  page:页数  per:每一页的个数
let URL_TrackList = "http://q.chanyouji.com/api/v1/timelines.json"
///首页详情 需拼接id.json
let URL_HomePageDetail = "http://q.chanyouji.com/api/v3/destinations/"
///根据定位推荐附近景点 lat=30.66459165966441    lng=104.03882239208 
let URL_NearList = "http://q.chanyouji.com/api/v2/destinations/nearby.json"
///某个范围内的 area=china   asia 亚洲  europe欧洲
let URL_AreaList = "http://q.chanyouji.com/api/v2/destinations/list.json"


class ToolManager: NSObject {
    ///将view的内容转换成Image
    static func viewForImage(view:UIView) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, view.layer.contentsScale)
        
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        return image
    }
    
    
    
    
    //MARK: - 将字符串转换成需要的时间格式的字符串
    static func transform(str:String)->String{
        let format = NSDateFormatter()
        
        
        
        
        format.dateStyle = .LongStyle
        format.timeStyle = .LongStyle
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let nsStr = str as NSString
        let newStr = nsStr.substringWithRange(NSRange(location: 0,length: 10))
        
        
        //let date = format.dateFromString(newStr)
        //format.stringFromDate(date!)
        return newStr
    }
    ///计算指定字符串的大小
    static func calulateStringSize(str:String,maxW:CGFloat,maxH:CGFloat,fontSize:CGFloat) -> CGSize{
        let ocStr = str as NSString
        let size = ocStr.boundingRectWithSize(CGSizeMake(maxW, maxH), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(fontSize)], context: nil).size
        
        return size
    }
    ///根据要裁剪的图片范围，给出一个新的图片 
    static func cutImageWithRect(image:UIImage,model:PhotoModel,height:CGFloat,width:CGFloat) -> UIImage{
        
        let x:CGFloat = 0
        
        let w = Double(model.width)
        
        let h = height/width*CGFloat(w!)
        
        let r_H = Double(model.height)
        
        let y = (CGFloat(r_H!) - (height/width)*CGFloat(w!))/2
        
        let cgRef = image.CGImage
        
        let imageRef = CGImageCreateWithImageInRect(cgRef,CGRectMake(x,y, CGFloat(w!), h))
        
        let newImage = UIImage(CGImage: imageRef!)
        
        return newImage
    }
    ///清除kingfisher内存缓存
    static func memoryClean(){
        
        print("清除")
        
        let cache = KingfisherManager.sharedManager.cache
        
        cache.clearMemoryCache()
    }
    
    ///数据库增加数据
    static func addTrack(model:lineModel,photoUrl:String){
        let saveModel = TrackLineModel.MR_createEntity()
        
        //对属性进行赋值
        saveModel.title = model.title
        saveModel.photo_url = photoUrl
        saveModel.date = transform(String(NSDate()))
        saveModel.daycount = Int(model.days_count)
        saveModel.id = model.destination_id
        
        //同步保存到数据库
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    ///数据库删除数据
    static func deleteTrack(id:String){
        //指明需要删除的数据
        let models = TrackLineModel.MR_findByAttribute("title", withValue: id)
        
        //循环遍历查找结果
        for model in models{
            model.MR_deleteEntity()
        }
        //同步保存数据到数据库
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    ///数据库查询全部数据
    static func queryAll() -> [TrackLineModel]{
        //查询全部的数据
        let models = TrackLineModel.MR_findAll() as! [TrackLineModel]
        
       return models
    }
    ///按条件查询数据
    static func queryOne(title:String) -> TrackLineModel?{
        //指明需要删除的数据
        let models = TrackLineModel.MR_findByAttribute("title",withValue: title)
        
        if models.count > 0{
            return models[0] as? TrackLineModel
        }
        return nil
        
    }
    
    //创建一个云存储的方法
    static  func BmobUserRegister(userName:String,passWord:String,email:String,result:(Bool,String)->Void){
        //1.创建一个数据对象
        let user = BmobUser.init()
        
        //2.设置数据对象
        user.username = userName
        user.password = passWord
        user.email = email
        
        user.signUpInBackgroundWithBlock({ (sucess, error) -> Void in
            if sucess{
                result(true,"注册成功，需邮箱验证")
            }else if ((error) != nil){
                result(false,"账号或邮箱已经存在")
            }else{
                result(false,"未知错误")
            }
        })
        
    }
    
    static func BmobUserLogin(userName:String,passWord:String,result:(Bool,String)->Void){
        BmobUser.loginInbackgroundWithAccount(userName, andPassword: passWord) { (user, error) -> Void in
            if (user != nil){
                user.userEmailVerified({ (bool, error) -> Void in
                    if bool{
                        result(true,"登录成功")
                    }else{
                        result(false,"邮箱没有验证，请验证邮箱")
                    }
                })
            }else{
                if error.code == 404 {
                    result(false,"网络错误")
                }else{
                    result(false,"用户名或密码错误")
                }
            }
        }
        
        
    }

    
}
