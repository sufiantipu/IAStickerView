//
//  IAStickerBorderView.swift
//  IAStickerView
//
//  Created by Inventive Apps on 9/6/17.
//  Copyright © 2017 Inventive Apps. All rights reserved.
//



import UIKit

let ASPUserResizableViewGlobalInset = 5.0
let ASPUserResizableViewDefaultMinWidth = 48.0
let ASPUserResizableViewDefaultMinHeight = 48.0
let ASPUserResizableViewInteractiveBorderSize = 10.0

class IAStickerBorderView: UIView {
    
    
    let borderColor = "29abe2"

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context!.saveGState()
        context!.setLineWidth(1.0)
        context!.setStrokeColor(UIColor.colorFromRGB(colorHexString: borderColor).cgColor)
        context!.addRect(self.bounds.insetBy(dx: CGFloat(ASPUserResizableViewInteractiveBorderSize / 2), dy: CGFloat(ASPUserResizableViewInteractiveBorderSize / 2)))
        context!.strokePath()
        context!.restoreGState()
    }
}
