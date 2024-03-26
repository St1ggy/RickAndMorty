//
//  RMFooterLoadingCollectionReusableView.swift
//  RickAndMorty
//
//  Created by Dmitrii Bragin on 25.03.2024.
//

import SnapKit
import UIKit

final class RMFooterLoadingCollectionReusableView: UICollectionReusableView {
    static let identifier = "RMFooterLoadingCollectionReusableView"

    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()

        spinner.hidesWhenStopped = true
        spinner.style = .large

        return spinner
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension RMFooterLoadingCollectionReusableView {
    func configureUI() {
        addSubviews(spinner)

        spinner.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(100)
        }
    }
}

extension RMFooterLoadingCollectionReusableView {
    func startAnimating() {
        spinner.startAnimating()
    }

    func stopAnimating() {
        spinner.stopAnimating()
    }
}
