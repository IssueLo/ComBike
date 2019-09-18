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
    
    var routeDataArray = [RouteData]() {
        
        didSet {
            
            print(routeDataArray)
        }
    }
    
    var north = ["10221097", "10221464", "19742365", "9797337", "10891667", "10320290"]
    
    var central = ["10009162", "10905234", "10077338", "10189536", "10905629", "16069201"]
    
    var southern = ["10118302", "12027904", "10118771", "9893309", "9796401", "10151516"]
    
    @IBOutlet weak var routeListTableView: UITableView! {
        
        didSet {
            
            routeListTableView.dataSource = self
            
            routeListTableView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for routeID in north {
            
            StravaProvider.getRouteData(routeID) { (result) in
                
                switch result {
                    
                case .success(let routeData):
                    
                    self.routeDataArray.append(routeData)
                    
                case .failure(let error):
                    
                    print(error)
                }
            }
        }
        
//        let tokenURL = StravaRequest.getToken.makeRequest()
//
//        HTTPClient.shared.tokenRequest(tokenURL)
        
        let nib = UINib(nibName: "RouteListCell", bundle: nil)
        
        routeListTableView.register(nib, forCellReuseIdentifier: "RouteListCell")
        
        let headerNib = UINib(nibName: "RouteHeaderView", bundle: nil)

        routeListTableView.register(headerNib,
                                    forHeaderFooterViewReuseIdentifier: "RouteHeaderView")
    }
}

extension HomePageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteListCell", for: indexPath)
        
        guard let routeListCell = cell as? RouteListCell else { return cell }
        
        routeListCell.routeListData = self.north
        
        return routeListCell
    }
    
}

extension HomePageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "RouteHeaderView") as? RouteHeaderView
        
        headerView?.routeAreaLabel.text = "推薦路線"
        print(headerView?.routeAreaLabel.font)
        headerView?.contentView.backgroundColor = .white
        
//        headerView?.backgroundColor = .blue
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 60
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        return "Hi"
//    }
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        <#code#>
//    }
}
