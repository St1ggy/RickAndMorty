//
//  RMEpisodeViewController.swift
//  RickAndMorty
//
//  Created by Dmitrii Bragin on 20.03.2024.
//

import UIKit

/// Controller to show and search for Episodes
final class RMEpisodeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
}

private extension RMEpisodeViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        title = "Episodes"
    }
}
