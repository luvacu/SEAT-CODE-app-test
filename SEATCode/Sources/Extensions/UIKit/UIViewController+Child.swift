//
//  UIViewController+Child.swift
//  SEATCode
//
//  Created by Luis Valdés on 07/10/2020.
//

import UIKit

extension UIViewController {
    func add(child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove(child: UIViewController) {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}
