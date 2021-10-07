//
//  extensions.swift
//  DominicToolTracking
//
//  Created by Leonnardo Hutama on 01/10/21.
//

import Foundation
import UIKit

extension UITabBarController {
    
    func styleDefaultNavBar() {
        if #available(iOS 13, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = baseNavigationColor
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            appearance.shadowColor = .gray
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            
        }
        else {
            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            
            navigationController?.navigationBar.barTintColor = .systemBlue
            navigationController?.navigationBar.isTranslucent = false
        }
        
        navigationController?.navigationBar.topItem?.title = " "
    }
    
}

extension UIViewController {
    
    func styleDefaultTabBar() {
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
           
            tabBarController?.tabBar.standardAppearance = appearance
            tabBarController?.tabBar.scrollEdgeAppearance = appearance
        }
    }
}

extension UITextField {
    func setUpToolbar() {
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 30))
        toolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        doneButton.setTitle("Done", for: .normal)
        let doneButtonColor = UIColor.blue
        doneButton.setTitleColor(doneButtonColor, for: .normal)
        doneButton.addTarget(self, action: #selector(UIView.endEditing), for: .touchUpInside)
        
        let doneBarButton = UIBarButtonItem(customView: doneButton)

        toolbar.setItems([flexSpace, doneBarButton], animated: true)
        toolbar.sizeToFit()

        self.autocorrectionType = .no
        self.inputAccessoryView = toolbar
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension Encodable {
    var createDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
