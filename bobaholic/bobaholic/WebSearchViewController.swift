//
//  WebSearchViewController.swift
//  bobaholic
//

import UIKit
import WebKit

// Resource:
// https://fredriccliver.medium.com/add-custom-configuration-into-wkwebview-with-storyboard-d5cbd0271e6d
class WebSearchViewController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = URL(string: "https://www.google.com/search?q=boba+near+me")!
        self.webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: url))
    }

}
