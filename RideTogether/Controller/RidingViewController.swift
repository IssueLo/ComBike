//
//  RidingViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/3.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class RidingViewController: UIViewController {
    
    @IBOutlet weak var infoView: UIView! 
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var groupName: String!
    
    let screenWidth = UIScreen.main.bounds.width
    
    @IBAction func stopRiding() {
        
//        guard var labelText = stopButton.titleLabel?.text else { return }
        
        if stopButton.titleLabel?.text == "停止" {
            
            self.stopButton.setTitle("繼續", for: .normal)
            
            self.saveButton.setTitleColor(.black, for: .normal)
            
            self.stopButton.translatesAutoresizingMaskIntoConstraints = true
            
            self.saveButton.translatesAutoresizingMaskIntoConstraints = true
            
            UIView.animate(withDuration: 0.3) {
                
                self.stopButton.center.x = (self.screenWidth / 2) - (self.continueButton.bounds.width / 2 + 5)
                
                self.saveButton.center.x = (self.screenWidth / 2) + (self.saveButton.bounds.width / 2 + 5)
            }
            
        } else {

            UIView.animate(withDuration: 0.3) {
                
                self.stopButton.setTitle("停止", for: .normal)
                
                self.saveButton.setTitleColor(.lightGray, for: .normal)
                
                self.stopButton.center.x = (self.screenWidth / 2)

                self.saveButton.center.x = (self.screenWidth / 2)
            }
            // chain
        }
    }
    
    @IBAction func continueRiding() {
        
//        UIView.animate(withDuration: 1) {
//
//            self.continueButton.center.x = (self.screenWidth / 2)
//
//            self.saveButton.center.x = (self.screenWidth / 2)
//
//            self.stopButton.isHidden = false
//        }
    }
    
    @IBAction func saveRidingData() {
        
        let storyboard = UIStoryboard(name: "RidingResultStoryboard", bundle: nil)
        
        guard let ridingResultVC = storyboard.instantiateViewController(withIdentifier: "RidingResultViewControllor") as? RidingResultViewController else { return }
                
        ridingResultVC.groupName = self.groupName
        
        show(ridingResultVC, sender: nil)
    }
    
    @IBAction func backGroupDetailVC() {
        
//        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
//        navigationController?.navigationBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.navigationBar.isHidden = true
        
        setupView()
    }
    
    func setupView() {
        
        continueButton.isHidden = true
        
        infoView.layer.cornerRadius = 10
        
        infoView.alpha = 0.8
        
        stopButton.layer.cornerRadius = 10
        
        stopButton.backgroundColor = .lightGray
        
        continueButton.layer.cornerRadius = 10
        
        continueButton.backgroundColor = .lightGray
        
        saveButton.layer.cornerRadius = 10
        
        saveButton.backgroundColor = .lightGray
    }

}
