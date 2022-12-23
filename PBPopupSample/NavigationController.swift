//
//  NavigationController.swift
//  PBPopupSample
//
//  Created by Oleksandr Balabon on 22.12.2022.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topViewController?.title = self.title
    }
    
    deinit {
        print("Deinit: \(self)")
    }
}

