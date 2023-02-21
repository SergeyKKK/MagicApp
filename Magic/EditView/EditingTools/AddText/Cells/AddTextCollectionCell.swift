//
//  AddTextCollectionCell.swift
//  Magic
//
//  Created by Devel on 27.12.2022.
//

import UIKit
import SnapKit

final class AddTextCollectionCell: UICollectionViewCell {
    
    private lazy var label: UILabel = {
        var lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.backgroundColor = .black
        lbl.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lbl.layer.borderWidth = 1
        lbl.layer.cornerRadius = 5
        lbl.lineBreakMode = .byTruncatingMiddle
        return lbl
    }()
    
    func setup (fontName: String) {
        label.font = UIFont(name: fontName, size: 20)
        label.text = fontName
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        contentView.addSubview(label)
    }
    
    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
