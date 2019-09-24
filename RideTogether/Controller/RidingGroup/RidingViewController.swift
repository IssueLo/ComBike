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

// swiftlint:disable file_length
class RidingViewController: UIViewController {
    
    var groupData: GroupData!
    
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var stopButton: UIButton! {
        
        didSet {
            
            stopButton.addRound(backgroundColor: .hexStringToUIColor())
            
            stopButton.setTitleColor(.white, for: .normal)
            
            saveButton.addTarget(self, action: #selector(stopRiding), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var saveButton: UIButton! {
        
        didSet {
            
            saveButton.addRound(backgroundColor: .hexStringToUIColor())
            
            saveButton.setTitleColor(.white, for: .normal)
            
            saveButton.addTarget(self, action: #selector(saveRidingData), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var currentSpeedLabel: UILabel!
    
    @IBOutlet weak var maximumSpeedLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var coverView: UIView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var memberInfo = MemberData(memberName: FirebaseAccountManager.shared.userName!,
                                memberNameUID: FirebaseAccountManager.shared.userUID!)
    
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
    
    @objc func stopRiding() {
        
        timeManager.controlButton(timeLabel)
        
        if stopButton.titleLabel?.text == "停止" {
            
            locatonTimer?.invalidate()
            
            locationManager.stopUpdatingLocation()
            
            coverView.alpha = 0.4
            
            self.stopButton.setTitle("繼續", for: .normal)
            
            self.stopButton.backgroundColor = .black
                        
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
            
            locationManager.startUpdatingLocation()
            
            UIView.animate(withDuration: 0.3) {
                
                self.coverView.alpha = 0

                self.stopButton.setTitle("停止", for: .normal)
                
                self.stopButton.backgroundColor = .hexStringToUIColor()
                                
                self.stopButton.center.x = (self.screenWidth / 2)

                self.saveButton.center.x = (self.screenWidth / 2)
            }
            // chainAnimate
        }
    }
    
    @objc func saveRidingData() {
        
        locatonTimer?.invalidate()
        
        locationManager.stopUpdatingLocation()
        
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
        
        memberInfo.altitude = currentAltitude
        
        FirebaseDataManeger.shared.uploadRidingData(groupData.groupID,
                                                    FirebaseAccountManager.shared.userUID!,
                                                    memberInfo)
        
        show(ridingResultVC, sender: nil)
    }
    
    @IBAction func backGroupDetailVC() {
        
        dismiss(animated: true, completion: nil)
//        navigationController?.popViewController(animated: true)
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
        FirebaseDataManeger.shared.observerOfMemberLocation(groupData.groupID) { [weak self](locationOfMember) in
            
            guard let countOfMember = self?.locationOfMember.count else {
                
                return
            }
            
            if countOfMember == 0 {
                
                self?.locationOfMember.append(locationOfMember)
                
            } else {
                
                for number in 0..<countOfMember {
                    
                    if locationOfMember.name == self?.locationOfMember[number].name {
                        
                        self?.locationOfMember.remove(at: number)
                        
                        break
                    }
                    
                    continue
                }
                
                self?.locationOfMember.append(locationOfMember)
            }
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
        
        locationManager.stopUpdatingLocation()
    }
    
    func setupMapViewButton(_ sender: MKUserTrackingButton) {
        
        sender.addRound(radis: 5, borderColor: .white, backgroundColor: UIColor(white: 1, alpha: 0.8))
        
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

        //        // 3. 配置 mapView
        mapView.delegate = self as MKMapViewDelegate
        
        mapView.showsUserLocation = true
        
        mapView.userTrackingMode = .follow
    }
    
    // Map 路線屬性
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .hexStringToUIColor()
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
// swiftlint:enable file_length
