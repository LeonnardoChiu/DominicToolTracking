//
//  TabBarController.swift
//  DominicToolTracking
//
//  Created by Leonnardo Hutama on 30/09/21.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
//        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        styleDefaultNavBar()
        configureTabBar()
    }
    
    private func configureTabBar() {
        
        let item1 = UINavigationController.init(rootViewController: DashboardViewController())
        let item2 = UINavigationController.init(rootViewController: FriendListViewController())
        
        let icon1 = UITabBarItem(title: "Dashboard",
                                 image: UIImage(),
                                 selectedImage: UIImage())

        let icon2 = UITabBarItem(title: "Friends",
                                 image: UIImage(),
                                 selectedImage: UIImage())

        item1.tabBarItem = icon1
        item2.tabBarItem = icon2
        
        let controllers = [item1, item2]
        self.setViewControllers(controllers, animated: false)
        
    }
    
    
    //Delegate methods
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        return true;
//    }

}
