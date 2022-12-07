//
//  ThawaniPaymentVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 22/11/22.
//

import UIKit
import WebKit

class ThawaniPaymentVC: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    var payPalUrl: String!
    var payMentSuccessCompletion: ((String?,String?) -> ())?
    var thawaniPaymentURLLoad = false
//    var payMentFailureCompletion: ((String?) -> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if(thawaniPaymentURLLoad == false){
            self.navigationController?.isNavigationBarHidden = false
        }else{
            self.navigationController?.isNavigationBarHidden = true
        }
        webViewSetup()
        loadWebUrl(urlString: payPalUrl)
    }
    
    func webViewSetup() {
        webView.navigationDelegate = self
        webView.tag = 111
    }
    
    func loadWebUrl(urlString: String) {
        if let url = URL(string:urlString ) {
            webView.load(URLRequest(url: url))
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        thawaniPaymentURLLoad = false
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ThawaniPaymentVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = (webView.url?.absoluteString) {
            print(url)
            let newURL = URL(string: url)!
            
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if let url = (webView.url?.absoluteString) {
            print(url)
            if url.contains("api/thawanipay/return")
            {
                let urlArray = url.components(separatedBy: "/")
                print(urlArray)
                let urlValues = urlArray.suffix(2)
                let newArrayValues = Array(urlValues)
                print(newArrayValues)
                self.payMentSuccessCompletion?(newArrayValues[0],newArrayValues[1])
                self.dismiss(animated: true, completion: nil)
                
            } else if url.contains("api/thawanipay/cancel"){
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    
    
}

extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
        
    }
    
}
