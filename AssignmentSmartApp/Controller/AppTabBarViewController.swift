//
//  AppTabBarViewController.swift
//  AssignmentSmartApp
//
//  Created by Ankit Chaudhary on 14/05/20.
//  Copyright © 2020 spectorAi. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

struct TabItemDetails {
    var title: String
    var selectedImage: UIImage
    var unselectedImage: UIImage
    var badgeColor: UIColor
    var titlePositionAdjustment:UIOffset
    var imageInsets: UIEdgeInsets
    var tag: Int
}

enum AppTabBarState: CaseIterable {
    case nowPlaying, topRated
    func fetchTabItemDetails() -> TabItemDetails {
        switch self {
        case .nowPlaying:
            return TabItemDetails.init(title: StringConstant.nowPlaying.uppercased(), selectedImage: ImageConstant.nowPlayingSelected.fetchImage(), unselectedImage: ImageConstant.nowPlayingUnselected.fetchImage(), badgeColor: UIColor.white, titlePositionAdjustment: UIOffset.init(horizontal: 0, vertical: 8), imageInsets: UIEdgeInsets.init(top: 5, left: 0, bottom: 0, right: 0), tag: 1)
        case .topRated:
            return TabItemDetails.init(title: StringConstant.topRated.uppercased(), selectedImage: ImageConstant.topRatedSelected.fetchImage(), unselectedImage: ImageConstant.topRatedUnselected.fetchImage(), badgeColor: UIColor.white, titlePositionAdjustment: UIOffset.init(horizontal: 0, vertical: 8), imageInsets: UIEdgeInsets.init(top: 5, left: 0, bottom: 0, right: 0), tag: 2)
        }
    }
}

class AppTabBarViewController: UITabBarController, BindableType {
    
    lazy var nowPlayingScene: Scene = {
        let movieListViewModel = MovieListViewModel.init()
        movieListViewModel.movieListType = .nowPlayingList
        let movieListScene = Scene.movieList(movieListViewModel)
        return movieListScene
    }()
    
    lazy var topRatedScene: Scene = {
        let movieListViewModel = MovieListViewModel.init()
        movieListViewModel.movieListType = .topRatedList
        let movieListScene = Scene.movieList(movieListViewModel)
        return movieListScene
    }()
    
    
    var viewModel: AppTabBarViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.configureTabBar()
        var navigationControllers: [UINavigationController] = []
        for state in AppTabBarState.allCases {
            let navigationController = createNavigationController(for: state, controller: self.fetchViewController(for: state))
            navigationControllers.append(navigationController)
        }
        self.viewControllers = navigationControllers
        self.selectedIndex = AppTabBarState.allCases.count - 1
    }
    
    func bindViewModel() {
        // If we are scaffolding app for the first and need user session data or any other pre auth info can be fetched here.
    }
    
    func configureTabBar() {
        // Changes tabbar appearence from here only.
        tabBar.tintColor = UIColor.clear
        tabBar.barTintColor = UIColor.backgroundColor
        tabBar.isTranslucent = false
        
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 4
        
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.1
    }
    
    func createNavigationController(for state: AppTabBarState, controller: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController.init(rootViewController: controller)
        bindNavDetails(navController: navigationController, details: state.fetchTabItemDetails())
        return navigationController
    }
    
    func bindNavDetails(navController: UINavigationController, details: TabItemDetails) {
        navController.tabBarItem.title = details.title
        navController.tabBarItem.tag = details.tag
        navController.tabBarItem.selectedImage = details.selectedImage.withRenderingMode(.alwaysOriginal)
        navController.tabBarItem.image = details.unselectedImage
        navController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font : Font.book(size: 10, font: FontName.SharpSans).fetch(), NSAttributedString.Key.foregroundColor : UIColor.textColor], for: UIControl.State.normal)
        navController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font : Font.book(size: 10, font: FontName.SharpSans).fetch(), NSAttributedString.Key.foregroundColor : UIColor.textColor], for: UIControl.State.selected)
        navController.tabBarItem.badgeColor = details.badgeColor
        navController.tabBarItem.titlePositionAdjustment = details.titlePositionAdjustment
        navController.tabBarItem.imageInsets = details.imageInsets
    }
}

// Setup a state relation between state and their corresponding view controller.
extension AppTabBarViewController {
    func fetchViewController(for state: AppTabBarState) -> UIViewController {
        switch state {
        case .nowPlaying:
            return nowPlayingScene.viewController()
        case .topRated:
            return topRatedScene.viewController()
        }
    }
}
