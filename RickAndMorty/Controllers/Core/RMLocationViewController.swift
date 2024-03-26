//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Dmitrii Bragin on 20.03.2024.
//

import UIKit

/// Controller to show and search for Locations
final class RMLocationViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
}

private extension RMLocationViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        title = "Locations"
    }
}
