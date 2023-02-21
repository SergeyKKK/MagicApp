//
//  AddTextToolView.swift
//  Magic
//
//  Created by Devel on 27.12.2022.
//

import UIKit
import SnapKit

protocol AddTextToolViewDelegate: AnyObject {
    func selectedFont(font: String?)
}

final class AddTextToolView: UIView {
    weak var delegate: AddTextToolViewDelegate?
    
    private var dataSource = [String]()
    private let layout = UICollectionViewFlowLayout()
    private var selectedFont: String? {
        didSet {
            delegate?.selectedFont(font: selectedFont)
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
        clview.register(AddTextCollectionCell.self, forCellWithReuseIdentifier: "addTextCollectionCell")
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
        delegate?.selectedFont(font: nil)
    }
    
    private func getData () async {
        let fontsURLString = Bundle.main.path(forResource: "fonts", ofType: "json")
        guard let fontsURLString else {
            return
        }
        let fontsURL = URL(fileURLWithPath: fontsURLString)
        do {
            let jsonContent   = try Data(contentsOf: fontsURL)
            dataSource = try JSONDecoder().decode(AddTextFonts.self, from: jsonContent)
                .fonts.map{$0.name}
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

extension AddTextToolView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addTextCollectionCell", for: indexPath) as! AddTextCollectionCell
        let text = dataSource[indexPath.row]
        cell.setup(fontName: text)
        return cell
    }
}

extension AddTextToolView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedFont = dataSource[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath) as? AddTextCollectionCell
        cell?.isSelected = false
    }
}

extension AddTextToolView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let height = 45.0
        let width  = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
