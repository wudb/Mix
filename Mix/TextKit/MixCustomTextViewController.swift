//
//  MixCustomTextViewController.swift
//  Mix
//
//  Created by nc-wudb on 16/8/23.
//  Copyright © 2016年 wudb. All rights reserved.
//

// 问题
// 1.拖动图片会出现空白的情况, 去掉NSFontAttributeName设置就不会有了, 待查原因

import UIKit

class MixCustomTextViewController: UIViewController, UITextViewDelegate {
    let navigationBarHeight: CGFloat = 64
    var textView: UITextView?
    var imageView: UIImageView?
    
    // 记录图片在被拖动后的位置Y
    var imageCenterY: CGFloat = 0
    
    var textStorage: NSTextStorage?
    
    var panOffset = CGPointZero
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let text = "Jacob was a year and a half older than I and seemed to enjoy reading my gestures and translating my needs to adults. He ensured that cartoons were viewed, cereal was served, and that all bubbles were stirred out of any remotely bubbly beverage intended for me. In our one-bedroom apartment in southern New Jersey, we didn’t have many toys. But I had a big brother and Jacob had a baby sister. We were ignorant of all the pressed plastic playthings we didn’t have. Jacob was a year and a half older than I and seemed to enjoy reading my gestures and translating my needs to adults. He ensured that cartoons were viewed, cereal was served, and that all bubbles were stirred out of any remotely bubbly beverage intended for me. In our one-bedroom apartment in southern New Jersey, we didn’t have many toys. But I had a big brother and Jacob had a baby sister. We were ignorant of all the pressed plastic playthings we didn’t have.Jacob was a year and a half older than I and seemed to enjoy reading my gestures and translating my needs to adults. He ensured that cartoons were viewed, cereal was served, and that all bubbles were stirred out of any remotely bubbly beverage intended for me. In our one-bedroom apartment in southern New Jersey, we didn’t have many toys. But I had a big brother and Jacob had a baby sister. We were ignorant of all the pressed plastic playthings we didn’t have.Jacob was a year and a half older than I and seemed to enjoy reading my gestures and translating my needs to adults. He ensured that cartoons were viewed, cereal was served, and that all bubbles were stirred out of any remotely bubbly beverage intended for me. In our one-bedroom apartment in southern New Jersey, we didn’t have many toys. But I had a big brother and Jacob had a baby sister. We were ignorant of all the pressed plastic playthings we didn’t have.Jacob was a year and a half older than I and seemed to enjoy reading my gestures and translating my needs to adults. He ensured that cartoons were viewed, cereal was served, and that all bubbles were stirred out of any remotely bubbly beverage intended for me. In our one-bedroom apartment in southern New Jersey, we didn’t have many toys. But I had a big brother and Jacob had a baby sister. We were ignorant of all the pressed plastic playthings we didn’t have.Jacob was a year and a half older than I and seemed to enjoy reading my gestures and translating my needs to adults. He ensured that cartoons were viewed, cereal was served, and that all bubbles were stirred out of any remotely bubbly beverage intended for me. In our one-bedroom apartment in southern New Jersey, we didn’t have many toys. But I had a big brother and Jacob had a baby sister. We were ignorant of all the pressed plastic playthings we didn’t have.Jacob was a year and a half older than I and seemed to enjoy reading my gestures and translating my needs to adults. He ensured that cartoons were viewed, cereal was served, and that all bubbles were stirred out of any remotely bubbly beverage intended for me. In our one-bedroom apartment in southern New Jersey, we didn’t have many toys. But I had a big brother and Jacob had a baby sister. We were ignorant of all the pressed plastic playthings we didn’t have.Jacob was a year and a half older than I and seemed to enjoy reading my gestures and translating my needs to adults. He ensured that cartoons were viewed, cereal was served, and that all bubbles were stirred out of any remotely bubbly beverage intended for me. In our one-bedroom apartment in southern New Jersey, we didn’t have many toys. But I had a big brother and Jacob had a baby sister. We were ignorant of all the pressed plastic playthings we didn’t have.Jacob was a year and a half older than I and seemed to enjoy reading my gestures and translating my needs to adults. He ensured that cartoons were viewed, cereal was served, and that all bubbles were stirred out of any remotely bubbly beverage intended for me. In our one-bedroom apartment in southern New Jersey, we didn’t have many toys. But I had a big brother and Jacob had a baby sister. We were ignorant of all the pressed plastic playthings we didn’t have."
        
        self.textStorage = NSTextStorage(string: text)
        
        // 段落样式
        let paragraphStyle = NSMutableParagraphStyle()
        
        //对齐模式
        //NSTextAlignmentCenter;//居中
        //NSTextAlignmentLeft //左对齐
        //NSTextAlignmentCenter //居中
        //NSTextAlignmentRight  //右对齐
        //NSTextAlignmentJustified//最后一行自然对齐
        //NSTextAlignmentNatural //默认对齐脚本
        paragraphStyle.alignment = .Natural
        
        //换行裁剪模式
        //NSLineBreakByWordWrapping = 0,//以空格为边界，保留单词
        //NSLineBreakByCharWrapping,    //保留整个字符
        //NSLineBreakByClipping,        //简单剪裁，到边界为止
        //NSLineBreakByTruncatingHead,  //按照"……文字"显示
        //NSLineBreakByTruncatingTail,  //按照"文字……文字"显示
        //NSLineBreakByTruncatingMiddle //按照"文字……"显示
        paragraphStyle.lineBreakMode = .ByCharWrapping
        
        // 行间距
        paragraphStyle.lineSpacing = 5.0
        
        // 字符间距
        paragraphStyle.paragraphSpacing = 2.0
        
        self.textStorage?.beginEditing()
        
        self.textStorage?.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: text.characters.count))
        
        // 高亮
        self.textStorage?.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(0, 5))
        
        // 下划线
        self.textStorage?.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, 10))
        
        // 字体
        self.textStorage?.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(50), range: NSMakeRange(220, 1))
        
        // 背景色
        self.textStorage?.addAttribute(NSBackgroundColorAttributeName, value: UIColor.yellowColor(), range: NSMakeRange(30, 10))
        
        // 删除线
        self.textStorage?.addAttribute(NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(120, 20))
        
        // 斜体
        self.textStorage?.addAttribute(NSObliquenessAttributeName, value: 1, range: NSMakeRange(100, 10))
        
        self.textStorage?.endEditing()
        
        
        // 阴影
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 3.0, height: 3.0)
        shadow.shadowColor = UIColor.redColor()
        self.textStorage?.addAttribute(NSShadowAttributeName, value: shadow, range: NSMakeRange(140, 15))
        
        let layoutManager = NSLayoutManager()
        self.textStorage?.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer(size: self.view.bounds.size)
        layoutManager.addTextContainer(textContainer)
        
        self.textView = UITextView(frame: self.view.bounds, textContainer: textContainer)
        self.textView?.delegate = self
        self.view.addSubview(self.textView!)
        
        
        // 图片
        self.imageView = UIImageView(image: UIImage(named: "catanddog"))
        self.imageView?.center = CGPointMake(self.view.bounds.size.width / 2, self.imageView!.frame.size.height / 2 + 200)
        self.view.addSubview(self.imageView!)
        self.imageCenterY = self.imageView!.center.y
        
        self.imageView?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(imagePan)))
        self.imageView?.userInteractionEnabled = true
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        updateExclusionPaths()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 更新路径
    func updateExclusionPaths() {
        // 计算图片所占范围
        var imageRect = self.textView?.convertRect(self.imageView!.frame, fromView: self.view)
        imageRect!.origin.x -= self.textView!.textContainerInset.left;
        imageRect!.origin.y -= self.textView!.textContainerInset.top;
        let path = UIBezierPath(rect: imageRect!)
        self.textView?.textContainer.exclusionPaths = [path]
    }
    
    func imagePan(pan: UIPanGestureRecognizer) {
        if pan.state == .Began {
            self.panOffset = pan.locationInView(self.imageView!)
        }
        
        let location = pan.locationInView(self.view)
        var imageCenter = self.imageView!.center
        
        imageCenter.x = location.x - self.panOffset.x + self.imageView!.frame.size.width / 2
        imageCenter.y = location.y - self.panOffset.y + self.imageView!.frame.size.height / 2
        
        self.imageView?.center = imageCenter
        self.imageCenterY = imageCenter.y + self.textView!.contentOffset.y + navigationBarHeight
        
        updateExclusionPaths()
    }
    
    // MARK: ScrollViewDelegate
    
    // 实现ScrollViewDelegate协议, 让textView滚动的时候, 图片也动起来
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.imageView?.center = CGPointMake(self.imageView!.center.x, self.imageCenterY - (scrollView.contentOffset.y + navigationBarHeight))
    }
    
    
}
