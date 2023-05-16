//
//  UtilityExtensions.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/15.
//

import Kingfisher
import UIKit

extension UIView {
    func getYGGradientLayer() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        let color1 = UIColor(hex: "ECCD5F").cgColor
        let color2 = UIColor(hex: "C5FF7B").cgColor
        gradient.colors = [color1, color2]
        // 漸層比例
        gradient.locations = [0.1139, 1.3853]
        gradient.frame = bounds
        return gradient
    }
}

extension UIImageView {
    func loadImage(with url: URL?, placeholder: UIImage? = nil) {
        kf.setImage(with: url, placeholder: placeholder)
    }
}

// MARK: 擴張按鈕點擊範圍

extension UIButton {
    private enum AssociatedKeys {
        static var touchEdgeInsets = "touchEdgeInsets"
    }

    var touchEdgeInsets: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.touchEdgeInsets) as? UIEdgeInsets
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.touchEdgeInsets, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let touchEdgeInsets = touchEdgeInsets else {
            return super.point(inside: point, with: event)
        }

        let expandedBounds = bounds.inset(by: touchEdgeInsets)
        return expandedBounds.contains(point)
    }
}
