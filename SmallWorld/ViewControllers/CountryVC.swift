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
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    
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
        stackView.alpha = 0
        flagImage.alpha = 0
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
            self.navigationItem.title = name
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

//setting the image to fit the webview and vice versa
extension CountryVC: UIWebViewDelegate {
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        let scaleFactor = webView.bounds.size.width / webView.scrollView.contentSize.width
        if scaleFactor <= 0 {
            return
        }
        
        let contentHeight = webView.scrollView.contentSize.height
        let scaledContentHeight = contentHeight * scaleFactor
        let gap = webView.bounds.size.height - scaledContentHeight
        
        webView.scrollView.minimumZoomScale = scaleFactor
        webView.scrollView.maximumZoomScale = scaleFactor
        webView.scrollView.zoomScale = scaleFactor
        spinner.stopAnimating()
        
        UIView.animate(withDuration: 1, animations: { [weak self] in
            self?.flagImage.alpha = 1
            self?.stackView.alpha = 1
            self?.stackViewTopConstraint.constant -= gap
            self?.view.layoutIfNeeded()
        })
    }
}

