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
            
            DispatchQueue.main.async {
                
                self.ridingResultTableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var ridingResultHeaderView: RidingResultHeaderView!
    
    @IBOutlet weak var userRankView: UserRankView!

    @IBOutlet weak var ridingResultTableView: UITableView! {
       
        didSet {
            
            ridingResultTableView.contentInset.bottom = 12
            
            ridingResultTableView.contentInset.top = 12
        }
    }
    
    @IBOutlet weak var polylineMapView: MKMapView! {
        
        didSet {
                        
            polylineMapView.delegate = self
        }
    }
    
    @IBOutlet weak var userPolylineView: UserPolylineView!
    
    @IBOutlet weak var resultScrollView: UIScrollView! {
        
        didSet {
            
            resultScrollView.delegate = self
        }
    }
    
    @IBOutlet weak var resultPageController: UIPageControl! {
        
        didSet {
            
//            resultPageController.addTarget(self,
//                                           action: #selector(resultPageControll),
//                                           for: .touchUpInside)
        }
    }
    
    @IBAction func resultPageControll(_ sender: UIPageControl) {
        
        // 依照目前圓點在的頁數算出位置
        var frame = resultScrollView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0

        // 再將 UIScrollView 滑動到該點
        resultScrollView.scrollRectToVisible(frame, animated: true)
        
//        let currentPageNumber = sender.currentPage
//        let width = resultScrollView.frame.size.width
//        let offset = CGPoint(x: width * CGFloat(currentPageNumber), y: 0)
//        //讓ScrollView隨著PageControl到達我們要的位置
//        resultScrollView.setContentOffset(offset, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let nib = UINib(nibName: "RidingResultCell", bundle: nil)
        
        ridingResultTableView.register(nib, forCellReuseIdentifier: "RidingResultCell")
        
        ridingResultHeaderView.setupHeaderView(groupData.name)
        
        ridingResultHeaderView.handler = {
            
            self.dismiss(animated: true, completion: nil)
            
            self.backToRoot()
        }
        
        if FirebaseAccountManager.shared.userPhotoURL != nil {
            
            userRankView.setupUserRankView(FirebaseAccountManager.shared.userName!,
                                           FirebaseAccountManager.shared.userPhotoURL!,
                                           0,
                                           "",
                                           "00：00：00")
            
        } else {
            
            userRankView.setupUserRankView(FirebaseAccountManager.shared.userName!,
                                           0,
                                           "",
                                           "00：00：00")
        }
        
        FirebaseDataManeger.shared.observerOfResult(groupData.groupID) { [weak self](result) in
            
            self?.memberResultInfo = result
            
            self?.updateChartsData()
            
            self?.updateMapPolyline()
        }
        
        resultPageController.currentPage = 0
    }
    
    func updateChartsData() {
        
        for number in 0..<memberResultInfo.count
            where FirebaseAccountManager.shared.userName == memberResultInfo[number].name {
            
//            if FirebaseAccountManager.shared.userName == memberResultInfo[number].name {
                
                guard let altitudeData = memberResultInfo[number].altitude else { return }
                
                self.userPolylineView.updateChartsData(altitudeData)
//            }
        }
    }
    
    func updateMapPolyline() {
        
        for number in 0..<memberResultInfo.count
            where FirebaseAccountManager.shared.userName == memberResultInfo[number].name {
            
//            if FirebaseAccountManager.shared.userName == memberResultInfo[number].name {
                
                guard let polylineData = memberResultInfo[number].route else { return }
                
                if polylineData.count == 0 {
                    
                    return
                }
                
                var coordinates = [CLLocationCoordinate2D]()
                
                for geoPoint in polylineData {
                    
                    coordinates.append(geoPoint.transferToCoordinate2D())
                }
                
                let polylineCode = PolylineManager.shared.encodePolyline(coordinates)
                
                PolylineManager.shared.mapView = self.polylineMapView
                
                PolylineManager.shared.showPolyline(polylineCode: polylineCode)
//            }
        }

    }
}

extension RidingResultViewController {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
//        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
//
//        resultPageControl.currentPage = page
        
        let currentPage = Int(resultScrollView.contentOffset.x / resultScrollView.frame.size.width)
        
        resultPageController.currentPage = currentPage
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
        
        let memberUID = memberResultInfo[indexPath.row].uid
        
        FirebaseDataManeger.shared.searchMemberPhoto(memberUID: memberUID) { (result) in
            
            switch result {
                
            case .success(let photoURLString):
                
                guard let photoURLString = photoURLString else {
                    
                    ridingResultCell.memberImage.image = UIImage(named: "UChu")
                    
                    return
                }
                
                ridingResultCell.memberImage.setImage(urlString: photoURLString)
                
                return
                
            case .failure:
                
                return
            }
        }
            
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
            
            if FirebaseAccountManager.shared.userPhotoURL != nil {
                
                self.userRankView.setupUserRankView(userName,
                                                    FirebaseAccountManager.shared.userPhotoURL!,
                                                    userRank,
                                                    userSubRank,
                                                    spendTime)
            } else {
                
                self.userRankView.setupUserRankView(userName,
                                                    userRank,
                                                    userSubRank,
                                                    spendTime)
            }

        } else {
            
            return
        }
    }
}

extension RidingResultViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        return 70
//    }
}

extension RidingResultViewController: MKMapViewDelegate {
    
    // Map 路線屬性
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = .hexStringToUIColor()
        
        renderer.lineWidth = 5.0
        
        return renderer
        
    }
}
