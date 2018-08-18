//
//  ViewController.swift
//  SmallWorld
//
//  Created by Tomer Peled on 8/17/18.
//  Copyright © 2018 Tomer Peled. All rights reserved.
//

import UIKit

class CountryVC: UIViewController {

    @IBOutlet weak var flagImage: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var area: UILabel!
    @IBOutlet weak var population: UILabel!
    @IBOutlet weak var capital: UILabel!
    @IBOutlet weak var region: UILabel!
    @IBOutlet weak var callingCodes: UILabel!
    
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    var selectedCountry: Country? {
        didSet {
            if self.isViewLoaded {
                updateUI()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleWebView()
        spinner.hidesWhenStopped = true
        if selectedCountry != nil {
            updateUI()
        }
    }
    
    func handleWebView() {
        flagImage.scrollView.isScrollEnabled = false
        flagImage.contentMode = .scaleAspectFit
        flagImage.scalesPageToFit = false
        automaticallyAdjustsScrollViewInsets = false
        flagImage.backgroundColor = .clear
        flagImage.delegate = self
    }
    
    func updateUI() {
        if let name = selectedCountry?.name {
            self.navigationItem.title = "\(name)'s Borders Countries"
        }
        capital.text = selectedCountry?.capital ?? ""
        region.text = selectedCountry?.region ?? ""
        area.text = (selectedCountry?.area ?? -1.0).my_avoidNotation
        population.text = (selectedCountry?.population ?? -1.0).my_avoidNotation
        callingCodes.text = (selectedCountry?.callingCodes ?? [""]).joined(separator:" ")
        showimage()
    }
    
    func showimage() {
        if let urlString = selectedCountry?.flag {
            if let url = URL(string: urlString) {
                spinner.startAnimating()
                flagImage.loadRequest(URLRequest(url: url))
            }
        }
    }
    
    deinit {
        flagImage.stopLoading()
    }
}

//setting the image to fit the webview
extension CountryVC: UIWebViewDelegate {
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        let scaleFactor = webView.bounds.size.width / webView.scrollView.contentSize.width
        if scaleFactor <= 0 {
            return
        }
        
        webView.scrollView.minimumZoomScale = scaleFactor
        webView.scrollView.maximumZoomScale = scaleFactor
        webView.scrollView.zoomScale = scaleFactor
        spinner.stopAnimating()
        
        let contentHeight = webView.scrollView.contentSize.height
        let scaledContentHeight = contentHeight * scaleFactor
        let gap = webView.bounds.size.height - scaledContentHeight
        
        UIView.animate(withDuration: 1, animations: {
            self.containerTopConstraint.constant -= gap
            self.view.layoutIfNeeded()
        })
    }
}

