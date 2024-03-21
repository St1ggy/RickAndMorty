//
//  RMTabBarController.swift
//  RickAndMorty
//
//  Created by Dmitrii Bragin on 20.03.2024.
//

import UIKit

/// Controller to house tabs and root tab controllers
final class RMTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabs()
    }
}

typealias ViewControllerConfig = (
    viewController: UIViewController.Type,
    title: String,
    imageName: String
)

private let viewControllersConfigs: [ViewControllerConfig] = [
    (viewController: RMCharacterViewController.self, title: "Characters", imageName: "person"),
    (viewController: RMLocationViewController.self, title: "Locations", imageName: "globe"),
    (viewController: RMEpisodeViewController.self, title: "Episodes", imageName: "tv"),
    (viewController: RMSettingsViewController.self, title: "Settings", imageName: "gear")
]

private extension RMTabBarController {
    func makeNavigationController(tag: Int, viewControllerConfig: ViewControllerConfig) -> UINavigationController {
        let (viewController, title, imageName) = viewControllerConfig
        let nc = UINavigationController(rootViewController: viewController.init())
        nc.navigationBar.prefersLargeTitles = true
        nc.navigationItem.largeTitleDisplayMode = .automatic

        nc.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: imageName),
            tag: tag
        )

        return nc
    }

    func setupTabs() {
        tabBar.tintColor = .systemGreen

        let viewControllers = viewControllersConfigs.enumerated().map(makeNavigationController)
        setViewControllers(viewControllers, animated: true)
    }
}
