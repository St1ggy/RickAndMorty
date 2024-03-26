//
//  UIView+Extension.swift
//  RickAndMorty
//
//  Created by Dmitrii Bragin on 23.03.2024.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview)
    }
}
