//
//  CCToolView.swift
//  Magic
//
//  Created by Devel on 23.12.2022.
//

import UIKit

protocol CCToolDelegate: AnyObject {
    var inputCurves: InputCurves { get }
    func correctColors(with inputCurves: InputCurves)
}
/// Color Correction Tool View
final class CCToolView: UIView {
    weak var delegate: CCToolDelegate? = nil
    
    private var dataSource = InputCurves.defaultValues.toDictionary()
    private let layout = UICollectionViewFlowLayout()
    private var selectedToneRange = ToneRange.midtones
    
    private lazy var collectionView: UICollectionView = {
        let clview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        clview.dataSource = self
        clview.delegate   = self
        clview.allowsSelection = false
        clview.collectionViewLayout = layout
        clview.showsHorizontalScrollIndicator = false
        clview.showsVerticalScrollIndicator   = false
        clview.backgroundColor = .clear
        clview.register(CCCollectionCell.self, forCellWithReuseIdentifier: "ccCollectionCell")
        clview.translatesAutoresizingMaskIntoConstraints = false
        return clview
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ToneRange.allCases.map{$0.description})
        control.selectedSegmentIndex = 1
        let font = UIFont(name: "Poppins-SemiBold", size: 14) ?? UIFont.systemFont(ofSize: 14)
        let selectedAttributes    = [NSAttributedString.Key.font: font,
                                     NSAttributedString.Key.foregroundColor: UIColor.black]
        let notSelectedAttributes = [NSAttributedString.Key.font: font,
                                     NSAttributedString.Key.foregroundColor: UIColor.white]
        control.setTitleTextAttributes(notSelectedAttributes, for: .normal)
        control.setTitleTextAttributes(selectedAttributes,    for: .selected)
        control.layer.borderWidth = 0.4
        control.layer.borderColor = #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
        control.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        return control
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
        setupConstraints()
    }
    
    func setup (dataSource: CCDataSource) {
        self.dataSource = dataSource
    }
    
    @objc
    private func segmentedControlValueChanged (_ sender: UISegmentedControl) {
        selectedToneRange = ToneRange(sender.selectedSegmentIndex) ?? .midtones
        collectionView.reloadData()
    }
    
    private func setupViews () {
        addSubview(collectionView)
        addSubview(segmentedControl)
    }
    
    private func setupConstraints () {
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(segmentedControl.snp.top).offset(-20)
        }
        segmentedControl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(200)
            make.height.equalTo(30)
        }
    }
}

extension CCToolView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource[selectedToneRange]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ccCollectionCell", for: indexPath) as! CCCollectionCell
        let rgb   = dataSource[selectedToneRange]
        let color = CCToolColors(rawValue: indexPath.row) ?? .red
        let value = color.rgbaToInt(rgb?[color] ?? -1)
        cell.setup(for: color, range: selectedToneRange, value: value, delegate: self)
        return cell
    }
}

extension CCToolView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = CCToolColors.allCases.count > 3 ?
            collectionView.frame.width / 2 - lay.minimumInteritemSpacing :
                collectionView.frame.width
        return CGSize(width: widthPerItem, height: 40)
    }
}

extension CCToolView: CCCollectionCellDelegate {
    func sliderValueChanged(color: CCToolColors, range: ToneRange, value: Float) {
        dataSource[range]?[color] = value
        delegate?.correctColors(with: InputCurves(dataSource) ?? InputCurves.defaultValues)
    }
}
