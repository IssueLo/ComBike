//
//  RidingViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/3.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class RidingViewController: UIViewController {
    
    @IBOutlet weak var infoView: UIView! {
        didSet {
            
            infoView.layer.cornerRadius = 10
            
            infoView.alpha = 0.8
        }
    }
    
    @IBAction func backGroupDetailVC() {
        
        navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
        
        navigationController?.navigationBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
//        setupView()
    }
    
    func setupInfoView() {
        
        
        
    }

}
