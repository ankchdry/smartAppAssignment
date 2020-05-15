//
//  Scene.swift
//  AssignmentSmartApp
//
//  Created by Ankit Chaudhary on 14/05/20.
//  Copyright © 2020 spectorAi. All rights reserved.
//

import Foundation
import UIKit

enum Scene {
    // Login screen
    case appTabBar(AppTabBarViewModel)
    case movieList(MovieListViewModel)
    case movieDetails(MovieDetailsViewModel)
}

extension Scene {
    func viewController() -> UIViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        switch self {
            /*******************
             *
             * App Tab View Controllers
             *
             *******************/
            
        case .movieList(let model):
            var vc = storyboard.instantiateViewController(withIdentifier: MovieListViewController.identifier) as! MovieListViewController
            vc.bindViewModel(to: model)
            return vc
            
        case .movieDetails(let model):
            var vc = storyboard.instantiateViewController(withIdentifier: MovieDetailsViewController.identifier) as! MovieDetailsViewController
            vc.bindViewModel(to: model)
            return vc
            
        case .appTabBar(let model):
            var vc = AppTabBarViewController.init()
            vc.bindViewModel(to: model)
            return vc
        }
    }
}


