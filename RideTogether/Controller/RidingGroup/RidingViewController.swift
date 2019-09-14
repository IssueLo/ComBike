//
//  RidingViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/3.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class RidingViewController: UIViewController {
    
    var groupData: GroupData!
    
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var stopButton: UIButton! {
        
        didSet {
            
            stopButton.layer.cornerRadius = 25
            
            stopButton.layer.borderColor = UIColor.lightGray.cgColor
            
            stopButton.layer.borderWidth = 1
            
            stopButton.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var saveButton: UIButton! {
        
        didSet {
            
            saveButton.layer.cornerRadius = 25
            
            saveButton.layer.borderColor = UIColor.lightGray.cgColor
            
            saveButton.layer.borderWidth = 1
            
            saveButton.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var currentSpeedLabel: UILabel!
    
    @IBOutlet weak var maximumSpeedLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var coverView: UIView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var memberInfo = MemberInfo(memberName: FirebaseAccountManager.shared.userName!)
    
    var locationOfMember = [LocationOfMember]() {
        
        didSet {
            
            memberLocationAnnotation()
        }
    }
    
    var mkPointAnnotation = [MKPointAnnotation]()
    
    let timeManager = TimeManager()
    
    let locationManager = CLLocationManager()
    
    // 紀錄路線
    var currentCoordinates = [CLLocationCoordinate2D]() {
        
        didSet {

            currentRoute()
        }
    }
    
    var currentGeoPoint = [GeoPoint]()
    
    // 紀錄距離
    var totalDistance: Double = 0
    
    // 紀錄最高速度
    var maximumSpeed: Double = 0
    
    // 紀錄海拔高度
    var currentAltitude = [CLLocationDistance]()
    
    let screenWidth = UIScreen.main.bounds.width
    
    var locatonTimer: Timer?
    
    @IBAction func stopRiding() {
        
        timeManager.controlButton(timeLabel)
        
        if stopButton.titleLabel?.text == "停止" {
            
            locatonTimer?.invalidate()
            
            coverView.alpha = 0.4
            
            self.stopButton.setTitle("繼續", for: .normal)
            
            self.saveButton.setTitleColor(.black, for: .normal)
            
            self.stopButton.translatesAutoresizingMaskIntoConstraints = true
            
            self.saveButton.translatesAutoresizingMaskIntoConstraints = true
            
            UIView.animate(withDuration: 0.3) {
                
                self.stopButton.center.x = (self.screenWidth / 2) - (self.stopButton.bounds.width / 2 + 5)
                
                self.saveButton.center.x = (self.screenWidth / 2) + (self.saveButton.bounds.width / 2 + 5)
            }
            
        } else {
            
            locatonTimer = Timer.scheduledTimer(timeInterval: 1,
                                                target: self,
                                                selector: #selector(currentLocaton),
                                                userInfo: nil,
                                                repeats: true)
            
            UIView.animate(withDuration: 0.3) {
                
                self.coverView.alpha = 0

                self.stopButton.setTitle("停止", for: .normal)
                
                self.saveButton.setTitleColor(.lightGray, for: .normal)
                
                self.stopButton.center.x = (self.screenWidth / 2)

                self.saveButton.center.x = (self.screenWidth / 2)
            }
            // chainAnimate
        }
    }
    
    @IBAction func saveRidingData() {
        
        let storyboard = UIStoryboard(name: "RidingResultStoryboard", bundle: nil)
        
        guard
            let ridingResultVC = storyboard.instantiateViewController(withIdentifier: "RidingResultViewControllor")
            as? RidingResultViewController
        else { return }
        
        ridingResultVC.groupData = self.groupData
        
        // 功能：儲存時間/ 距離/ 最高速度/ 路線
        
        memberInfo.spendTime = timeManager.currentSecond
        
        memberInfo.distance = totalDistance
        
        memberInfo.averageSpeed = ((totalDistance / Double(timeManager.currentSecond)) * 3.6)
        
        memberInfo.maximumSpeed = maximumSpeed
        
        memberInfo.route = currentGeoPoint
        
        FirebaseDataManeger.shared.uploadRidingData(groupData.groupID,
                                                    FirebaseAccountManager.shared.userUID!,
                                                    memberInfo)
        
        show(ridingResultVC, sender: nil)
    }
    
    @IBAction func backGroupDetailVC() {
        
//        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        
        // 開始計時
        timeManager.controlButton(timeLabel)
        
        currentLocaton()
        
        let mapButton = MKUserTrackingButton(mapView: mapView)
        
        setupMapViewButton(mapButton)
        
        // 功能：抓取同伴當前位置
        FirebaseDataManeger.shared.observerOfMemberLocation(groupData.groupID) { (locationOfMember) in
            
            if self.locationOfMember.count == 0 {
                
                self.locationOfMember.append(locationOfMember)
                
            } else {
                
                for number in 0..<self.locationOfMember.count {
                    
                    if locationOfMember.name == self.locationOfMember[number].name {
                        
                        self.locationOfMember.remove(at: number)
                        
                    }
                    
                    self.locationOfMember.append(locationOfMember)
                }
                
            }
            
            //                    for number in 0..<ridingViewController.locationOfMember.count {
            //
            //                        if memberName == ridingViewController.locationOfMember[number].name {
            //
            //                            ridingViewController.locationOfMember.remove(at: number)
            //
            //                            let locationOfMember = LocationOfMember(name: memberName,
            //                                                                    location: memberLocation.transferToCoordinate2D())
            //
            //                            ridingViewController.locationOfMember.append(locationOfMember)
            //
            //                        } else {
            //
            //                            continue
            //                        }
            //                    }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locatonTimer = Timer.scheduledTimer(timeInterval: 1,
                                            target: self,
                                            selector: #selector(currentLocaton),
                                            userInfo: nil,
                                            repeats: true)
        
        // 1. 還沒有詢問過用戶以獲得權限
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            //            locationManager.requestAlwaysAuthorization()
        }
            // 2. 用戶不同意
        else if CLLocationManager.authorizationStatus() == .denied {
//            showAlert("Location services were previously denied.
//            Please enable location services for this app in Settings.")
        }
            // 3. 用戶已經同意
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        locatonTimer?.invalidate()
    }
    
    func setupMapViewButton(_ sender: MKUserTrackingButton) {
        
        sender.layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
        
        sender.layer.borderColor = UIColor.white.cgColor
        
        sender.layer.borderWidth = 1
        
        sender.layer.cornerRadius = 5
        
        mapView.addSubview(sender)
        
        sender.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([sender.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -12),
                                     sender.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -12)])
    }
    
    func currentRoute() {
        
        PolylineManager.shared.mapView = self.mapView
        
        PolylineManager.shared.showPolyline(coordinates: currentCoordinates)
    }
    
    @objc func currentLocaton() {
        
        guard let location = locationManager.location else { return }
        
        if location.speed > 0 {
            
            // 上傳當前位置
            FirebaseDataManeger.shared.uploadUserLocation(groupData.groupID,
                                                          FirebaseAccountManager.shared.userUID!,
                                                          location.coordinate)
            
            let speed = String(format: "%.2f", (location.speed) * 3.6)
            
            currentSpeedLabel.text = "\(speed) km/hr"
            
            totalDistance += location.speed
            
            currentAltitude.append(location.altitude)
            
            currentCoordinates.append(location.coordinate)
            
            currentGeoPoint.append(location.coordinate.transferToGeopoint())
            
        } else {
            
            currentSpeedLabel.text = "0.00 km/hr"
        }
        
        if maximumSpeed < location.speed {
            
            maximumSpeed = location.speed
        }
        
        maximumSpeedLabel.text = "\(String(format: "%.2f", (maximumSpeed) * 3.6)) km/hr"
        
        distanceLabel.text = "\(String(format: "%.2f", totalDistance/1000)) km"
    }
    
    func memberLocationAnnotation() {
        
        if mkPointAnnotation.count > 0 {
            
            for _ in 0..<mkPointAnnotation.count {
                
                self.mapView.removeAnnotation(mkPointAnnotation[0])
                
                mkPointAnnotation.remove(at: 0)
            }
        }
        
        for memberLocation in locationOfMember {
            
            if FirebaseAccountManager.shared.userName == memberLocation.name {
                
                continue
            } else {
            
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = memberLocation.location
                
                annotation.title = memberLocation.name
                
                mkPointAnnotation.append(annotation)
                
                self.mapView.addAnnotation(annotation)
            }
        }
    }
}

extension RidingViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func setupMapView() {

        mapView.showsUserLocation = true

        // 2. 配置 locationManager
        locationManager.delegate = self

        // 定位的精確度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // 使用者移動多少距離後會更新座標點
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters

        //        myLocationMgr.startUpdatingLocation()// Start location
        //        myLocationMgr.stopUpdatingLocation()// Stop location

        //        // 3. 配置 mapView
        mapView.delegate = self as MKMapViewDelegate
        
        mapView.showsUserLocation = true
        
        mapView.userTrackingMode = .follow
    }
    
    // Map 路線屬性
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    // 設定標示 icon
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView")
//            ?? MKAnnotationView()
//
//        if annotation is MKUserLocation {
//
////            annotationView.image = UIImage(named: "Icons_BicycleRider")
//
//            return annotationView
//        } else {
//
//            annotationView.image = UIImage(named: "Icons_BicycleRider")
//
//            return annotationView
//        }
//    }
    
}
