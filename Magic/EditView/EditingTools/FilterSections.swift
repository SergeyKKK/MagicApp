//
//  FilterSections.swift
//  Magic
//
//  Created by Devel on 16.12.2022.
//

import Foundation

enum FilterSections: Int, CaseIterable {
    case face = 0, adjust, background, filters, resize, stickers, addText, color
    
    var description: String {
        switch self {
        case .face:
            return "Face"
        case .adjust:
            return "Adjust"
        case .background:
            return "Background"
        case .filters:
            return "Filters"
        case .resize:
            return "Resize"
        case .stickers:
            return "Stickers"
        case .addText:
            return "Add text"
        case .color:
            return "Color"
        }
    }
}
