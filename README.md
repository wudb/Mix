# 图文混排之控件使用
> 图文混排在iOS开发中经常遇到, 故总结了多种解决方案, 以便将来使用。本文先总结简单的方法-对控件的使用。这些控件包括UIWebView, UILabel, UITextView, UITextField, 都可以进行图文混排, 各有各的使用场景。

下图是控件基础架构, iOS7以前这几个控件都是基于WebKit开发, 而iOS7之后推出了TextKit, 重写了TextView, Label, TextField这几个控件。

![arch](https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/Art/text_kit_arch_2x.png)

### 一. UIWebView
WebView呈现图文混排比较简单, 只需要加载写好的html或者URL, 图文混排由网页实现。

### 二. UILabel
不管是UILabel还是UITextView的图文混排, 都是操作NSAttributedString, NSMutableAttributedString。

- 我们先创建一个label, 让label能自动换行, 居中显示

```swift
// 创建label
let label = UILabel(frame: self.view.bounds)
label.textAlignment = .Center   // 居中排列
label.lineBreakMode = .ByWordWrapping    // 按词换行
label.numberOfLines = 0	// 自动换行
self.view.addSubview(label)
```

- 创建NSMutableAttributedString

```swift
let attributedText = NSMutableAttributedString(string: "Jacob was a year and a half older than I and seemed to enjoy reading my gestures and translating my needs to adults. He ensured that cartoons were viewed, cereal was served, and that all bubbles were stirred out of any remotely bubbly beverage intended for me. In our one-bedroom apartment in southern New Jersey, we didn’t have many toys. But I had a big brother and Jacob had a baby sister. We were ignorant of all the pressed plastic playthings we didn’t have.")
```

- 文本有了之后, 就只剩下图片了。可是NSMutableString并不直接支持图片加入其中, 但是能插入附件, 我们把图片当附件插入文本中

```swift
// 图片附件
let imageAttachment = NSTextAttachment()
imageAttachment.image = UIImage(named: "catanddog") // 设置附件的image属性

// 调整图片位置到中间
imageAttachment.bounds = CGRectMake(0, -imageAttachment.image!.size.height / 2, imageAttachment.image!.size.width, imageAttachment.image!.size.height)

// 将带图片附件的string插入到指定位置
attributedText.insertAttributedString(NSAttributedString(attachment: imageAttachment), atIndex: 50)
```

图文混排的效果就出现了

![mix1](http://oc3j5gzq3.bkt.clouddn.com/2016-08-19-mix_label_1.jpeg)

至于怎么使用网络图片, 其实很简单, 只需要在图片下载完之后插入到指定位置就可以了。

- 觉得文本样式太简单了, 我们可以多点样式

```swift
// 高亮
attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(0, 3))

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
attributedText.addAttribute(NSShadowAttributeName, value: shadow, range: NSMakeRange(0, 15))
   
// 横竖文本
attributedText.addAttribute(NSVerticalGlyphFormAttributeName, value: 0, range: NSMakeRange(70, 10))
```
丰富多样的效果出现了
![mix_complete](http://oc3j5gzq3.bkt.clouddn.com/2016-08-22-mix_complete.png)

至此, Label的图文混合(包括富文本)处理已经完成, 至于排版视具体情况而定。

但是, Label的富文本处理出现了几个问题, 现一并记录在此

- 1.只剩下下面两个样式下划线和阴影, 两个样式的范围索引都从0开始

```swift
// 下划线
attributedText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, 10))

// 阴影
let shadow = NSShadow()
shadow.shadowOffset = CGSize(width: 3.0, height: 3.0)
shadow.shadowColor = UIColor.redColor()
attributedText.addAttribute(NSShadowAttributeName, value: shadow, range: NSMakeRange(0, 15))
```

出现了以下效果
![mix-label-proble1](http://oc3j5gzq3.bkt.clouddn.com/2016-08-22-mix-label-problem1.jpg)

- 2.还是只有下划线和阴影两个样式, 下划线的范围索引从0开始, 阴影的范围索引只要是非0就可以

```swift
// 下划线
attributedText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, 10))

// 阴影
let shadow = NSShadow()
shadow.shadowOffset = CGSize(width: 3.0, height: 3.0)
shadow.shadowColor = UIColor.redColor()
attributedText.addAttribute(NSShadowAttributeName, value: shadow, range: NSMakeRange(100, 15))
```
结果阴影效果未出现
![mix-label-proble2](http://oc3j5gzq3.bkt.clouddn.com/2016-08-22-mix-label-problem2.png)

这两个问题都是同一个原因导致, 只要将**下划线的范围索引改成非0**就都可以正常显示, [这里](http://stackoverflow.com/questions/23438677/nsattributedstring-not-working-does-not-appear-when-compiled-for-distribution)有相同问题的讨论, 可供参考。

详细内容请阅读[图文混排之控件使用](http://www.jianshu.com/p/7d38c4346f66)

欢迎关注我的公众号

![公众号](http://oc3j5gzq3.bkt.clouddn.com/2016-08-26-wechat_qrcode_300.jpg)


