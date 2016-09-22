/**
 * @brief   图片附件
 * @author  wudb
 * @date    16/9/21
 */

import UIKit

public let TUImageAttachmentAttributeName: String = "TUImageAttachmentAttributeName"


class TUImageAttachment {

    init(name: String, location: Int) {
        self.name = name
        self.location = location

        self.image = UIImage(named: name)
        if let img = self.image {
            self.bounds = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        }
    }

    var name: String
    var image: UIImage?
    var location: Int
    var bounds: CGRect?
}
