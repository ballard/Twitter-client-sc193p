//
//  WebUIViewController.swift
//  Smashtag
//
//  Created by Иван Лазарев on 24.08.16.
//  Copyright © 2016 Ivan Lazarev. All rights reserved.
//

import UIKit

class WebUIViewController: UIViewController, UIWebViewDelegate {
    
    // MARK: - Outlets    
    @IBOutlet weak var webView: UIWebView!
    
    
    @IBOutlet weak var reloadPageOutlet: UIBarButtonItem!
    @IBAction func reloadPage(sender: AnyObject) {
        webView.reload()
    }
    
    @IBAction func forward(sender: AnyObject) {
        webView.goForward()
    }
    
    @IBAction func backward(sender: AnyObject) {
        webView.goBack()
    }
    
    @IBOutlet weak var stopOutlet: UIBarButtonItem!
    @IBAction func stop(sender: AnyObject) {
        webView.stopLoading()
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        reloadPageOutlet.enabled = false
        stopOutlet.enabled = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        reloadPageOutlet.enabled = true
        stopOutlet.enabled = false
    }
    
    // MARK: - Model
    var url : NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        if let webURL = url{
            webView.loadRequest(NSURLRequest(URL: webURL))
        }
        navigationController?.toolbarHidden = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.toolbarHidden = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
