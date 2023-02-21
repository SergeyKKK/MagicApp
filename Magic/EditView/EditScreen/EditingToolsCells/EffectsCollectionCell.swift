//
//  EffectsCollectionCell.swift
//  Magic
//
//  Created by Nodir on 17/11/22.
//

import UIKit

class EffectsCollectionCell: UICollectionViewCell {
    
    lazy var effectLabel: UILabel = {
        var lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Poppins-SemiBold", size: 14)
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = layer.frame.height / 2
        backgroundColor = .black
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func togleSelected() {
        if isSelected {
            backgroundColor = .white
            effectLabel.textColor = .black
        } else {
            backgroundColor = .black
            effectLabel.textColor = .white
        }
    }

    
    private func setupView() {
        contentView.addSubview(effectLabel)
        
        NSLayoutConstraint.activate([
            effectLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            effectLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            effectLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            effectLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
}
