//
//  CoreText1View.swift
//  Mix
//
//  Created by nc-wudb on 16/8/29.
//  Copyright © 2016年 wudb. All rights reserved.
//

import UIKit

// 点击链接的回调
typealias TouchLinkEvent = (link: String) -> Void

class TULabel: UIView {
    private var ctframe: CTFrame?
    
    // 检测到的链接
    private var detectLinkList: [NSTextCheckingResult]?
    
    // 文本链接对应的范围
    private var hyperlinkRangeMapper: [String: String] = [:]
    
    var attributedText: NSAttributedString?
    
    // 是否自动检测链接, default is false
    var autoDetectLinks = false
    
    // 指定文本链接映射关系
    var hyperlinkMapper: [String: String]?
    
    // 链接显示颜色
    var linkColor = UIColor.blueColor()
    
    // 点击链接的回调
    var touchLinkCallback: TouchLinkEvent?
    
    // 图片附件数组
    var imageAttachments: [TUImageAttachment]?
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
        if self.autoDetectLinks {
            detectLinks()
            self.attributedText = addLinkStyle(self.attributedText, links: self.detectLinkList)
        }
        
        if nil != self.hyperlinkMapper {
            self.attributedText = addHyperlinkStyle(self.attributedText, links: self.hyperlinkMapper)
        }
        
        if let attributedString = checkImage(self.attributedText) {
            self.attributedText = attributedString
        }
        
        guard let text = self.attributedText else {
            return
        }
        
        // 1.获取当前上下文
        let context = UIGraphicsGetCurrentContext()!
        
        // 2.转换坐标系
        CGContextSetTextMatrix(context, CGAffineTransformIdentity)
        CGContextTranslateCTM(context, 0, self.bounds.size.height)
        CGContextScaleCTM(context, 1.0, -1.0)
        
        // 3.初始化路径
        let path = CGPathCreateWithRect(self.bounds, nil)
        
        // 4.初始化字符串
//        let attrString = NSMutableAttributedString(string: str)
//        attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, attrString.length))
        
        // 5.初始化framesetter
        let framesetter = CTFramesetterCreateWithAttributedString(text)
        
        // 6.绘制frame
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, text.length), path, nil)
        self.ctframe = frame
    
        // 获得CTLine数组
        let lines = CTFrameGetLines(frame)
        
        // 获得行数
        let numberOfLines = CFArrayGetCount(lines)
        
        // 获得每一行的origin, CoreText的origin是在字形的baseLine处的
        var lineOrigins = [CGPoint](count: numberOfLines, repeatedValue: CGPointZero)
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &lineOrigins)
        
//        var lineAscent = CGFloat(), lineDescent = CGFloat(), lineLeading = CGFloat()
        
        // 遍历每一行进行绘制
        for index in 0..<numberOfLines {
            let origin = lineOrigins[index]
            
            // 参考: http://swifter.tips/unsafe/
            let line = unsafeBitCast(CFArrayGetValueAtIndex(lines, index), CTLine.self)
            
//            CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading)
            
            CGContextSetTextPosition(context, origin.x, origin.y)
            
//            CTLineDraw(line, context)
            
            drawLine(line, context: context)
        }
        
//        CTFrameDraw(frame, context!)
    }
    
    // 画一行
    func drawLine(line: CTLine, context: CGContext) {
        let runs = CTLineGetGlyphRuns(line) as Array
    
        runs.forEach { run in
            
            let attributes = CTRunGetAttributes(run as! CTRun) as NSDictionary
            
            drawRun(run as! CTRun, attributes: attributes, context: context)
        }
        
    }
    
    // 画样式
    func drawRun(run: CTRun, attributes: NSDictionary, context: CGContext) {
        if nil != attributes[NSStrikethroughStyleAttributeName] { // 删除线
            CTRunDraw(run, context, CFRangeMake(0, 0))
            drawStrikethroughStyle(run, attributes: attributes, context: context)
        } else if nil != attributes[NSBackgroundColorAttributeName] { // 背景色
            fillBackgroundColor(run, attributes: attributes, context: context)
            CTRunDraw(run, context, CFRangeMake(0, 0))
        } else if nil != attributes[TUImageAttachmentAttributeName] { // 绘制图片
            drawImage(run, attributes: attributes, context: context)
        } else {
            CTRunDraw(run, context, CFRangeMake(0, 0))
        }
    }
    
    // 获取Run原点
    func getRunOrigin(run: CTRun) -> CGPoint {
        var origin = CGPointZero
        let firstGlyphPosition = CTRunGetPositionsPtr(run)
        if nil == firstGlyphPosition {
            let positions = UnsafeMutablePointer<CGPoint>.alloc(1)
            
            positions.initialize(CGPointZero)
            CTRunGetPositions(run, CFRangeMake(0, 0), positions)
            origin = positions.memory
            
            positions.dealloc(1)
        } else {
            origin = firstGlyphPosition.memory
        }
        
        return origin
    }
    
    // 获得run的字体
    func getRunFont(attributes: NSDictionary) -> UIFont {
        return (attributes[NSFontAttributeName] ?? UIFont.systemFontOfSize(UIFont.systemFontSize())) as! UIFont
    }
    
    // 画删除线
    func drawStrikethroughStyle(run: CTRun, attributes: NSDictionary, context: CGContext) {
        // 获取删除线样式
        let styleRef = attributes[NSStrikethroughStyleAttributeName]//unsafeBitCast(CFDictionaryGetValue(attributes, NSStrikethroughStyleAttributeName), CFNumber.self)
        var style: NSUnderlineStyle = .StyleNone
        CFNumberGetValue(styleRef as! CFNumber, CFNumberType.SInt64Type, &style)
        
        guard style != .StyleNone else {
            return
        }
        
        // 画线的宽度
        var lineWidth: CGFloat = 1
        if (style.rawValue & NSUnderlineStyle.StyleThick.rawValue) == NSUnderlineStyle.StyleThick.rawValue {
            lineWidth *= 2
        }
        
        CGContextSetLineWidth(context, lineWidth)
        
        
        // 获取画线的起点
        let firstPosition = getRunOrigin(run)
        
        // 开始画
        CGContextBeginPath(context)
        
        // 线的颜色
        let lineColor = attributes[NSStrikethroughColorAttributeName]
        if nil == lineColor {
            CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        } else {
            CGContextSetStrokeColorWithColor(context, (lineColor as! UIColor).CGColor)
        }
        
        // 字体高度
        let font = getRunFont(attributes)
        var strikeHeight: CGFloat = font.xHeight / 2.0 + firstPosition.y
        
        // 多行调整
        let pt = CGContextGetTextPosition(context)
        strikeHeight += pt.y
        
        // 画线的宽度
//        var ascent = CGFloat(), descent = CGFloat(), leading = CGFloat()
        let typographicWidth = CGFloat(CTRunGetTypographicBounds(run, CFRangeMake(0, 0), nil, nil, nil))
        
        CGContextMoveToPoint(context, pt.x + firstPosition.x, strikeHeight)
        CGContextAddLineToPoint(context, pt.x + firstPosition.x + typographicWidth, strikeHeight)
        
        CGContextStrokePath(context)
    }
    
    // 填充背景色
    func fillBackgroundColor(run: CTRun, attributes: NSDictionary, context: CGContext) {
        // 获取设置的背景色
        let backgroundColor = attributes[NSBackgroundColorAttributeName]
        guard let color = backgroundColor else {
            return
        }
        
        // 获取画线的起点
        let origin = getRunOrigin(run)
        
        // 获取Run的宽度, ascent, descent
        var ascent = CGFloat(), descent = CGFloat(), leading = CGFloat()
        let typographicWidth = CGFloat(CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, &leading))
        
        let pt = CGContextGetTextPosition(context)
        
        // 需要填充颜色的区域
        let rect = CGRectMake(origin.x + pt.x, pt.y + origin.y - descent, typographicWidth, ascent + descent)
        
        // 开始填充颜色
        let components = CGColorGetComponents(color.CGColor)
        CGContextSetRGBFillColor(context, components[0], components[1], components[2], components[3])
        CGContextFillRect(context, rect)
    }
    
    // 检测是否有图片
    func checkImage(attributedText: NSAttributedString?) -> NSAttributedString? {
        guard let attrText = attributedText else {
            return attributedText
        }
        
        guard let attachments = self.imageAttachments else {
            return attrText
        }
        
        let text = NSMutableAttributedString(attributedString: attrText)
        
        attachments.forEach { attach in
            text.insertAttributedString(imageAttribute(attach), atIndex: attach.location)
        }
        
        return text
    }
    
    // 插入图片样式
    func imageAttribute(attachment: TUImageAttachment) -> NSAttributedString {
        // 定义RunDelegateCallback并实现
        var imageCallback = CTRunDelegateCallbacks(version: kCTRunDelegateVersion1, dealloc: { pointer in
                pointer.dealloc(1)
            }, getAscent: { pointer -> CGFloat in
                return UnsafePointer<UIImage>(pointer).memory.size.height / 2
            }, getDescent: { pointer -> CGFloat in
                return UnsafePointer<UIImage>(pointer).memory.size.height / 2
            }, getWidth: { pointer -> CGFloat in
                return UnsafePointer<UIImage>(pointer).memory.size.width
        })
        
        // 创建RunDelegate, 传入callback中图片数据
        let pointer = UnsafeMutablePointer<UIImage>.alloc(1)
        pointer.initialize(attachment.image!)
        let runDelegate = CTRunDelegateCreate(&imageCallback, pointer)
        
        //0xFFFC
        // 为每个图片创建一个空的string占位
        let imageAttributedString = NSMutableAttributedString(string: " ")
        imageAttributedString.addAttribute(kCTRunDelegateAttributeName as String, value: runDelegate!, range: NSMakeRange(0, 1))
        
        // 将附件作为指定属性的值
        imageAttributedString.addAttribute(TUImageAttachmentAttributeName, value: attachment, range: NSMakeRange(0, 1))
        
        return imageAttributedString
    }
    
    // 画图片
    func drawImage(run: CTRun, attributes: NSDictionary, context: CGContext) {
        // 获取对应图片属性的附件
        let imageAttachment = attributes[TUImageAttachmentAttributeName]
        guard let attachment = imageAttachment else {
            return
        }
        
        // 计算绘制图片的区域
        let origin = getRunOrigin(run)
        
        var ascent = CGFloat(), descent = CGFloat(), leading = CGFloat()
        let typographicWidth = CGFloat(CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, &leading))
        
        let pt = CGContextGetTextPosition(context)
        
        var rect = CGRect(x: origin.x + pt.x, y: pt.y + origin.y - descent, width: typographicWidth, height: ascent + descent)
        
        let image = (attachment as! TUImageAttachment).image
        rect.size = image!.size
        
        // 绘制图片
        CGContextDrawImage(context, rect, image!.CGImage!)
    }
    
    // 检测链接
    func detectLinks() {
        guard let text = self.attributedText else {
            return
        }
        
        // 定义识别器类型
        let linkDetector = try! NSDataDetector(types: NSTextCheckingType.Link.rawValue)
        
        // 将匹配的类型存储到一个数组中
        let content = text.string
        self.detectLinkList = linkDetector.matchesInString(content, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, content.characters.count))
    }
    
    // 给链接增加样式
    func addLinkStyle(attributedText: NSAttributedString?, links: [NSTextCheckingResult]?) -> NSAttributedString? {
        guard let linkList = links else {
            return attributedText
        }
        
        guard let text = attributedText else {
            return attributedText
        }
        
        // 遍历链接列表, 增加指定样式
        let attrText = NSMutableAttributedString(attributedString: text)
        linkList.forEach { [unowned self] result in
            attrText.addAttributes([NSForegroundColorAttributeName: self.linkColor,
                NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
                NSUnderlineColorAttributeName: self.linkColor], range: result.range)
        }
        return attrText
    }
    
    // 获取行的区域
    func getLineRect(line: CTLine, origin: CGPoint) -> CGRect {
        var ascent = CGFloat(), descent = CGFloat(), leading = CGFloat()
        let width = CGFloat(CTLineGetTypographicBounds(line, &ascent, &descent, &leading));
        let height = ascent + descent;
        
        return CGRectMake(origin.x, origin.y - descent, width, height);
    }
    
    // 获取点击位置对应的富文本的位置index
    func attributedIndexAtPoint(point: CGPoint) -> CFIndex {
        guard let frame = self.ctframe else {
            return -1
        }
        
        let lines = CTFrameGetLines(frame)
        
        // 获得行数
        let numberOfLines = CFArrayGetCount(lines)
        
        // 获得每一行的origin, CoreText的origin是在字形的baseLine处的
        var lineOrigins = [CGPoint](count: numberOfLines, repeatedValue: CGPointZero)
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &lineOrigins)
        
        //坐标变换
        let transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1, -1);
        
        for index in 0..<numberOfLines {
            let origin = lineOrigins[index]
            
            // 参考: http://swifter.tips/unsafe/
            let line = unsafeBitCast(CFArrayGetValueAtIndex(lines, index), CTLine.self)
            
            let flippedRect = getLineRect(line, origin: origin)
            let rect = CGRectApplyAffineTransform(flippedRect, transform)
            
            if CGRectContainsPoint(rect, point) { // 找到了是哪一行
                let relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect))
                return CTLineGetStringIndexForPosition(line, relativePoint)
            }
        }
        
        return -1
    }
    
    // 判断点击的位置是不是链接
    func linkAtIndex(index: CFIndex) -> (foundLink: NSTextCheckingResult?, link: String?) {
        if self.autoDetectLinks {
            guard let links = self.detectLinkList else {
                return (nil, nil)
            }
            
            var foundLink: NSTextCheckingResult?
            var link: String?
            links.forEach({ result in
                if NSLocationInRange(index, result.range) {
                    foundLink = result
                    link = self.attributedText!.attributedSubstringFromRange(result.range).string
                    return
                }
            })
            return (foundLink, link)
        }
        
        return (nil, nil)
    }
    
    // 给指定链接的文本添加样式
    func addHyperlinkStyle(attributedText: NSAttributedString?, links: [String: String]?) -> NSAttributedString? {
        guard let linkList = links else {
            return attributedText
        }
        
        guard let text = attributedText else {
            return attributedText
        }
        
        let attrText = NSMutableAttributedString(attributedString: text)
        self.hyperlinkRangeMapper.removeAll()
        
        linkList.forEach { [unowned self] result in
            let attrString = attrText.string as NSString
            let range = attrString.rangeOfString(result.0)
            if range.location != NSNotFound {
                attrText.addAttributes([NSForegroundColorAttributeName: self.linkColor,
                    NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
                    NSUnderlineColorAttributeName: self.linkColor], range: range)
                
                self.hyperlinkRangeMapper[result.0] = NSStringFromRange(range)
            }
        }
        
        return attrText
    }
    
    // 判断点击的位置是不是链接
    func hyperlinkAtIndex(index: CFIndex) -> String? {
        guard let linkMapper = self.hyperlinkMapper else {
            return nil
        }
        
        var link: String?
        self.hyperlinkRangeMapper.forEach { result in
            let range = NSRangeFromString(result.1)
            if NSLocationInRange(index, range) {
                link = linkMapper[result.0]
                return
            }
        }
        return link
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.autoDetectLinks || nil != self.hyperlinkMapper {
            let touch: UITouch = touches.first!
            let point = touch.locationInView(self)
            
            // 获取点击位置对应富文本的位置
            let index = attributedIndexAtPoint(point)
            
            // 点击了文本链接
            if nil != self.hyperlinkMapper {
                let link = hyperlinkAtIndex(index)
                if nil != link && nil != self.touchLinkCallback {
                    self.touchLinkCallback!(link: link!)
                }
            }
            
            
            // 点击了自动识别的链接
            if self.autoDetectLinks {
                // 根据index找链接
                let foundLink = linkAtIndex(index)
                
                if nil != foundLink.foundLink  {
                    guard let link = foundLink.link else {
                        return
                    }
                    
                    if let touchLink = self.touchLinkCallback {
                        touchLink(link: link)
                    }
                }
            }
            
        }
    }
    
    
    
    
    
    
}
