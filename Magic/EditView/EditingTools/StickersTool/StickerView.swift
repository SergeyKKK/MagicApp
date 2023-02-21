//
//  StickerView.swift
//  Magic
//
//  Created by Devel on 22.12.2022.
//

import UIKit
import SnapKit

final class StickerView: UIView, ImageViewProtocol {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.isHidden = true
        let image = UIImage(systemName: "minus.circle")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        contentMode = .scaleAspectFit
        closeButton.setImage(image, for: .normal)
        closeButton.backgroundColor = .black.withAlphaComponent(0.3)
        closeButton.layer.cornerRadius = 15
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        return closeButton
    }()
    
    private var isSelected = false
    
    func setup (image: UIImage) {
        addGestureRecognisers()
        imageView.image = image
        setupView()
        setupConstraints()
    }
    
    func togleSelected() {
        closeButton.isHidden = true
        isSelected.toggle()
        if isSelected {
            imageView.layer.borderWidth = 2
        } else {
            imageView.layer.borderWidth = 0
        }
    }
    
    func getRatio () -> CGFloat {
        guard let image = imageView.image else {
            return 1
        }
        let width  = image.size.width  > 0 ? image.size.width  : 1
        let height = image.size.height > 0 ? image.size.height : 1
        return width/height
    }
    
    func setSize (size: CGSize) {
        setupConstraints(size: size)
    }
    
    @objc
    private func viewTaped () {
        togleSelected()
    }
    
    @objc
    private func showCloseButton () {
        isSelected = true
        togleSelected()
        closeButton.isHidden = false
    }
    
    @objc
    private func close () {
        removeFromSuperview()
    }
    
    private func addGestureRecognisers () {
        addGestureRecognizer(
            UITapGestureRecognizer(
                target: self, action: #selector(viewTaped)))
        addGestureRecognizer(
            UILongPressGestureRecognizer(
                target: self, action: #selector(showCloseButton)))
    }
    
    private func setupView() {
        addSubview(imageView)
        addSubview(closeButton)
    }
    
    private func setupConstraints(size: CGSize? = nil) {
        if size == nil {
            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        } else {
            imageView.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
                make.size.equalTo(size!).priority(.high)
            }
        }
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-7)
            make.trailing.equalToSuperview().offset(7)
            make.width.height.equalTo(30)
        }
    }
}
