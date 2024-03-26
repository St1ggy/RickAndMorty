//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Dmitrii Bragin on 24.03.2024.
//

import UIKit

/// Controller to show information about single character
class RMCharacterDetailViewController: UIViewController {
    private let viewModel: RMCharacterDetailViewViewModel

    init(viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
}

private extension RMCharacterDetailViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        title = viewModel.title
    }
}
