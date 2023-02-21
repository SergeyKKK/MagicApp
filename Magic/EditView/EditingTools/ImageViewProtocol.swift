//
//  ImageViewProtocol.swift
//  Magic
//
//  Created by Devel on 27.12.2022.
//

import UIKit

protocol ImageViewProtocol: UIView {
    var imageView: UIImageView { get set }
    func setSize(size: CGSize)
    func getRatio () -> CGFloat 
}
