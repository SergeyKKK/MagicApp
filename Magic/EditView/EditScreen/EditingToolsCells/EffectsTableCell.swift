//
//  EffectsCell.swift
//  Magic
//
//  Created by Nodir on 05/11/22.
//

import UIKit

protocol SliderDelegate: AnyObject {
    func applyFilter(_ at: Int?, type: Int?, value: Any?)
    func saveImage()
}

class EffectsTableCell: UITableViewCell {
    
     var sliderDelegate: SliderDelegate?
    
    lazy var slider: UISlider = {
        var slr = SliderView()
        slr.maximumValue = 0
        slr.maximumValue = 100
        slr.thumbTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        slr.minimumTrackTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        slr.maximumTrackTintColor = #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
        slr.addTarget(self, action: #selector(updateEffectValue(_:)), for: .valueChanged)
        slr.translatesAutoresizingMaskIntoConstraints = false
        return slr
    }()
    
    lazy var effectName: UILabel = {
        var lbl = UILabel()
        lbl.font = UIFont(name: "Poppins-SemiBold", size: 14)
        lbl.numberOfLines = 1
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    lazy var effectValue: UILabel = {
        var lbl = UILabel()
        lbl.font = UIFont(name: "Poppins-Medium", size: 14)
        lbl.numberOfLines = 1
        lbl.textColor = .white
        lbl.textAlignment = .right
        lbl.text = "0"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    lazy var stackLabel: UIStackView = {
        var stk = UIStackView()
        stk.alignment = .fill
        stk.distribution = .fillProportionally
        stk.addArrangedSubview(effectName)
        stk.addArrangedSubview(effectValue)
        stk.axis = .horizontal
        stk.translatesAutoresizingMaskIntoConstraints = false
        return stk
    }()
    
    lazy var stackView: UIStackView = {
        var stk = UIStackView()
        stk.alignment = .fill
        stk.distribution = .fillProportionally
        stk.addArrangedSubview(stackLabel)
        stk.addArrangedSubview(slider)
        stk.axis = .vertical
        stk.spacing = 10
        stk.translatesAutoresizingMaskIntoConstraints = false
        return stk
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
            stackView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -20)
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @objc func updateEffectValue(_ sender: UISlider) {
        effectValue.text = String(Int(sender.value))
    }
    
}
