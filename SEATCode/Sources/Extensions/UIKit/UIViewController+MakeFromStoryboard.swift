//
//  UIViewController+MakeFromStoryboard.swift
//  SEATCode
//
//  Created by Luis Valdés on 07/10/2020.
//

import UIKit

extension UIViewController {
    static func makeFromStoryboard<T: UIViewController>(creator: @escaping (NSCoder) -> T?) -> T {
        let viewControllerName = String(describing: T.self)
        let storyboard = UIStoryboard(name: viewControllerName, bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController(creator: creator) else {
            fatalError("Failed to initialize \(viewControllerName)")
        }
        return viewController
    }
}
