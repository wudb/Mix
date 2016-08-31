//
//  CoreText1View.swift
//  Mix
//
//  Created by nc-wudb on 16/8/29.
//  Copyright © 2016年 wudb. All rights reserved.
//

import UIKit

class TULabel: UIView {
    var attributedText: NSAttributedString?
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
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
            CTRunDraw(run as! CTRun, context, CFRangeMake(0, 0))
            let attributes = CTRunGetAttributes(run as! CTRun) as NSDictionary
            
            if nil != attributes[NSStrikethroughStyleAttributeName] {
                drawStrikethroughStyle(run as! CTRun, attributes: attributes, context: context)
            }
        }
        
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
        var firstPosition = CGPointZero
        let firstGlyphPosition = CTRunGetPositionsPtr(run)
        if nil == firstGlyphPosition {
            let positions = UnsafeMutablePointer<CGPoint>.alloc(1)
            
            positions.initialize(CGPointZero)
            CTRunGetPositions(run, CFRangeMake(0, 0), positions)
            firstPosition = positions.memory
            
            positions.destroy()
        } else {
            firstPosition = firstGlyphPosition.memory
        }
        
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
        let font = attributes[NSFontAttributeName] ?? UIFont.systemFontOfSize(UIFont.systemFontSize())
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
}
