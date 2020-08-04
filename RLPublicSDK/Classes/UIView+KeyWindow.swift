//
//  UIView+KeyWindow.swift
//  RLPopupView
//
//  Created by iOS on 2020/3/5.
//  Copyright © 2020 beiduofen. All rights reserved.
//

import UIKit

public var currentWindow: UIWindow? {
    if #available(iOS 13.0, *) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first
    } else {
        return UIApplication.shared.keyWindow
    }
}
