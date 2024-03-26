//
//  RMCharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Dmitrii Bragin on 23.03.2024.
//

import Foundation
import RxSwift
import UIKit

protocol RMCharacterListViewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didLoadAdditionalCharacters(with newIndexPaths: [IndexPath])

    func didSelectCharacter(_ character: RMCharacter)
}

/// View Model to handle character list view logic
final class RMCharacterListViewViewModel: NSObject {
    weak var delegate: RMCharacterListViewViewModelDelegate?

    private var isLoadingMoreCharacters = false

    private var characters = [RMCharacter]() {
        didSet {
            for character in characters {
                let viewModel = RMCharacterCollectionViewCellViewModel(character)

                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }

    private var cellViewModels = [RMCharacterCollectionViewCellViewModel]()
    private var apiInfo: RMGetCharactersResponse.Info? = nil

    /// Fetch initial set of characters
    func fetchCharacters() {
        RMService.shared.execute(
            .listCharactersRequest,
            expecting: RMGetCharactersResponse.self
        ) { [weak self] result in
            guard let self = self else { return }

            switch result {
                case .success(let responseModel):
                    let results = responseModel.results
                    let info = responseModel.info

                    self.apiInfo = info
                    self.characters = results

                    DispatchQueue.main.async {
                        self.delegate?.didLoadInitialCharacters()
                    }

                case .failure(let error):
                    print(String(describing: error))
            }
        }
    }

    func fetchAdditionalCharacters(url: URL) {
        guard !isLoadingMoreCharacters else {
            return
        }

        isLoadingMoreCharacters = true

        guard let request = RMRequest(url: url) else {
            isLoadingMoreCharacters = false
            print("Failed to create request with url: \(url)")
            return
        }

        RMService.shared.execute(
            request,
            expecting: RMGetCharactersResponse.self
        ) { [weak self] result in
            guard let self = self else { return }

            switch result {
                case .success(let responseModel):
                    let results = responseModel.results
                    let info = responseModel.info

                    let originalCount = self.characters.count
                    let newCount = results.count
                    let total = originalCount + newCount
                    let startIndex = total - newCount
                    let indexPaths: [IndexPath] = Array(startIndex ..< startIndex + newCount).map {
                        IndexPath(row: $0, section: 0)
                    }

                    self.apiInfo = info
                    self.characters.append(contentsOf: results)

                    DispatchQueue.main.async {
                        self.delegate?.didLoadAdditionalCharacters(with: indexPaths)
                        self.isLoadingMoreCharacters = false
                    }

                case .failure(let error):
                    print(String(describing: error))
                    self.isLoadingMoreCharacters = false
            }
        }
    }

    var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
}

// MARK: - CollectionView

extension RMCharacterListViewViewModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let screenWidth = bounds.width
        let columnsCount: CGFloat = 2
        let spacing: CGFloat = 16
        let screenWidthWithoutSpacing = screenWidth - 2 * spacing
        let screenWidthWithoutSpacingAndColumns = screenWidthWithoutSpacing - (columnsCount - 1) * spacing
        let width = screenWidthWithoutSpacingAndColumns / columnsCount

        return CGSize(
            width: width,
            height: width * 1.5
        )
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        delegate?.didSelectCharacter(characters[indexPath.row])
    }
}

extension RMCharacterListViewViewModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }

        return CGSize(
            width: collectionView.frame.width,
            height: 100
        )
    }
}

extension RMCharacterListViewViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterCollectionViewCell.identifier,
            for: indexPath
        ) as? RMCharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }

        cell.configure(with: cellViewModels[indexPath.row])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard
            shouldShowLoadMoreIndicator,
            kind == UICollectionView.elementKindSectionFooter,
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
                for: indexPath
            ) as? RMFooterLoadingCollectionReusableView
        else {
            fatalError("Unsupported cell")
        }

        footer.startAnimating()

        return footer
    }
}

// MARK: - ScrollView

extension RMCharacterListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreCharacters,
              !cellViewModels.isEmpty,
              let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString)
        else {
            return
        }

        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] timer in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let scrollViewHeight = scrollView.frame.size.height

            if offset >= (totalContentHeight - scrollViewHeight * 1.5) {
                self?.fetchAdditionalCharacters(url: url)
            }

            timer.invalidate()
        }
    }
}
