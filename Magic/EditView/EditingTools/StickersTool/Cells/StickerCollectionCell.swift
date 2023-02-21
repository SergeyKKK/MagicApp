//
//  StickerCollectionCell.swift
//  Magic
//
//  Created by Devel on 22.12.2022.
//

import UIKit
import SnapKit

final class StickerCollectionCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    func setup (image: UIImage) {
        imageView.image = image
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        contentView.addSubview(imageView)
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.width.height.equalTo(72)
        }
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-15)
            make.centerX.equalToSuperview().offset(-12)
            make.width.height.lessThanOrEqualToSuperview().offset(-20)
        }
    }
    
}

