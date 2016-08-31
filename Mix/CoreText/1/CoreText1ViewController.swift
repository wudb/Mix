//
//  CoreText1ViewController.swift
//  Mix
//
//  Created by nc-wudb on 16/8/29.
//  Copyright © 2016年 wudb. All rights reserved.
//

import UIKit

class CoreText1ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let view = TULabel(frame: CGRectMake(10, 80, self.view.bounds.size.width - 20, self.view.frame.size.height - 80))
        view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(view)
        
        
        let attributedText = NSMutableAttributedString(string: "Jacob was a year and a half older than I and seemed to enjoy reading my gestures and translating my needs to adults. He ensured that cartoons were viewed, cereal was served, and that all bubbles were stirred out of any remotely bubbly beverage intended for me. In our one-bedroom apartment in southern New Jersey, we didn’t have many toys. But I had a big brother and Jacob had a baby sister. We were ignorant of all the pressed plastic playthings we didn’t have.")
        
        // CoreText支持的属性

        // 字体颜色
        attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(0, 10))
        
        // 下划线
        let underlineStyles = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
                               NSUnderlineColorAttributeName: UIColor.orangeColor()]
        attributedText.addAttributes(underlineStyles, range: NSMakeRange(10, 10))
        
        // 字体
        attributedText.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(50), range: NSMakeRange(20, 10))
        
        // 描边(Stroke):组成字符的线或曲线。可以加粗或改变字符形状
        let strokeStyles = [NSStrokeWidthAttributeName: 10,
                            NSStrokeColorAttributeName: UIColor.blueColor()]
        attributedText.addAttributes(strokeStyles, range: NSMakeRange(40, 20))
        
        // 横竖文本
        attributedText.addAttribute(NSVerticalGlyphFormAttributeName, value: 0, range: NSMakeRange(70, 10))
        
        // 字符间隔
        attributedText.addAttribute(NSKernAttributeName, value: 5, range: NSMakeRange(90, 10))
        
        
        // 段落样式
        let paragraphStyle = NSMutableParagraphStyle()
        
        //对齐模式
        //NSTextAlignmentCenter;//居中
        //NSTextAlignmentLeft //左对齐
        //NSTextAlignmentCenter //居中
        //NSTextAlignmentRight  //右对齐
        //NSTextAlignmentJustified//最后一行自然对齐
        //NSTextAlignmentNatural //默认对齐脚本
        paragraphStyle.alignment = .Center
        
        //换行裁剪模式
        //NSLineBreakByWordWrapping = 0,//以空格为边界，保留单词
        //NSLineBreakByCharWrapping,    //保留整个字符
        //NSLineBreakByClipping,        //简单剪裁，到边界为止
        //NSLineBreakByTruncatingHead,  //按照"……文字"显示
        //NSLineBreakByTruncatingTail,  //按照"文字……文字"显示
        //NSLineBreakByTruncatingMiddle //按照"文字……"显示
        paragraphStyle.lineBreakMode = .ByWordWrapping
        
        // 行间距
        paragraphStyle.lineSpacing = 5.0
        
        // 字符间距
        paragraphStyle.paragraphSpacing = 2.0
        
        
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
        
        
        // CoreText不支持的属性
        
        // 删除线
        let strikethroughStyle = [NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
                                  NSStrikethroughColorAttributeName: UIColor.cyanColor()]
        attributedText.addAttributes(strikethroughStyle, range: NSMakeRange(150, 20))
        
        
        
        
        // 文字书写方向
//        attributedText.addAttribute(NSWritingDirectionAttributeName, value: [NSWritingDirection.RightToLeft.rawValue | NSTextWritingDirection.Embedding.rawValue], range: NSMakeRange(120, 10))
        
        
        // 横向拉伸文本
//        attributedText.addAttribute(NSExpansionAttributeName, value: 3.0, range: NSMakeRange(110, 10))
        
        // 背景色
//        attributedText.addAttribute(NSBackgroundColorAttributeName, value: UIColor.yellowColor(), range: NSMakeRange(30, 10))
        
        // 图片附件
//        let imageAttachment = NSTextAttachment()
//        imageAttachment.image = UIImage(named: "catanddog")
//        // 调整图片位置到中间
//        imageAttachment.bounds = CGRectMake(0, -imageAttachment.image!.size.height / 2, imageAttachment.image!.size.width, imageAttachment.image!.size.height)
//        attributedText.insertAttributedString(NSAttributedString(attachment: imageAttachment), atIndex: 50)
        
        // 斜体
//        attributedText.addAttribute(NSObliquenessAttributeName, value: 1, range: NSMakeRange(10, 10))
        
        // 凸版印刷体效果
//        attributedText.addAttribute(NSTextEffectAttributeName, value: NSTextEffectLetterpressStyle, range: NSMakeRange(40, 20))
        
        // 阴影
//        let shadow = NSShadow()
//        shadow.shadowOffset = CGSize(width: 3.0, height: 3.0)
//        shadow.shadowColor = UIColor.redColor()
//        attributedText.addAttribute(NSShadowAttributeName, value: shadow, range: NSMakeRange(140, 15))
        
        // 链接
//        attributedText.addAttribute(NSLinkAttributeName, value: "http://www.baidu.com/", range: NSMakeRange(0, 5))
        
        
        
        view.attributedText = attributedText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
