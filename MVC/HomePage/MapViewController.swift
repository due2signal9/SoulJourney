//
//  MapViewController.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/25.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit

class MapViewController: UIViewController,MAMapViewDelegate {

    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var mapView: MAMapView!
    
    //数据源数组
    var model:lineModel? = nil
    //标注点数组
    var allAnnotations = [[MAPointAnnotation]]()
    
    //线的数组
    var lineArray = [MAPolyline]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        self.addPoints(model!.days!)
        
        myCollectionView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        myCollectionView.registerNib(UINib(nibName: "MapCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        ToolManager.memoryClean()
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        
        //ToolManager.memoryClean()
        
    }
    
    //MARK: -添加点标记
    func addPoints(days:[DayModel]){
        
        var points = [CLLocationCoordinate2D]()
        
        var annotations = [MAPointAnnotation]()
        
        
        for item in days{
            var tempAnnotation = [MAPointAnnotation]()
            for item1 in item.points{
                let anotation = MAPointAnnotation()
                
                anotation.title = item1.poi?.name
                
                let coordinate = CLLocationCoordinate2DMake(Double(item1.poi!.lat)!, Double(item1.poi!.lng)!)
                
                anotation.coordinate = coordinate
                
                annotations.append(anotation)
                tempAnnotation.append(anotation)
                points.append(coordinate)
            }
            self.allAnnotations.append(tempAnnotation)
            //绘制折线
            let line = MAPolyline(coordinates: &points, count: UInt(points.count))
            
            self.mapView.addOverlay(line)
            
            self.lineArray.append(line)
            
            points.removeAll()
            
            
        }
        mapView.addAnnotations(annotations)
        //显示所有的标注
        mapView.showAnnotations(annotations, animated: false)
        
        
        
        
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
}
//MARK: - collectionView协议
extension MapViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! MapCollectionCell
        if indexPath.row == 0{
            cell.titleLabel.font = UIFont.systemFontOfSize(13)
            cell.titleLabel.text = "Day\(indexPath.section+1)"
            cell.titleLabel.textColor = UIColor.greenColor()
        }else{
            cell.titleLabel.font = UIFont.systemFontOfSize(10)
            cell.titleLabel.textColor = UIColor.blackColor()
            cell.titleLabel.text = "\(indexPath.row)\n" + (model?.days![indexPath.section].points[indexPath.row-1].poi?.name)!
        }
        
        
        
        cell.backgroundColor = UIColor.whiteColor()
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (model?.days![section].points.count)!+1
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return model!.days!.count
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(50, 50)
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0{
            self.mapView.removeOverlays(lineArray)
            for (i,item) in self.allAnnotations.enumerate(){
                self.mapView.removeAnnotations(item)
                
                if i == indexPath.section{
                    self.mapView.addOverlay(lineArray[i])
                    self.mapView.addAnnotations(item)
                    self.mapView.showAnnotations(item, animated: false)
                }
            }
            
        }else{
            
            self.mapView.selectAnnotation(self.allAnnotations[indexPath.section][indexPath.row-1], animated: false)
        }
    }
   
}
