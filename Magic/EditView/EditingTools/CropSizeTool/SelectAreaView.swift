//
//  SelectAreaView.swift
//  Magic
//
//  Created by Devel on 16.12.2022.
//

import UIKit
import SnapKit

final class SelectAreaView: UIView {
    private lazy var vStack: UIStackView = {
        getStack(axis: .vertical)
    }()
    
    private lazy var hStack: UIStackView = {
        getStack(axis: .horizontal)
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
        setupConstraints()
    }
    
    private func getBorderedView () -> UIView {
        let view = UIView()
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 0.75
        view.backgroundColor = .clear
        return view
    }
    
    private func getStack (axis: NSLayoutConstraint.Axis) -> UIStackView {
        let hStack = UIStackView()
        hStack.axis = axis
        hStack.distribution = .fillProportionally
        hStack.addArrangedSubview(getBorderedView())
        hStack.addArrangedSubview(getBorderedView())
        hStack.addArrangedSubview(getBorderedView())
        return hStack
    }
    
    private func setupViews () {
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2
        addSubview(vStack)
        addSubview(hStack)
    }
    
    private func setupConstraints () {
        vStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        hStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
