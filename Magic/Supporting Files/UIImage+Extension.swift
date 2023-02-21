//
//  UIImage+Extension.swift
//  Magic
//
//  Created by Devel on 27.12.2022.
//

import UIKit

extension UIImage {
    class func imageWithLabel(label: UILabel) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        label.layer.render(in: context)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img ?? UIImage()
    }
    
    func buildImage(imViews: [ImageViewProtocol], scale: CGFloat) -> UIImage {
        let imageSize = self.size
        let format = UIGraphicsImageRendererFormat()
        format.scale = self.scale
        format.opaque = false
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, self.scale)
        self.draw(at: .zero)
        
        if !imViews.isEmpty, let context = UIGraphicsGetCurrentContext() {
            context.concatenate(CGAffineTransform(scaleX: scale, y: scale))
            imViews.forEach({ imView in
                imView.imageView.image!.draw(in: imView.frame)
            })
            context.concatenate(CGAffineTransform(scaleX: 1 / scale, y: 1 / scale))
        }
        
        let temp = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgi = temp?.cgImage else {
            return self
        }
        return UIImage(cgImage: cgi, scale: self.scale, orientation: .up)
    }
}
