//
//  HomeCollectionViewCell.swift
//  Magic
//
//  Created by Nodir on 03/11/22.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    lazy var image: UIImageView = {
        var img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        img.clipsToBounds = true
        img.layer.cornerRadius = 15
        img.setContentHuggingPriority(.defaultLow, for: .vertical)
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    lazy var applyButton: UIButton = {
        var btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "Apply"), for: .normal)
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.removeFromSuperview()
        applyButton.removeFromSuperview()

    }

    
    private func setupView() {
        
        contentView.addSubview(image)
        contentView.addSubview(applyButton)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            image.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -20),
            
            applyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            applyButton.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            applyButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            applyButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    
}
