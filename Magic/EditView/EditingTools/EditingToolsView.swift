//
//  EditingToolsView.swift
//  Magic
//
//  Created by Nodir on 06/11/22.
//

import UIKit
import SnapKit

class EditingToolsView: UIView {
    weak var cropToolDelegate:    CropToolViewDelegate?
    weak var stickerToolDelegate: StickersToolViewDelegate?
    weak var addTextToolDelegate: AddTextToolViewDelegate?
    weak var sliderDelegate:      SliderDelegate?
    weak var cCToolDelegate:      CCToolDelegate?
    private let layout = UICollectionViewFlowLayout()
    
    lazy var collectionView: UICollectionView = {
        let clview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        clview.dataSource = self
        clview.delegate = self
        clview.collectionViewLayout = layout
        clview.showsHorizontalScrollIndicator = false
        clview.backgroundColor = .clear
        clview.register(EffectsCollectionCell.self, forCellWithReuseIdentifier: "clCell")
        clview.translatesAutoresizingMaskIntoConstraints = false
        return clview
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.register(EffectsTableCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var cropToolView: CropToolView = {
        let view = CropToolView(frame: CGRect.zero)
        view.delegate = cropToolDelegate
        return view
    }()
    
    lazy var stickersToolView: StickersToolView = {
        let view = StickersToolView(frame: CGRect.zero)
        view.delegate = stickerToolDelegate
        return view
    }()
    
    lazy var addTextToolView: AddTextToolView = {
        let view = AddTextToolView(frame: CGRect.zero)
        view.delegate = addTextToolDelegate
        return view
    }()
    
    lazy var magicCorrectionButton: UIButton = {
        var btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "MagicButton"), for: .normal)
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(magicCorrectionPressed(_:)), for: .touchUpInside)
        return btn
    }()
    
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var selectedEffect = 0
    var effects = ["Face", "Adjust", "Background", "Filters", "Resize", "Stickers", "Add Text", "Color"]
    var filters = FiltterType.allName
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    
    private func setupTool (view: UIView) {
        prepareToolToClose(view: view)
        let views: [UIView] = [
            cropToolView,
            stickersToolView,
            addTextToolView,
            containerView.subviews.first(where: {$0 is CCToolView}),
            tableView
        ].compactMap{$0}.filter({!($0 === view)})
        views.forEach { view in
            if view === tableView {
                tableView.isHidden = true
            } else {
                view.snp.removeConstraints()
                view.removeFromSuperview()
            }
        }
        if view === tableView {
            tableView.isHidden = false
        } else {
            containerView.addSubview(view)
            view.snp.makeConstraints { make in
                make.edges.equalTo(tableView).priority(.low)
                if let superview {
                    make.bottom.lessThanOrEqualTo(superview.safeAreaLayoutGuide.snp.bottom)
                }
            }
        }
    }
    
    private func prepareToolToClose (view: UIView) {
        if view != cropToolView     {
            cropToolView.deselectCropSize()
        }
        if view != stickersToolView {
            stickersToolView.viewWillDisappier()
        }
        if view != addTextToolView  {
            addTextToolView.viewWillDisappier()
        }
    }
    
    private func setupUI() {
        
        self.addSubview(collectionView)
        self.addSubview(containerView)
        self.containerView.addSubview(magicCorrectionButton)
        self.containerView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            collectionView.heightAnchor.constraint(equalToConstant: 33),
            
            // set container static constraint (trailing & leading)
            containerView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            magicCorrectionButton.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 20),
            magicCorrectionButton.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            magicCorrectionButton.heightAnchor.constraint(equalToConstant: 54),
            
            tableView.topAnchor.constraint(lessThanOrEqualTo: self.magicCorrectionButton.bottomAnchor, constant: 25),
            tableView.widthAnchor.constraint(equalTo: self.magicCorrectionButton.widthAnchor),
            tableView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            
        ])
        
    }
    
    
    @objc func magicCorrectionPressed(_ sender: UIButton) {
        
        sliderDelegate?.saveImage()
        print("magicCorrectionPressed")
    }

}

extension EditingToolsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clCell", for: indexPath) as! EffectsCollectionCell
        cell.effectLabel.text = FilterSections(rawValue: indexPath.row)?.description
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if FilterSections(rawValue: indexPath.row) == .resize {
            setupTool(view: cropToolView)
        } else if FilterSections(rawValue: indexPath.row) == .stickers {
            setupTool(view: stickersToolView)
        } else if FilterSections(rawValue: indexPath.row) == .addText {
            setupTool(view: addTextToolView)
        } else if FilterSections(rawValue: indexPath.row) == .color {
            let cCToolView = CCToolView(frame: CGRect.zero)
            cCToolView.delegate = cCToolDelegate
            cCToolView.setup(
                dataSource: cCToolDelegate?.inputCurves.toDictionary() ??
                InputCurves.defaultValues.toDictionary())
            setupTool(view: cCToolView)
        } else {
            setupTool(view: tableView)
            selectedEffect = indexPath.row
            self.tableView.reloadData()
        }
        let cell = collectionView.cellForItem(at: indexPath) as? EffectsCollectionCell
        cell?.togleSelected()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? EffectsCollectionCell
        cell?.togleSelected()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = FilterSections(rawValue: indexPath.row)?.description
        label.sizeToFit()
        
        return CGSize(width: label.frame.width + 30, height: 33)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
}

extension EditingToolsView: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EffectsTableCell
        cell.backgroundColor = .clear
        cell.effectName.text = filters[selectedEffect][indexPath.row].name
        cell.slider.tag = indexPath.row
        cell.slider.minimumValue = filters[selectedEffect][indexPath.row].filterMin
        cell.slider.maximumValue = filters[selectedEffect][indexPath.row].filterMax
        
        cell.slider.addTarget(self, action: #selector(updateValue(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    @objc func updateValue(_ sender: UISlider) {
        sliderDelegate?.applyFilter(selectedEffect, type: sender.tag, value: sender.value)
    }


}


