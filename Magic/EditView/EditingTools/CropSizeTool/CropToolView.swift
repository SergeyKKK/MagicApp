//
//  CropToolView.swift
//  Magic
//
//  Created by Devel on 16.12.2022.
//

import UIKit
import SnapKit

protocol CropToolViewDelegate: AnyObject {
    func cropSizeSelected(to selectedSize: CropSizes?)
}

final class CropToolView: UIView {
    weak var delegate: CropToolViewDelegate?
    
    private let layout = UICollectionViewFlowLayout()
    private var selectedCropSize: Int? = nil {
        didSet {
            delegate?.cropSizeSelected(to: CropSizes(rawValue: selectedCropSize ?? -1))
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
        setupConstraints()
    }
    
    private lazy var collectionView: UICollectionView = {
        let clview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        clview.dataSource = self
        clview.delegate = self
        clview.collectionViewLayout = layout
        clview.showsHorizontalScrollIndicator = false
        clview.backgroundColor = .clear
        clview.register(CropSizeCollectionCell.self, forCellWithReuseIdentifier: "cropSizeCell")
        clview.translatesAutoresizingMaskIntoConstraints = false
        return clview
    }()
    
    private func setupViews () {
        addSubview(collectionView)
    }
    
    private func setupConstraints () {
        collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(68)
            make.height.equalTo(100)
        }
    }
}

extension CropToolView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        CropSizes.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cropSizeCell", for: indexPath) as! CropSizeCollectionCell
        cell.setup(size: CropSizes.allCases[indexPath.row])
        return cell
    }
}

extension CropToolView: UICollectionViewDelegate {
    func deselectCropSize () {
        selectedCropSize = nil
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCropSize = indexPath.row
        let cell = collectionView.cellForItem(at: indexPath) as? CropSizeCollectionCell
        cell?.togleSelected()
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CropSizeCollectionCell
        cell?.togleSelected()
    }
}

