//
//  ClassicLineTableViewCell.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/20.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit

class ClassicLineTableViewCell: UITableViewCell,MAMapViewDelegate {

    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    var model:lineModel? = nil{
        didSet{
                self.addPoints(model!.days![0].points)
            
        }
    }
    
    var mapView = MAMapView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //totalLabel.layer.borderWidth = 1
        
        mapView = MAMapView(frame: self.bounds)
        
        mapView.delegate = self
        
        mapView.showsScale = false
        
        //底层标注
        mapView.showsLabels = false
        
        mapView.scrollEnabled = false
        
        
        
        self.addSubview(mapView)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let y = self.totalLabel.frame.size.height + self.totalLabel.frame.origin.y + 8
        
        let w = screenW - 16
        
        let h = self.daysLabel.frame.origin.y - y - 8
        
        self.mapView.frame = CGRectMake(8, y, w, h)
    }
    
    
    
    
    
    //MARK: -添加点标记
    func addPoints(pois:[PointModel]){
        
        var points = [CLLocationCoordinate2D]()
        
        var annotations = [MAPointAnnotation]()
        
        
        for item in pois{
            let point = MAPointAnnotation()
            point.coordinate = CLLocationCoordinate2DMake(Double(item.poi!.lat)!,Double(item.poi!.lng)!)
            point.title = item.poi!.name
            mapView.addAnnotation(point)
            points.append(CLLocationCoordinate2DMake(Double(item.poi!.lat)!,Double(item.poi!.lng)!))
            annotations.append(point)
        }
        //显示所有的标注
        mapView.showAnnotations(annotations, animated: true)
        //绘制折线
        let line = MAPolyline(coordinates: &points, count: UInt(points.count))
        
        self.mapView.addOverlay(line)
        
    }
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
