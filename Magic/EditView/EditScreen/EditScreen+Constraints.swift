//
//  EditScreen+GesturesExtension.swift
//  Magic
//
//  Created by Devel on 22.12.2022.
//

import UIKit
import SnapKit

extension EditScreen {
    func setupContainerConstraints() {
        effectView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            containerViewHeightConstraint = make.height.equalTo(defaultHeight).constraint
            containerViewBottomConstraint = make.bottom.equalToSuperview()
                .offset(defaultHeight).constraint
        }
    }
    
    func setupImageViewConstraints() {
        if !view.subviews.contains(imageView) {
            view.insertSubview(imageView, at: 0)
        }
        imageView.snp.removeConstraints()
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
                .offset(-minimumContainerHeight-16)
            make.width.equalTo(imageView.snp.height).multipliedBy(
                imgSize.width/imgSize.height
            )
        }
    }
    
    func setupCropRectangle (to frame: CGRect? = nil) {
        func hide () {
            confirmButton.isHidden = true
            cropRectangle.snp.removeConstraints()
            cropRectangle.removeFromSuperview()
        }
        guard let selectedSize else {
            hide()
            return
        }
        if  frame == nil { hide() }
        if !imageView.contains(cropRectangle) {
            confirmButton.isHidden = false
            imageView.addSubview(cropRectangle)
            cropRectangle.snp.makeConstraints { make in
                make.top.greaterThanOrEqualToSuperview().priority(.medium)
                make.leading.greaterThanOrEqualToSuperview().priority(.medium)
                make.trailing.lessThanOrEqualToSuperview().priority(.medium)
                make.bottom.lessThanOrEqualToSuperview().priority(.medium)
                make.width.height.equalToSuperview().priority(.low)
                make.center.equalToSuperview().priority(.low)
                let priority: ConstraintPriority = selectedSize == .free ? .low : .high
                make.width.equalTo(cropRectangle.snp.height).multipliedBy(selectedSize.aspectRatio).priority(priority)
            }
        }
        if let frame {
            cropRectangle.snp.remakeConstraints { make in
                make.top.greaterThanOrEqualToSuperview().priority(.high)
                make.leading.greaterThanOrEqualToSuperview().priority(.high)
                make.trailing.lessThanOrEqualToSuperview().priority(.high)
                make.bottom.lessThanOrEqualToSuperview().priority(.high)
                make.leading.equalToSuperview().offset(frame.minX).priority(.low)
                make.top.equalToSuperview().offset(frame.minY).priority(.low)
                make.width.equalTo(frame.width).priority(.medium)
                make.height.equalTo(frame.height).priority(.medium)
                let priority: ConstraintPriority = selectedSize == .free ? .low : .high
                make.width.equalTo(cropRectangle.snp.height).multipliedBy(selectedSize.aspectRatio).priority(priority)
            }
        }
    }
    
    func moveViewToRect (view: UIView, to frame: CGRect? = nil) {
        if  frame == nil { view.removeFromSuperview() }
        if !imageView.contains(view) {
            imageView.addSubview(view)
            view.snp.makeConstraints { make in
                make.center.equalToSuperview()
                if view is AddTextView {
                    make.width.height.lessThanOrEqualTo(200).priority(.low)
                    make.width.height.greaterThanOrEqualTo(50).priority(.medium)
                    make.width.height.lessThanOrEqualToSuperview().priority(.high)
                } else {
                    make.width.height.equalTo(100).priority(.high)
                }
                if let imView = view as? ImageViewProtocol {
                    let ratio = imView.getRatio()
                    make.width.equalTo(view.snp.height).multipliedBy(ratio).priority(.required)
                }
            }
        }
        if let frame {
            view.snp.remakeConstraints { make in
                make.top.greaterThanOrEqualToSuperview().priority(.required)
                make.leading.greaterThanOrEqualToSuperview().priority(.required)
                make.trailing.lessThanOrEqualToSuperview().priority(.required)
                make.bottom.lessThanOrEqualToSuperview().priority(.required)
                make.leading.equalToSuperview().offset(frame.minX).priority(.low)
                make.top.equalToSuperview().offset(frame.minY).priority(.low)
                make.width.equalTo(frame.width).priority(.medium)
                make.height.equalTo(frame.height).priority(.medium)
                if let imView = view as? ImageViewProtocol {
                    imView.setSize(size: frame.size)
                    let ratio = imView.getRatio()
                    make.width.equalTo(view.snp.height).multipliedBy(ratio).priority(.required)
                }
            }
        }
    }
    
    func remakeStartConstraints (view: AddTextView) {
        view.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.lessThanOrEqualTo(200).priority(.low)
            make.width.height.greaterThanOrEqualTo(50).priority(.medium)
            make.width.height.lessThanOrEqualToSuperview().priority(.high)
            let ratio = view.getRatio()
            make.width.equalTo(view.snp.height).multipliedBy(ratio).priority(.required)
        }
    }
}
