/**
 * @brief   webview
 * @author  wudb
 * @date    16/8/17
 */

import UIKit

class MixWebViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView = UIWebView(frame: self.view.bounds)
        self.view.addSubview(webView)
        
        
        let url = NSURL(string: "https://www.huxiu.com/article/160451/1.html")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
}
