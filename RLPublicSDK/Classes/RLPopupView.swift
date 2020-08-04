//
//  RLPopupView.swift
//  RLPopupView
//
//  Created by iOS on 2020/3/5.
//  Copyright © 2020 beiduofen. All rights reserved.
//

import UIKit
import SnapKit

public enum RLPopupType {
    case sheet
    case alert
    case custom
}

public typealias RLPopupBlock = (RLPopupView) -> Void
public typealias RLPopupCompletionBlock = (RLPopupView, Bool) -> Void

open class RLPopupView: UIView {
    // 透明层颜色
    open var presentViewColor: UIColor = UIColor.yellow
    // 背景点击是否关闭
    open var touchWildToHide: Bool = true
    // 动画时间
    open var animationDuration: Double = 0.3
    // 是否显示导航栏
    open var showNavBar: Bool = false
    // 弹窗类型
    open var type: RLPopupType = .sheet {
        didSet {
            switch type {
            case .alert:
                self.showAnimation = alertShowAnimation()
                self.hideAnimation = alertHideAnimation()
                break
            case .sheet:
                self.showAnimation = sheetShowAnimation()
                self.hideAnimation = sheetHideAnimation()
            case .custom:
                self.showAnimation = customShowAnimation()
                self.hideAnimation = customHideAnimation()
                break
            }
        }
    }
    
    open var showAnimation: RLPopupBlock?
    open var hideAnimation: RLPopupBlock?
    
    open var showCompletionBlock: RLPopupCompletionBlock?
    open var hideCompletionBlock: RLPopupCompletionBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public
extension RLPopupView {
    @objc open func show() {
        showWithBlock(nil)
    }
    
    @objc open func hide() {
        hideWithBlock(nil)
    }
    
    open func showWithBlock(_ block: RLPopupCompletionBlock?) {
        self.showCompletionBlock = block
        
        if let show = showAnimation {
            show(self)
        }
    }
    
    open func hideWithBlock(_ block: RLPopupCompletionBlock?) {
        self.hideCompletionBlock = block
        if let hide = hideAnimation {
            hide(self)
        }
    }
}

extension RLPopupView {
    private func sheetShowAnimation() -> RLPopupBlock {
        if superview == nil {
            let presentertView = RLPresenterView()
            presentertView.popupView = self
            presentertView.touchWildToHide = touchWildToHide
            snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().offset(UIScreen.main.bounds.height)
            }
            self.superview?.layoutIfNeeded()
        }
        let block: RLPopupBlock = {
            [weak self] (_) in
            guard let self = self else { return }
            self.snp.updateConstraints{
                $0.bottom.equalToSuperview().offset(0)
            }
            UIView.animate(withDuration: self.animationDuration,
                           delay: 0.0,
                           options: [.curveEaseOut, .beginFromCurrentState],
                           animations: {
                            self.superview?.layoutIfNeeded()
                            
            }, completion: { (finished) in
                if let complete = self.showCompletionBlock {
                    complete(self, finished)
                }
            })
        }
        return block
    }
    
    private func sheetHideAnimation() -> RLPopupBlock {
        let block: RLPopupBlock = {
            [weak self] (_) in
            guard let self = self else { return }
            self.snp.updateConstraints{
                $0.bottom.equalToSuperview().offset(UIScreen.main.bounds.height)
            }
            UIView.animate(withDuration: self.animationDuration,
                                   delay: 0.0,
                                   options: [.curveEaseOut, .beginFromCurrentState],
                                   animations: {
                                    self.superview?.layoutIfNeeded()
                                    
                    }, completion: { (finished) in
                        if finished {
                            self.superview?.removeFromSuperview()
                            self.removeFromSuperview()
                        }
                        if let complete = self.showCompletionBlock {
                            complete(self, finished)
                        }
                    })
        }
        return block
    }
    
    private func alertShowAnimation() -> RLPopupBlock {
        if superview == nil {
            let presentertView = RLPresenterView()
            presentertView.popupView = self
            snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview().offset(-10)
            }
            self.superview?.layoutIfNeeded()
        }
        let block: RLPopupBlock = {
            [weak self] (_) in
            guard let self = self else { return }
            UIView.animate(withDuration: self.animationDuration,
                           delay: 0.0,
                           options: [.curveEaseOut, .beginFromCurrentState],
                           animations: {
                            self.superview?.layoutIfNeeded()
                            
            }, completion: { (finished) in
                            if let complete = self.showCompletionBlock {
                                complete(self, finished)
                            }
            })
        }
        return block
    }
    
    private func alertHideAnimation() -> RLPopupBlock {
        let block: RLPopupBlock = {
            [weak self] (_) in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.3, delay: 0.2, options: [], animations: {
                self.superview?.alpha = 0
            }) { (finished) in
                
            }
            let animation = CAKeyframeAnimation(keyPath: "transform.scale")
            animation.keyTimes = [0, 0.3, 1.0]
            animation.values = [0, 1.2, 0.1]
            animation.duration = 0.5
            animation.delegate = self
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
            self.layer.add(animation, forKey: nil)
        }
        return block
    }
    
    private func customShowAnimation() -> RLPopupBlock {
        if superview == nil {
            let presentertView = RLPresenterView()
            presentertView.popupView = self
            snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview().offset(UIScreen.main.bounds.height)
            }
            self.superview?.layoutIfNeeded()
        }
        let block: RLPopupBlock = {
            [weak self] (_) in
            guard let self = self else { return }
            self.snp.updateConstraints {
                $0.centerY.equalToSuperview().offset(-10)
            }
            UIView.animate(withDuration: self.animationDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 18, options: [], animations: {
                self.superview?.layoutIfNeeded()
            }) { (finished) in
               if let complete = self.showCompletionBlock {
                   complete(self, finished)
               }
            }
        }
        return block
    }
    
    private func customHideAnimation() -> RLPopupBlock {
        let block: RLPopupBlock = {
            [weak self] (_) in
            guard let self = self else { return }
            UIView.animate(withDuration: self.animationDuration,
                           delay: 0.0,
                           options: [.curveEaseOut, .beginFromCurrentState],
                           animations: {
                            self.snp.updateConstraints{
                                $0.centerY.equalToSuperview().offset(-UIScreen.main.bounds.height/2)
                            }
                            self.superview?.layoutIfNeeded()
                            
            }, completion: { (finished) in
                if finished {
                    self.superview?.removeFromSuperview()
                    self.removeFromSuperview()
                }
                if let complete = self.hideCompletionBlock {
                    complete(self, finished)
                }
            })
        }
        return block
    }
}


extension RLPopupView: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.superview?.removeFromSuperview()
            self.removeFromSuperview()
            if let complete = self.showCompletionBlock {
                complete(self, flag)
            }
        }
    }
}
