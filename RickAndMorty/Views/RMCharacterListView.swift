//
//  RMCharacterListView.swift
//  RickAndMorty
//
//  Created by Dmitrii Bragin on 23.03.2024.
//

import SnapKit
import UIKit

protocol RMCharacterListViewDelegate: AnyObject {
    func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCharacter character: RMCharacter)
}

/// View that handles showing list of characters, loader, etc.
class RMCharacterListView: UIView {
    weak var delegate: RMCharacterListViewDelegate?

    private let viewModel = RMCharacterListViewViewModel()

    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()

        spinner.hidesWhenStopped = true
        spinner.style = .large

        return spinner
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16

        collectionView.isHidden = true
        collectionView.alpha = 0

        collectionView.register(
            RMCharacterCollectionViewCell.self,
            forCellWithReuseIdentifier: RMCharacterCollectionViewCell.identifier
        )
        collectionView.register(
            RMFooterLoadingCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier
        )

        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
        configureData()

        spinner.startAnimating()
        viewModel.fetchCharacters()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension RMCharacterListView {
    func configureUI() {
        addSubviews(collectionView, spinner)

        spinner.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(100)
        }

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configureData() {
        viewModel.delegate = self
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.didLoadInitialCharacters()
        }
    }
}

extension RMCharacterListView: RMCharacterListViewViewModelDelegate {
    func didLoadInitialCharacters() {
        spinner.stopAnimating()

        collectionView.reloadData()
        collectionView.isHidden = false

        UIView.animate(withDuration: 0.3) {
            self.collectionView.alpha = 1
        }
    }

    func didLoadAdditionalCharacters(with newIndexPaths: [IndexPath]) {
        collectionView.performBatchUpdates {
            self.collectionView.insertItems(at: newIndexPaths)
        }
    }

    func didSelectCharacter(_ character: RMCharacter) {
        delegate?.rmCharacterListView(self, didSelectCharacter: character)
    }
}
