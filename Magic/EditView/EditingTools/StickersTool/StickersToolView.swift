//
//  StickersToolView.swift
//  Magic
//
//  Created by Devel on 22.12.2022.
//

import UIKit
import SnapKit

protocol StickersToolViewDelegate: AnyObject {
    func selectedSticker(sticker: Sticker?)
}

final class StickersToolView: UIView {
    weak var delegate: StickersToolViewDelegate?
    
    private var dataSource = [Sticker]()
    private let layout = UICollectionViewFlowLayout()
    private var selectedSticker: Sticker? {
        didSet {
            delegate?.selectedSticker(sticker: selectedSticker)
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let clview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        clview.dataSource = self
        clview.delegate   = self
        clview.collectionViewLayout = layout
        clview.showsHorizontalScrollIndicator = false
        clview.showsVerticalScrollIndicator   = false
        clview.backgroundColor = .clear
        clview.register(StickerCollectionCell.self, forCellWithReuseIdentifier: "stickerSizeCell")
        clview.translatesAutoresizingMaskIntoConstraints = false
        return clview
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        Task{
            await getData()
            collectionView.reloadData()
        }
        setupViews()
        setupConstraints()
    }
    
    func viewWillDisappier () {
        delegate?.selectedSticker(sticker: nil)
    }
    
    private func getData () async {
        let stickersURLString = Bundle.main.path(forResource: "stickers", ofType: "json")
        guard let stickersURLString else {
            return
        }
        let stickersURL = URL(fileURLWithPath: stickersURLString)
        do {
            let jsonContent   = try Data(contentsOf: stickersURL)
            dataSource = try JSONDecoder().decode(Stickers.self, from: jsonContent)
                .stickers
        }
        catch {
          print(error)
        }
    }
    
    private func setupViews () {
        addSubview(collectionView)
    }
    
    private func setupConstraints () {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension StickersToolView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stickerSizeCell", for: indexPath) as! StickerCollectionCell
        let image = UIImage(named: dataSource[indexPath.row].name) ?? UIImage()
        cell.setup(image: image)
        return cell
    }
}

extension StickersToolView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSticker = dataSource[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath) as? StickerCollectionCell
        cell?.isSelected = false
    }
}
