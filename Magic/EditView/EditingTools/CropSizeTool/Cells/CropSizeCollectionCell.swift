//
//  CropSizeCollectionCell.swift
//  Magic
//
//  Created by Devel on 16.12.2022.
//

import UIKit
import SnapKit

final class CropSizeCollectionCell: UICollectionViewCell {
    
    private lazy var rectangle: UIView = {
        var view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var ratioLabel: UILabel = {
        var lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 10)
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    func setup (size: CropSizes) {
        ratioLabel.text = size.description
        setupView()
        setupConstraints(aspectRatio: size.aspectRatio)
    }
    
    func togleSelected() {
        let selectedColor = UIColor(named: "BLUE") ?? UIColor.systemBlue
        let defaultColor  = UIColor.white
        if isSelected {
            rectangle.layer.borderColor = selectedColor.cgColor
            ratioLabel.textColor = selectedColor
        } else {
            rectangle.layer.borderColor = defaultColor.cgColor
            ratioLabel.textColor = defaultColor
        }
    }
    
    private func setupView() {
        contentView.addSubview(rectangle)
        contentView.addSubview(ratioLabel)
    }
    
    private func setupConstraints(aspectRatio: CGFloat) {
        let maxSize = 50.53
        let height  = aspectRatio <= 1 ? maxSize : maxSize / aspectRatio
        let width   = height * aspectRatio
        
        contentView.snp.makeConstraints { make in
            make.height.equalTo(72)
            make.width.equalTo(maxSize)
        }
        rectangle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
        ratioLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom)
            make.width.equalTo(width)
        }
    }
    
}
