//
//  RidingResultViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/3.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit
import MapKit

class RidingResultViewController: UIViewController {
    
    var groupData: GroupData!
    
    var memberResultInfo: [MemberData] = [] {
        
        didSet {
            
            ridingResultTableView.reloadData()
        }
    }
    
    @IBOutlet weak var ridingResultHeaderView: RidingResultHeaderView!
    
    @IBOutlet weak var userRankView: UserRankView!

    @IBOutlet weak var ridingResultTableView: UITableView!
    
    @IBOutlet weak var polylineMapView: MKMapView! {
        
        didSet {
            
            polylineMapView.layer.borderWidth = 1
            
            polylineMapView.delegate = self
        }
    }
    
    @IBOutlet weak var userPolylineView: UserPolylineView!

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let nib = UINib(nibName: "RidingResultCell", bundle: nil)
        
        ridingResultTableView.register(nib, forCellReuseIdentifier: "RidingResultCell")
        
        ridingResultHeaderView.setupHeaderView(groupData.name)
        
        ridingResultHeaderView.handler = {
            
            self.dismiss(animated: true, completion: nil)
            
            self.backToRoot()
        }
        
        userRankView.setupUserRankView(FirebaseAccountManager.shared.userName!,
                                       FirebaseAccountManager.shared.userPhotoURL!,
                                       1,
                                       "st",
                                       "00:00:00")
        
        FirebaseDataManeger.shared.observerOfResult(groupData.groupID)
        { [weak self](result) in
            
            self?.memberResultInfo = result
            
            self?.updateChartsData()
            
            self?.updateMapPolyline()
        }
    }
    
    func updateChartsData() {
        
        for number in 0..<memberResultInfo.count {
            
            if FirebaseAccountManager.shared.userName == memberResultInfo[number].name {
                
                guard let altitudeData = memberResultInfo[number].altitude else { return }
                
                self.userPolylineView.updateChartsData(altitudeData)
            }
        }
    }
    
    func updateMapPolyline() {
        
        for number in 0..<memberResultInfo.count {
            
            if FirebaseAccountManager.shared.userName == memberResultInfo[number].name {
                
                guard let polylineData = memberResultInfo[number].route else { return }
                
                var coordinates = [CLLocationCoordinate2D]()
                
                for geoPoint in polylineData {
                    
                    coordinates.append(geoPoint.transferToCoordinate2D())
                }
                
                let polylineCode = PolylineManager.shared.encodePolyline(coordinates)
                
                PolylineManager.shared.mapView = self.polylineMapView
                
                PolylineManager.shared.showPolyline(polylineCode: polylineCode)
            }
        }

    }
}

extension RidingResultViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memberResultInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ridingResultTableView.dequeueReusableCell(withIdentifier: "RidingResultCell", for: indexPath)
        
        guard let ridingResultCell = cell as? RidingResultCell else { return cell }
        
        let spendTime = TimeManager().secToRealTime(memberResultInfo[indexPath.row].spendTime!)
        
        ridingResultCell.memberNameLabel.text = memberResultInfo[indexPath.row].name
        
        ridingResultCell.rankingLabel.text = String(indexPath.row + 1)
        
        ridingResultCell.spendTimeLebal.text = spendTime
        
        self.updateUserInfo(memberResultInfo[indexPath.row].name,
                            (indexPath.row + 1),
                            spendTime)
        
        return ridingResultCell
    }
    
    func updateUserInfo(_ userName: String, _ userRank: Int, _ spendTime: String) {
        
        if userName == FirebaseAccountManager.shared.userName! {
            
            var userSubRank: String
            
            switch userRank {
            case 1: userSubRank = "st"
            case 2: userSubRank = "nd"
            case 3: userSubRank = "rd"
            default : userSubRank = "th"
            }
            
            self.userRankView.setupUserRankView(userName,
                                                FirebaseAccountManager.shared.userPhotoURL!,
                                                userRank,
                                                userSubRank,
                                                spendTime)

        } else {
            
            return
        }
    }
}

extension RidingResultViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
}

extension RidingResultViewController: MKMapViewDelegate {
    
    // Map 路線屬性
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = UIColor.blue
        
        renderer.lineWidth = 5.0
        
        return renderer
        
    }
}
