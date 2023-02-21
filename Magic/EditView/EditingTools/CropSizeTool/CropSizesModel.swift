//
//  CropSizeModel.swift
//  Magic
//
//  Created by Devel on 16.12.2022.
//

import UIKit

enum CropSizes: Int, CaseIterable {
    case free = 0, oneToOne, twoToThree, threeToTwo, threeToFour, fourToThree
    
    var description: String {
        switch self {
        case .free:
            return "Free"
        case .oneToOne:
            return "1:1"
        case .twoToThree:
            return "2:3"
        case .threeToTwo:
            return "3:2"
        case .threeToFour:
            return "3:4"
        case .fourToThree:
            return "4:3"
        }
    }
    
    var aspectRatio: CGFloat {
        switch self {
        case .free:
            return 2/3
        case .oneToOne:
            return 1
        case .twoToThree:
            return 2/3
        case .threeToTwo:
            return 3/2
        case .threeToFour:
            return 3/4
        case .fourToThree:
            return 4/3
        }
    }
    
    func cropImage(image: CIImage, to selectedArea: CGRect) -> UIImage {
        guard let cropFilter = CIFilter(name: "CICrop") else {
            return UIImage(ciImage: image)
        }
        cropFilter.setValue(image, forKey: kCIInputImageKey)
        cropFilter.setValue(CIVector(cgRect: selectedArea), forKey: "inputRectangle")
        let context = CIContext()
        guard let output = cropFilter.outputImage,
              let cgimg = context.createCGImage(output, from: output.extent) else {
            return UIImage()
        }
        return UIImage(cgImage: cgimg)
    }
    
    func cropImageWithRenderer (image: UIImage, to scaledRect: CGRect) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = image.scale
        format.opaque = false
        
        return UIGraphicsImageRenderer(bounds: scaledRect, format: format).image { _ in
            image.draw(at: .zero)
        }
    }
}
