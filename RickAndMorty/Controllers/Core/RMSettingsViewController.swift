//
//  RMSettingsViewController.swift
//  RickAndMorty
//
//  Created by Dmitrii Bragin on 20.03.2024.
//

import UIKit

/// Controller to show various app options and settings
final class RMSettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
}

private extension RMSettingsViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        title = "Settings"
    }
}
