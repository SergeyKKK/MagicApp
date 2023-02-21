//
//  CustomSlider.swift
//  Magic
//
//  Created by Nodir on 05/11/22.
//

import UIKit


class SliderView: UISlider {
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var result = super.trackRect(forBounds: bounds)
        result.size.width = bounds.size.width - 10
        result.size.height = 1
        return result
    }
}
