//
//  NavControllerSearchVC.swift
//  CourseProject
//
//  Created by Allan on 10.02.23.
//

import Foundation
import UIKit

final class NavControllerSearchVC: UINavigationController{
    override func viewDidLoad() {
        super.viewDidLoad()
        let nextVC = SearchVC(nibName: "\(SearchVC.self)", bundle: nil)
        self.pushViewController(nextVC, animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
    if let vc = viewControllers.last
    { return vc.preferredStatusBarStyle }
    else
    { return .default }
    }
}
