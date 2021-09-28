//
//  WebVC.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 19.02.2021.
//

import UIKit
import WebKit

class WebVC: BaseVC {
    @IBOutlet weak var webView: WKWebView!
    
    var vcType: WebVCTypes = .kvkkAgreement
    var html: String?
    
    convenience init(vcType: WebVCTypes) {
        let bundle = Bundle(for: type(of: self))
        self.init(nibName: NibName.shared.WebVC, bundle: bundle)
        self.vcType = vcType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        initializeWebView()
        if vcType == .html {
            load(html: html)
        } else {
            self.showLoading()
            loadContent(urlString: vcType.getUrl())
        }
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if vcType == .html {
            configureNavBar(headerContainerStackViewVisibility: true,
                            backButtonVisibility: false,
                            titleImageViewVisibility: false,
                            closeButtonType: .cancel,
                            closeButtonVisibility: true)
        } else {
            configureNavBar(headerContainerStackViewVisibility: true,
                            backButtonVisibility: true,
                            titleImageViewVisibility: false,
                            closeButtonType: .cancel,
                            closeButtonVisibility: false)
        }
    }
    
    //MARK: - Helper Methods
    private func initializeWebView() {
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
    }
    
    private func loadContent(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        webView.load(URLRequest(url: url))
    }
    
    private func load(html: String?) {
        guard let validatedhtml = html else { return }
        webView.loadHTMLString(validatedhtml, baseURL: nil)
    }
}

//MARK: - Navigation Delegate
extension WebVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if vcType != .html {
            self.hideLoading()
        }
    }
    
   
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        let url = webView.url?.absoluteString
        print("---Hitted URL--->\(url!)") // here you are getting URL
        if url?.contains("callback3ds/success") ?? false {
            self.navigationController?.pushViewController(ResultVC(vcType: .success), animated: true)
        }else if url?.contains("callback3ds/failure") ?? false {
            self.navigationController?.pushViewController(ResultVC(vcType: .error), animated: true)
        }
    }
    
    
}
extension WebVC: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("javascript sending \(message.name), body: \(message.body)")
    }
}
