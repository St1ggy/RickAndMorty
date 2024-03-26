//
//  RMCharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Dmitrii Bragin on 23.03.2024.
//

import SnapKit
import UIKit

/// Single cell for a character
class RMCharacterCollectionViewCell: UICollectionViewCell {
    static let identifier = "RMCharacterCollectionViewCell"

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()

        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .medium)

        return label
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()

        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)

        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
        configureLayer()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
    }
}

private extension RMCharacterCollectionViewCell {
    func configureLayer() {
        contentView.layer.masksToBounds = true
        contentView.layer.shadowColor = UIColor.white.cgColor
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowOffset = CGSize(width: -4, height: 4)
        contentView.layer.shadowOpacity = 0.2
    }

    func configureUI() {
        contentView.backgroundColor = .secondarySystemBackground

        contentView.addSubviews(
            imageView,
            nameLabel,
            statusLabel
        )

        statusLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(4)
            $0.height.equalTo(30)
        }

        nameLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.equalTo(statusLabel.snp.top).offset(-4)
            $0.height.equalTo(30)
        }

        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.width.equalToSuperview()
            $0.bottom.equalTo(nameLabel.snp.top).offset(-4)
        }
    }
}

extension RMCharacterCollectionViewCell {
    func configure(with viewModel: RMCharacterCollectionViewCellViewModel) {
//        contentView.backgroundColor = viewModel.backgroundColor
        nameLabel.text = viewModel.characterName
        statusLabel.text = viewModel.characterStatusText

        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.imageView.image = image
                }

            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}
