//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Dmitrii Bragin on 20.03.2024.
//

import SnapKit
import UIKit

/// Controller to show and search for Characters
final class RMCharacterViewController: UIViewController {
    private lazy var rmCharacterListView = RMCharacterListView()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureData()
    }
}

private extension RMCharacterViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        title = "Characters"

        view.addSubviews(rmCharacterListView)

        rmCharacterListView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    func configureData() {
        rmCharacterListView.delegate = self
    }
}

extension RMCharacterViewController: RMCharacterListViewDelegate {
    func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCharacter character: RMCharacter) {
        let viewModel = RMCharacterDetailViewViewModel(character: character)
        let detailViewController = RMCharacterDetailViewController(viewModel: viewModel)

        detailViewController.navigationItem.largeTitleDisplayMode = .never

        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
