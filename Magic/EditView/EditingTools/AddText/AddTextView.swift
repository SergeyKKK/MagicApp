//
//  AddTextView.swift
//  Magic
//
//  Created by Devel on 27.12.2022.
//

import UIKit
import SnapKit

protocol AddTextViewDelegate: AnyObject {
    func showTextRedactor      (object: AddTextView)
    func updateAddTextPosition (object: AddTextView)
}

final class AddTextView: UIView, ImageViewProtocol {
    weak var delegate: AddTextViewDelegate?
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return imageView
    }()
    
    private lazy var label: UILabel = {
        var lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.textColor = .black
        return lbl
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
    
    private lazy var editButton: UIButton = {
        let closeButton = UIButton()
        closeButton.isHidden = true
        let image = UIImage(systemName: "pencil.circle")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        contentMode = .scaleAspectFit
        closeButton.setImage(image, for: .normal)
        closeButton.backgroundColor = .black.withAlphaComponent(0.3)
        closeButton.layer.cornerRadius = 15
        closeButton.addTarget(self, action: #selector(edit), for: .touchUpInside)
        return closeButton
    }()
    
    private var isSelected = false
    private(set) var fontName = "" {
        didSet {
            label.font = fontName.isEmpty ?
            UIFont(name: "Poppins-Regular", size: 24) : UIFont(name: fontName, size: 24)
        }
    }
    
    private(set) var text = "" {
        didSet {
            label.text = text.isEmpty ? "Long press to edit" : text
        }
    }
    
    private(set) var color = UIColor.black {
        didSet {
            label.textColor = color
        }
    }
    
    func update (text: String, color: UIColor) {
        let size = imageView.frame.size
        label.isHidden = false
        self.text     = text
        self.color    = color
        setupView()
        label.sizeToFit()
        renderToImage()
        setupConstraints(size: size)
        label.isHidden = true
        delegate?.updateAddTextPosition(object: self)
    }
    
    func setup (fontName: String, text: String, color: UIColor) {
        label.isHidden = false
        addGestureRecognisers()
        self.fontName = fontName
        self.text     = text
        self.color    = color
        setupView()
        label.sizeToFit()
        renderToImage()
        setupConstraints()
        label.isHidden = true
    }
    
    func togleSelected() {
        closeButton.isHidden = true
        editButton.isHidden  = true
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
    
    private func renderToImage () {
        if label.bounds.size == .zero {
            layoutIfNeeded()
        }
        imageView.image = UIImage.imageWithLabel(label: label)
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
        editButton.isHidden  = false
    }
    
    @objc
    private func close () {
        removeFromSuperview()
    }
    
    @objc
    private func edit () {
        delegate?.showTextRedactor(object: self)
        closeButton.isHidden = true
        editButton.isHidden  = true
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
        subviews.forEach { view in
            view.removeFromSuperview()
        }
        addSubview(label)
        addSubview(imageView)
        addSubview(closeButton)
        addSubview(editButton)
    }
    
    private func setupConstraints(size: CGSize? = nil) {
        if size == nil {
            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview().priority(.low)
            }
        } else {
            imageView.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
                make.size.equalTo(size!).priority(.high)
            }
        }
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(imageView).offset(-7)
            make.trailing.equalTo(imageView).offset(7)
            make.width.height.equalTo(30)
        }
        editButton.snp.makeConstraints { make in
            make.top.equalTo(imageView).offset(-7)
            make.leading.equalTo(imageView).offset(-7)
            make.width.height.equalTo(30)
        }
    }
}
