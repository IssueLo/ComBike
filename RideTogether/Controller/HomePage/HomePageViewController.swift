//
//  HomePageViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/5.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    
    var jsonArray: NSMutableArray?
    
    var routeDataArray = [[RouteData]]() {
        
        didSet {
            
            DispatchQueue.main.async {
                
                self.routeListTableView.reloadData()
            }
        }
    }
    
    var headerTitle = ["北部路線", "中部路線", "南部路線", "東部路線"]

    var allRouteList = [[String]]()

    @IBOutlet weak var launchScreen: UIView!
    
    @IBOutlet weak var routeListTableView: UITableView! {
        
        didSet {
            
            routeListTableView.dataSource = self
            
            routeListTableView.delegate = self
            
            routeListTableView.sectionFooterHeight = 0
            
            routeListTableView.contentInset.bottom = -20
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let storyboard = UIStoryboard(name: "UserIndicaterStoryboard", bundle: nil)
//
//        let indicaterVC = storyboard.instantiateViewController(withIdentifier: "UserIndicaterController")
//
//        indicaterVC.modalPresentationStyle = .fullScreen
                
//        present(indicaterVC, animated: false, completion: nil)
        
        self.tabBarController?.tabBar.tintColor = .hexStringToUIColor()
        
        allRouteList = [RouteIDData.northern,
                        RouteIDData.central,
                        RouteIDData.southern,
                        RouteIDData.eastern]
        
        let group = DispatchGroup()
        
        for area in allRouteList {
            
            var currentRouteData = [RouteData]()
        
            for routeID in area {
                
//                print("**enter: \(routeID)")
                group.enter()
                
                StravaProvider.getRouteData(routeID) { (result) in
                    
                    switch result {
                        
                    case .success(var routeData):
                        
                        let array = routeData.name.components(separatedBy: "：")
                        
                        if array.count == 1 {
                            
                            routeData.name = array[0]
                        } else {
                            
                            routeData.name = array[1]
                        }
                        
                        currentRouteData.append(routeData)
                        
                        group.leave()
                        
                    case .failure(let error):
                        
                        print(error)
                    }
                }
            }
            
            group.notify(queue: .main, execute: {
                
                self.routeDataArray.append(currentRouteData)
                
                UIView.animate(withDuration: 1) {
                    
                    self.launchScreen.alpha = 0
                }
            })
        }
        
        let nib = UINib(nibName: "RouteListCell", bundle: nil)
        
        routeListTableView.register(nib, forCellReuseIdentifier: "RouteListCell")
        
        let headerNib = UINib(nibName: "RouteHeaderView", bundle: nil)

        routeListTableView.register(headerNib,
                                    forHeaderFooterViewReuseIdentifier: "RouteHeaderView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
}

extension HomePageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return routeDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteListCell", for: indexPath)
        
        guard let routeListCell = cell as? RouteListCell else { return cell }
        
        routeListCell.routeListData = self.routeDataArray[indexPath.section]
        
        routeListCell.handler = { (indexPath) in
            
            let storyboard = UIStoryboard(name: "RouteDetailStoryboard", bundle: nil)
            
            guard
                let routeDetailVC = storyboard.instantiateViewController(withIdentifier: "RouteDetailStoryboard")
                    as? RouteDetailViewController
                else { return }
            
            routeDetailVC.routeData = routeListCell.routeListData[indexPath.row]
            
            routeDetailVC.hidesBottomBarWhenPushed = true
            
            self.show(routeDetailVC, sender: nil)
                        
        }
        
        return routeListCell
    }
    
}

extension HomePageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "RouteHeaderView")
            as? RouteHeaderView
        
        headerView?.routeAreaLabel.text = headerTitle[section]
        
        headerView?.handler = {
            
            let storyboard = UIStoryboard(name: "AreaRouteStoryboard", bundle: nil)
            
            guard let areaRouteVC = storyboard.instantiateViewController(withIdentifier: "AreaRouteViewController")
                as? AreaRouteViewController
            else { return }
            
            areaRouteVC.view.layoutIfNeeded()
            
            areaRouteVC.navigationItem.title = self.headerTitle[section]
            
            areaRouteVC.areaRouteData = self.routeDataArray[section]
                        
            self.show(areaRouteVC, sender: nil)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 48
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 140
    }
}
