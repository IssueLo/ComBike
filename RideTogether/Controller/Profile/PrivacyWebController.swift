//
//  PrivacyWebController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/25.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit
import WebKit

class PrivacyWebController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var privacyWebView: WKWebView! {
        
        didSet {
            
            privacyWebView.navigationDelegate = self
        }
    }
    
    @IBOutlet weak var webViewIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlStr = "https://www.privacypolicies.com/privacy/view/cd188efbd3d6abc3b69d7588d800eb7e"
        
        if let url = URL(string: urlStr) {
            
            let request = URLRequest(url: url)
            
            privacyWebView.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        webViewIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        webViewIndicator.stopAnimating()
    }
}
