//
//  TabBarController.swift
//  Jogging
//
//  Created by Alexey Boyko on 15/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if !UserData.isUserManager {
            var viewContollers = self.viewControllers
            viewControllers?.removeLast()
            self.viewControllers = viewControllers
        }
    }

}
