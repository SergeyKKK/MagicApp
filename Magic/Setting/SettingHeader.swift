//
//  SettingHeader.swift
//  Magic
//
//  Created by Nodir on 26/11/22.
//

import UIKit

class SettingHeader: UITableViewHeaderFooterView {
    
    lazy var sectionTitle: UILabel = {
        var lbl = UILabel()
        lbl.font = UIFont(name: "Poppins-Regular", size: 18)
        lbl.numberOfLines = 1
        lbl.textColor = .black
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)
        contentView.addSubview(sectionTitle)
        
        NSLayoutConstraint.activate([
            sectionTitle.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10),
            sectionTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -5),
            sectionTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            sectionTitle.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -50),
            sectionTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sectionTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
