//
//  IAStickerView.swift
//  IAStickerView
//
//  Created by Md Abu Sufian on 27/11/17.
//  Copyright © 2017 Md Abu Sufian. All rights reserved.
//


import UIKit

let IAStickerViewControlSize = 25.0

class IAStickerView: UIView {
    
    var scale = CGFloat(1)
    var initialSize: CGSize!
    var sizeIncrease: CGFloat!
    private var _contentView: UIView?
    var contentView: UIView? {
        get {
            return _contentView
        }
        set(view) {
            _contentView?.removeFromSuperview()
            _contentView = view
            _contentView!.frame = self.bounds.insetBy(dx: CGFloat(ASPUserResizableViewGlobalInset + ASPUserResizableViewInteractiveBorderSize / 2), dy: CGFloat(ASPUserResizableViewGlobalInset + ASPUserResizableViewInteractiveBorderSize / 2))
            _contentView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(_contentView!)
            self.sendSubview(toBack: _contentView!)
        }
    }
    var borderView: IAStickerBorderView!
    
    var preventsPositionOutsideSuperview: Bool = true
    var preventsResizing = false
    var preventsDeleting = false
    var translucencySticker = true
    var isSelected = false
    var deltaAngle: CGFloat!
    var touchStartPoint: CGPoint!
    
    let rotateButton = UIImageView()
    let deleteButton = UIImageView()
    var delegate: IAStickerViewDelegate?
    let prevent: CGFloat = 40

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        initialSize = frame.size
        self.setProperties()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    private func setProperties() {
        setPinchGesture()
        setBorderView()
        setRotateButton()
        setDeleteButton()
        
        deltaAngle = atan2(self.frame.origin.y + self.frame.size.height - self.center.y, self.frame.origin.x + self.frame.size.width - self.center.x)
    }
    
    func setBorderView() {
        borderView = IAStickerBorderView(frame: self.bounds.insetBy(dx: CGFloat(ASPUserResizableViewGlobalInset), dy: CGFloat(ASPUserResizableViewGlobalInset)))
        borderView.isHidden = true
        self.addSubview(borderView)
    }
    
    func setBorderViewFrame() {
        borderView.frame = self.bounds.insetBy(dx: CGFloat(ASPUserResizableViewGlobalInset), dy: CGFloat(ASPUserResizableViewGlobalInset))
        borderView.setNeedsDisplay()
    }
    
    func setRotateButton() {
        setRotateButtonFrame()
        rotateButton.image = UIImage(named: "rotate_icon")
        rotateButton.isUserInteractionEnabled = true
        let pangesture = UIPanGestureRecognizer(target: self, action: #selector(rotatePanGestureAction(gesture:)))
        rotateButton.addGestureRecognizer(pangesture)
        self.addSubview(rotateButton)
    }
    
    func setRotateButtonFrame() {
        rotateButton.frame = CGRect(x: self.bounds.size.width - CGFloat(IAStickerViewControlSize), y: self.bounds.size.height - CGFloat(IAStickerViewControlSize), width: CGFloat(IAStickerViewControlSize), height: CGFloat(IAStickerViewControlSize))
    }
    
    func setDeleteButton() {
        setDeleteButtonFrame()
        deleteButton.image = UIImage(named: "cross_icon")
        deleteButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteTapGestureAction(gesture:)))
        deleteButton.addGestureRecognizer(tapGesture)
        self.addSubview(deleteButton)
    }
    
    func setDeleteButtonFrame() {
        deleteButton.frame = CGRect(x: 0, y: 0, width: IAStickerViewControlSize, height: IAStickerViewControlSize)
    }
    
    func setPinchGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureAction(gesture:)))
        self.addGestureRecognizer(pinchGesture)
    }
    
    //MARK:- Gesture Recognizer Action Methods
    
    @objc func pinchGestureAction(gesture: UIPinchGestureRecognizer) {
        if !isSelected {
            return
        }
        resetSizeIncrease()
        scale *= gesture.scale
        gesture.scale = 1.0
        applyNew(size: CGSize(width: initialSize.width * scale, height: initialSize.height * scale))
        
        delegate?.stickerViewDidPinched?(self)
        
    }
    
    @objc func rotatePanGestureAction(gesture: UIPanGestureRecognizer) {
        let state = gesture.state
        switch state {
        case .began:
            reduseOpacity(ok: true)
        case .changed:
            let angle = atan2(gesture.location(in: self.superview).y - self.center.y, gesture.location(in: self.superview).x - self.center.x)
            let angleDiffrence = deltaAngle - angle
            if !preventsResizing {
                self.transform = CGAffineTransform(rotationAngle: -angleDiffrence)
               
                delegate?.stickerViewDidRotate?(self)
                
            }
            setBorderViewFrame()
        case .ended:
            reduseOpacity(ok: false)
        default:
            print("Error")
        }
    }
    
    @objc func deleteTapGestureAction(gesture: UITapGestureRecognizer) {
        self.removeFromSuperview()
        delegate?.stickerViewDidClose?(self)
        
    }
    
    //MARK:- Helper Methods
    
    func resetSizeIncrease() {
        scale = self.bounds.size.height / self.initialSize.height
        sizeIncrease = 0
    }
    
    
    func preventUp() {
        let maxY = self.frame.maxY
        if maxY < prevent {
            let add = prevent - maxY
            var center = self.center
            center.y += add
            self.center = center
        }
    }
    
    func preventDown() {
        let superViewHeigth = self.superview!.bounds.size.height
        if self.frame.origin.y + prevent > superViewHeigth {
            let minus = self.frame.origin.y + prevent - superViewHeigth
            var center = self.center
            center.y -= minus
            self.center = center
        }
    }
    
    func preventLeft() {
        let maxX = self.frame.maxX
        if maxX < prevent {
            let add = prevent - maxX
            var center = self.center
            center.x += add
            self.center = center
        }
    }
    
    func preventRight() {
        let superViewWidth = self.superview!.bounds.size.width
        if self.frame.origin.x + prevent > superViewWidth {
            let minus = self.frame.origin.x + prevent - superViewWidth
            var center = self.center
            center.x -= minus
            self.center = center
        }
    }
    
    func setSubViewFrames() {
        setBorderViewFrame()
        setDeleteButtonFrame()
        setRotateButtonFrame()
        
        borderView.setNeedsDisplay()
        setNeedsDisplay()
    }
    
    func applyNew(size: CGSize) {
        self.bounds = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: size.width, height: size.height)
        setSubViewFrames()
        if let delegate = self.delegate {
            delegate.stickerViewDidResized?(self)
        }
    }
    
    func reduseOpacity(ok: Bool) {
        guard ok || !translucencySticker else {
            self.alpha = 1.0
            return
        }
        self.alpha = 0.65
    }
    
    func showButtons() {
        borderView.isHidden = false
        rotateButton.isHidden = false
        deleteButton.isHidden = false
        isSelected = true
    }
    
    func hideButtons() {
        borderView.isHidden = true
        rotateButton.isHidden = true
        deleteButton.isHidden = true
        isSelected = false
    }
    
    func moveCenterOfObjectToNew(point: CGPoint) {
        if touchStartPoint == nil {
            return
        }
        var newCenter = CGPoint(x: self.center.x + point.x - touchStartPoint.x, y: self.center.y + point.y - touchStartPoint.y)
        if preventsPositionOutsideSuperview {
            let midX = self.bounds.midX
            if newCenter.x > self.superview!.bounds.size.width - midX {
                newCenter.x = (self.superview?.bounds.size.width)! - midX
            }
            if newCenter.x < midX {
                newCenter.x = midX
            }
            let midY = self.bounds.midY
            if newCenter.y > self.superview!.bounds.size.height - midY {
                newCenter.y = self.superview!.bounds.size.height - midY
            }
            if newCenter.y < midY {
                newCenter.y = midY
            }
        }
        self.center = newCenter
        preventUp()
        preventDown()
        preventLeft()
        preventRight()
    }
    
    //MARK:- Touch Event Methods 
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isSelected {
            isSelected = true
            showButtons()
            return
        }
        reduseOpacity(ok: true)
        touchStartPoint = touches.first!.location(in: self.superview)
        if let delegate = self.delegate {
            delegate.stickerViewDidBeginDragging?(self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        reduseOpacity(ok: false)
        if let delegate = self.delegate {
            delegate.stickerViewDidEndDragging?(self)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        reduseOpacity(ok: false)
        if let delegate = self.delegate {
            delegate.stickerViewDidEndDragging?(self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isSelected {
            return
        }
        reduseOpacity(ok: true)
        let touchLocation = touches.first!.location(in: self.superview)
        moveCenterOfObjectToNew(point: touchLocation)
        touchStartPoint = touchLocation
    }

}


@objc protocol IAStickerViewDelegate {
    @objc optional func stickerViewDidBeginDragging(_ sticker: IAStickerView)
    @objc optional func stickerViewDidEndDragging(_ sticker: IAStickerView)
    @objc optional func stickerViewDidCancelDragging(_ sticker: IAStickerView)
    @objc optional func stickerViewDidClose(_ sticker: IAStickerView)
    @objc optional func stickerViewDidRotate(_ sticker: IAStickerView)
    @objc optional func stickerViewDidResized(_ sticker: IAStickerView)
    @objc optional func stickerViewDidPinched(_ sticker: IAStickerView)
}
