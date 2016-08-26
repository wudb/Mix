//
//  MixTextViewController.swift
//  Mix
//
//  Created by nc-wudb on 16/8/18.
//  Copyright © 2016年 wudb. All rights reserved.
//

import UIKit

class MixTextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let textView = UITextView(frame: self.view.bounds)
        textView.scrollEnabled = true
        textView.showsVerticalScrollIndicator = true
        self.view.addSubview(textView)
        
        let attributedText = NSMutableAttributedString(string: "Jacob was a year and a half older than I and seemed to enjoy reading my gestures and translating my needs to adults. He ensured that cartoons were viewed, cereal was served, and that all bubbles were stirred out of any remotely bubbly beverage intended for me. In our one-bedroom apartment in southern New Jersey, we didn’t have many toys. But I had a big brother and Jacob had a baby sister. We were ignorant of all the pressed plastic playthings we didn’t have.")
        
        // 图片附件
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "catanddog")
        // 调整图片位置到中间
        imageAttachment.bounds = CGRectMake(0, -imageAttachment.image!.size.height / 2, imageAttachment.image!.size.width, imageAttachment.image!.size.height)
        attributedText.insertAttributedString(NSAttributedString(attachment: imageAttachment), atIndex: 50)
        
        // 高亮
        attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(0, 5))
        
        // 下划线
        attributedText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, 10))
        
        // 字体
        attributedText.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(50), range: NSMakeRange(20, 10))
        
        // 背景色
        attributedText.addAttribute(NSBackgroundColorAttributeName, value: UIColor.yellowColor(), range: NSMakeRange(30, 10))
        
        // 删除线
        attributedText.addAttribute(NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(120, 20))
        
        // 斜体
        attributedText.addAttribute(NSObliquenessAttributeName, value: 1, range: NSMakeRange(100, 10))
        
        
        // 阴影
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 3.0, height: 3.0)
        shadow.shadowColor = UIColor.redColor()
        attributedText.addAttribute(NSShadowAttributeName, value: shadow, range: NSMakeRange(140, 15))
        
        // 横竖文本
        attributedText.addAttribute(NSVerticalGlyphFormAttributeName, value: 0, range: NSMakeRange(70, 10))
        
        textView.attributedText = attributedText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
