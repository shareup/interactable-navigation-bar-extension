//
//  Extensions.swift
//  ExtendingNavigationBar
//
//  Created by Sashko Potapov on 15.11.2022.
//

import Foundation
import UIKit

public extension String {
    func image() -> UIImage? {
        let size = CGSize(width: 36, height: 36)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject)
            .draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 32)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

public extension UIView {
    static var spacer: UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow - 1, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultLow - 1, for: .vertical)
        view.isAccessibilityElement = false
        view.isUserInteractionEnabled = false
        return view
    }
}

public extension UINavigationBar {
    static func setUpAppearance() {
        let appearance = opaqueAppearance

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().prefersLargeTitles = true
    }

    static var opaqueAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white

        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.backgroundColor = UIColor.white

        return appearance
    }()
}

public extension UINavigationBar {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews where !subview.isHidden && subview.alpha >= 0.01 {
            let convertedPoint = subview.convert(point, from: self)
            if subview.point(inside: convertedPoint, with: event) { return true }
        }
        return false
    }
}
