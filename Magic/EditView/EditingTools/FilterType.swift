//
//  FilterType.swift
//  Magic
//
//  Created by Nodir on 18/11/22.
//

import CoreImage


enum FiltterType: Int, CaseIterable {
    case Blur
    case Bloom
    case DepthOfField
    
    case HiglightShadow
    case HueAdjust
    case SepiaTone
    
    case NoiceReduction
    case UnsharpMask
    case Gloom
 
    case Crystalise
    case Pixlate
    case HalfTone
    
    case CIColorCurves
    
    static var arr: [String] {
        return FiltterType.allCases.map { $0.name }
    }
    
    static var allName: [[FiltterType]] {
        return [[Blur, Bloom, DepthOfField], [HiglightShadow, HueAdjust, SepiaTone], [NoiceReduction, UnsharpMask, Gloom], [Crystalise, Pixlate, HalfTone], [], [], [], [CIColorCurves]]
    }
    
    var name: String {
        switch self {
        case .Blur:             return "Blur"
        case .Bloom:            return "Bloom"
        case .DepthOfField:     return "Depth Field"
        
        case .HiglightShadow:   return "Highligt Shadow"
        case .HueAdjust:        return "Hue"
        case .SepiaTone:        return "Sepia Tone"
        
        case .NoiceReduction:   return "Noice Reduction"
        case .UnsharpMask:      return "Unsharp Mask"
        case .Gloom:            return "Gloom"
        
        case .Crystalise:       return "Crystalise"
        case .Pixlate:          return "Pixlate"
        case .HalfTone:         return "Half Tone"
            
        case .CIColorCurves:    return "Color Curves"
        }
    }
    
    var effectName: String {
        switch self {
        case .Blur:             return "CIGaussianBlur"
        case .Bloom:            return "CIBloom"
        case .DepthOfField:     return "CIDepthOfField"
        
        case .HiglightShadow:   return "CIHighlightShadowAdjust"
        case .HueAdjust:        return "CIHueAdjust"
        case .SepiaTone:        return "CISepiaTone"
        
        case .NoiceReduction:   return "CINoiseReduction"
        case .UnsharpMask:      return "CIUnsharpMask"
        case .Gloom:            return "CIGloom"
        
        case .Crystalise:       return "CICrystallize"
        case .Pixlate:          return "CIPixellate"
        case .HalfTone:         return "CICMYKHalftone"
            
        case .CIColorCurves:    return "CIColorCurves"
        }
    }
    
    var inputKey: String {
        switch self {
        case .Blur:             return kCIInputRadiusKey
        case .Bloom:            return kCIInputRadiusKey
        case .DepthOfField:     return kCIInputRadiusKey

        case .HiglightShadow:   return kCIInputRadiusKey
        case .HueAdjust:        return kCIInputAngleKey
        case .SepiaTone:        return kCIInputIntensityKey
        
        case .NoiceReduction:   return kCIInputSharpnessKey
        case .UnsharpMask:      return kCIInputRadiusKey
        case .Gloom:            return kCIInputRadiusKey
     
        case .Crystalise:       return kCIInputRadiusKey
        case .Pixlate:          return kCIInputScaleKey
        case .HalfTone:         return kCIInputWidthKey
            
        case .CIColorCurves:    return "inputCurvesData"
        }
    }
    
    var filterMin: Float {
        switch self {
        case .Blur:             return 0
        case .Bloom:            return 0
        case .DepthOfField:     return 0
        
        case .HiglightShadow:   return 0
        case .HueAdjust:        return 0
        case .SepiaTone:        return 0
        
        case .NoiceReduction:   return 0
        case .UnsharpMask:      return 0
        case .Gloom:            return 0
     
        case .Crystalise:       return 1
        case .Pixlate:          return 1
        case .HalfTone:         return 1
            
        case .CIColorCurves:    return 0
        }
    }
    
    var filterMax: Float {
        switch self {
        case .Blur:             return 100
        case .Bloom:            return 100
        case .DepthOfField:     return 30
        
        case .HiglightShadow:   return 10
        case .HueAdjust:        return 100
        case .SepiaTone:        return 1
        
        case .NoiceReduction:   return 20
        case .UnsharpMask:      return 100
        case .Gloom:            return 100
     
        case .Crystalise:       return 100
        case .Pixlate:          return 100
        case .HalfTone:         return 100
            
        case .CIColorCurves:    return 100
        }
    }
    
}
