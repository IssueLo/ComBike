//
//  HomePageViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/5.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class RouteListController: UIViewController {
    
    var jsonArray: NSMutableArray?
    
    var routeDataArray = [[RouteData]]() {
        
        didSet {
            
            DispatchQueue.main.async {
                
                self.routeListTableView.reloadData()
            }
            
            UIView.animate(withDuration: 1) {
                
                self.launchScreen.alpha = 0
            }
        }
    }
    
    let headerTitle = ["北部路線", "中部路線", "南部路線", "東部路線"]

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
        
        self.tabBarController?.tabBar.tintColor = .hexStringToUIColor()
        
        getRouteData()
        // cell註冊要改喔
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
    
    func getRouteData() {
        
        let allRouteList = [RouteIDData.northern,
                            RouteIDData.central,
                            RouteIDData.southern,
                            RouteIDData.eastern]
        
        RouteInfoManager.getRouteInfo(routeIDList: allRouteList) { (allRouteData) in
            
            self.routeDataArray = allRouteData
        }
    }
}

extension RouteListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return routeDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteListCell", for: indexPath)
        
        guard
            let routeListCell = cell as? RouteListCell
            
        else { return cell }
        
        routeListCell.routeListData = self.routeDataArray[indexPath.section]
        
        routeListCell.handler = { (indexPath) in
            
            let storyboard = StoryboardCategory.routeDetail.getStoryboard()
            
            guard
                let routeDetailVC = storyboard.instantiateViewController(
                    withIdentifier: RouteDetailViewController.identifier
                    )as? RouteDetailViewController
                
                else { return }
            
            routeDetailVC.routeData = routeListCell.routeListData[indexPath.row]
            
            routeDetailVC.hidesBottomBarWhenPushed = true
            
            self.show(routeDetailVC, sender: nil)
        }
        
        return routeListCell
    }
}

extension RouteListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: "RouteHeaderView"
            ) as? RouteHeaderView
        
        headerView?.routeAreaLabel.text = headerTitle[section]
        
        headerView?.handler = {
            
            let storyboard = StoryboardCategory.areaRoute.getStoryboard()
            
            guard
                let areaRouteVC = storyboard.instantiateViewController(
                    withIdentifier: AreaRouteViewController.identifier
                    ) as? AreaRouteViewController
                
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
