//
//  TabBarController.swift
//  CourseProject
//
//  Created by Allan on 22.01.23.
//

import UIKit
final class TabBarController: UITabBarController{
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let nc = selectedViewController as? UINavigationController {
            return nc.topViewController?.preferredStatusBarStyle ?? .default
        } else if let vc = selectedViewController {
            return vc.preferredStatusBarStyle
        }
        return .default
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchNVC = NavControllerSearchVC()
        searchNVC.navigationBar.isHidden = true
        let cameraVC = UINavigationController(rootViewController: CameraVC())
        let profileVC = ProfileGeneralVC()
        let profileNavVC = UINavigationController(rootViewController: profileVC)
        self.setViewControllers([searchNVC,cameraVC,profileNavVC], animated: false)
        guard let items = self.tabBar.items else { return }
       
        setTabBarAppearance()
        let images = ["magnifyingglass","camera.aperture","person.fill"]
        for elem in 0..<images.count {
            items[elem].image = UIImage(systemName: images[elem])
        }
    }
//    private let middleButtonDiameter: CGFloat = 42
//    private lazy var middleButton: UIButton = {
//        let middleButton = UIButton()
//        middleButton.layer.cornerRadius = middleButtonDiameter / 2
//        middleButton.backgroundColor = .systemRed
//        middleButton.translatesAutoresizingMaskIntoConstraints = false
//        return middleButton
//    }()
    private func setTabBarAppearance(){
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 221/255, green: 21/255, blue: 51/255, alpha: 1)
        setTabBarItemColors(appearance.stackedLayoutAppearance)
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = tabBar.standardAppearance
           }
    
    private func setTabBarItemColors(_ itemAppearance: UITabBarItemAppearance) {
        itemAppearance.normal.iconColor = .lightGray
        itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
         
        itemAppearance.selected.iconColor = .white
        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}
