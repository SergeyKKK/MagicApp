//
//  CCCollectionCell.swift
//  Magic
//
//  Created by Devel on 24.12.2022.
//

import UIKit
import SnapKit

protocol CCCollectionCellDelegate: AnyObject {
    func sliderValueChanged (color: CCToolColors, range: ToneRange, value: Float)
}

final class CCCollectionCell: UICollectionViewCell {
    weak var sliderDelegate: CCCollectionCellDelegate?
    
    private var color: CCToolColors = .red
    private var value    = 50
    private var oldValue = 50
    private var selectedToneRange: ToneRange = .midtones
    
    private lazy var slider: UISlider = {
        var slr = SliderView()
        slr.minimumValue = 0
        slr.maximumValue = 100
        slr.value = Float(value)
        slr.thumbTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        slr.minimumTrackTintColor = color.uiColor
        slr.maximumTrackTintColor = #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
        slr.addTarget(self, action: #selector(updateValue(_:)),     for: .valueChanged)
        slr.addTarget(self, action: #selector(sliderDidEndChanges), for: .touchUpInside)
        slr.addTarget(self, action: #selector(sliderDidEndChanges), for: .touchUpOutside)
        return slr
    }()
    
    private lazy var nameLabel: UILabel = {
        var lbl = UILabel()
        lbl.font = UIFont(name: "Poppins-SemiBold", size: 14)
        lbl.numberOfLines = 1
        lbl.textColor = .white
        return lbl
    }()
    
    private lazy var valueLabel: UILabel = {
        var lbl = UILabel()
        lbl.font = UIFont(name: "Poppins-Medium", size: 14)
        lbl.numberOfLines = 1
        lbl.textColor = .white
        lbl.textAlignment = .right
        lbl.text = "0"
        return lbl
    }()
    
    private lazy var stack: UIStackView = {
        var stk = UIStackView()
        stk.alignment = .fill
        stk.distribution = .fillProportionally
        stk.addArrangedSubview(nameLabel)
        stk.addArrangedSubview(valueLabel)
        stk.axis = .horizontal
        return stk
    }()
    
    private lazy var stackView: UIStackView = {
        var stk = UIStackView()
        stk.alignment = .fill
        stk.distribution = .fillProportionally
        stk.addArrangedSubview(stack)
        stk.addArrangedSubview(slider)
        stk.axis = .vertical
        stk.spacing = 10
        return stk
    }()
    
    func setup (for color: CCToolColors, range: ToneRange, value: Int, delegate: CCCollectionCellDelegate?) {
        self.color = color
        selectedToneRange = range
        if value >= 0 && value <= 100 {
            self.value = value
            oldValue   = value
        }
        self.sliderDelegate = delegate
        setupViews()
        setupConstraints()
    }
    
    @objc
    private func updateValue (_ sender: UISlider) {
        self.value = Int(sender.value)
        valueLabel.text = String(self.value)
    }
    
    @objc
    private func sliderDidEndChanges () {
        if value != oldValue {
            sliderDelegate?.sliderValueChanged(
                color: color, range: selectedToneRange, value: color.valueToRgba(value))
            oldValue = value
        }
    }
    
    private func setupViews () {
        nameLabel.text = color.name
        valueLabel.text = value.description
        slider.value = Float(value)
        slider.minimumTrackTintColor = color.uiColor
        contentView.addSubview(stackView)
    }
    
    private func setupConstraints () {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview().offset(0)
        }
    }
}
