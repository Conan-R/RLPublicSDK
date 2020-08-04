//
//  RLPresenterView.swift
//  RLPopupView
//
//  Created by iOS on 2020/3/5.
//  Copyright © 2020 beiduofen. All rights reserved.
//

import UIKit

class RLPresenterView: UIView, UIGestureRecognizerDelegate {
    
    var popupView: RLPopupView? {
        didSet {
            guard let popupView = popupView else { return }
            backgroundColor = popupView.presentViewColor
            let tap = UITapGestureRecognizer(target: popupView, action: #selector(popupView.hide))
            tap.delegate = self
            addGestureRecognizer(tap)
            if let currentWindow = currentWindow {
                currentWindow.addSubview(self)
                snp.makeConstraints{
                    $0.edges.equalToSuperview()
                }
            }
            addSubview(popupView)
            alpha = 0
            UIView.animate(withDuration: 0.25) {
                self.alpha = 1
            }
        }
    }
    
    var touchWildToHide: Bool = true {
        didSet {
            isUserInteractionEnabled = touchWildToHide
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor =  UIColor.black.withAlphaComponent(0.3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // disable tap gesture in superview
        let hitPoint = touch.location(in: self)
        if let popupFrame = popupView?.frame, popupFrame.contains(hitPoint) {
            return false
        }
        return true
    }
}
