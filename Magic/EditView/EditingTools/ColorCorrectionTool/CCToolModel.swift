//
//  CCModel.swift
//  Magic
//
//  Created by Devel on 24.12.2022.
//

import UIKit

struct RGB {
    var red:   Float
    var green: Float
    var blue:  Float
    
    func toDictionary () -> CCColorsData {
        var cd = CCColorsData()
        cd[.red]   = red
        cd[.green] = green
        cd[.blue]  = blue
        return cd
    }
}
extension RGB {
    init?(_ dict: CCColorsData) {
        guard let red   = dict[.red],
              let green = dict[.green],
              let blue  = dict[.blue] else {
            return nil
        }
        self.init(red: red, green: green, blue: blue)
    }
}

struct InputCurves {
    static let defaultValues = InputCurves(shadows:    RGB(red:0.0, green:0.0, blue:0.0),
                                           midtones:   RGB(red:0.5, green:0.5, blue:0.5),
                                           highlights: RGB(red:1.0, green:1.0, blue:1.0))
    var shadows:    RGB
    var midtones:   RGB
    var highlights: RGB
    
    func toDictionary () -> CCDataSource {
        var cd = CCDataSource()
        cd[.shadows]    = shadows.toDictionary()
        cd[.midtones]   = midtones.toDictionary()
        cd[.highlights] = highlights.toDictionary()
        return cd
    }
}
extension InputCurves {
    init?(_ dict: CCDataSource) {
        guard let shadowsD    = dict[.shadows],
              let midtonesD   = dict[.midtones],
              let highlightsD = dict[.highlights],
              let shadows     = RGB(shadowsD),
              let midtones    = RGB(midtonesD),
              let highlights  = RGB(highlightsD) else {
            return nil
        }
        self.init(shadows: shadows, midtones: midtones, highlights: highlights)
    }
}

typealias CCColorsData = [CCToolColors : Float]
typealias CCDataSource = [ToneRange : CCColorsData]

enum ToneRange: String, CaseIterable {
    case shadows
    case midtones
    case highlights
    
    var description: String {
        self.rawValue.capitalized
    }
}
extension ToneRange {
    init?(_ value: Int) {
        guard value >= 0 && value < ToneRange.allCases.count else {
            return nil
        }
        var rawValue = ""
        switch value {
        case 0:  rawValue = ToneRange.shadows.rawValue
        case 2:  rawValue = ToneRange.highlights.rawValue
        default: rawValue = ToneRange.midtones.rawValue
        }
        self.init(rawValue: rawValue)
    }
}

enum CCToolColors: Int, CaseIterable {
    case red = 0, green, blue
    
    var uiColor: UIColor {
        switch self {
        case .red:
            return .red
        case .green:
            return .green
        case .blue:
            return .blue
        }
    }
    
    var cgColor: CGColor {
        return self.uiColor.cgColor
    }
    
    var name: String {
        switch self {
        case .red:
            return "Red"
        case .green:
            return "Green"
        case .blue:
            return "Blue"
        }
    }
    
    /// Converts values from range  range 0...1 for rgba to int 0...100: value * 100
    func rgbaToInt (_ value: Float) -> Int {
        Int(value * 100)
    }
    /// Converts values from range 0...100 to range 0...1 for rgba: value / 100
    func valueToRgba (_ value: Int) -> Float {
        Float(value) / 100
    }
    /// Converts values from range 0...100 to range 0...1 for rgba: value / 100
    func valueToRgba (_ value: Double) -> Float {
        Float(value) / 100
    }
    /// Converts values from range 0...100 to range 0...1 for rgba: value / 100
    func valueToRgba (_ value: Float) -> Float {
        value / 100
    }
}
