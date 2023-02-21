//
//  SettingTableCell.swift
//  Magic
//
//  Created by Nodir on 26/11/22.
//

import UIKit

class SettingTableCell: UITableViewCell {
    
    var icon: UIImageView = {
        var img = UIImageView()
        img.contentMode = .center
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    lazy var cellName: UILabel = {
        var lbl = UILabel()
        lbl.font = UIFont(name: "Poppins-Medium", size: 16)
        lbl.numberOfLines = 1
        lbl.textColor = #colorLiteral(red: 0.1965786219, green: 0.1737982035, blue: 0.256868571, alpha: 1)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    lazy var stack: UIStackView = {
        var stk = UIStackView()
        stk.axis = .horizontal
        stk.distribution = .fillProportionally
        stk.spacing = 20
        stk.addArrangedSubview(icon)
        stk.addArrangedSubview(cellName)
        stk.translatesAutoresizingMaskIntoConstraints = false
        return stk
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let border = CALayer()
        border.backgroundColor = UIColor(red: 0.776, green: 0.776, blue: 0.784, alpha: 0.4).cgColor
        border.frame = CGRect(x: 64, y: -0.5, width: 289, height: 1)
        contentView.layer.addSublayer(border)

        self.contentView.addSubview(stack)
        contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 20),
            
            stack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4.5),
            stack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 30),
            stack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -30),
            stack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension UIView {
    func addBorderTop(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: frame.width, height: size, color: color)
    }
    func addBorderBottom(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 30, y: frame.height - size, width: frame.width, height: size, color: color)
    }
    func addBorderLeft(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: size, height: frame.height, color: color)
    }
    func addBorderRight(size: CGFloat, color: UIColor) {
        addBorderUtility(x: frame.width - size, y: 0, width: size, height: frame.height, color: color)
    }
    private func addBorderUtility(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        layer.addSublayer(border)
    }
}
