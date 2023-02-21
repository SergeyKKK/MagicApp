//
//  TransformViewByPanHelper.swift
//  Magic
//
//  Created by Devel on 21.12.2022.
//

import UIKit

enum TransformViews {
    case cropRectangle, stickers, addText, none
}

enum TransformViewEdges {
    case none
    case top
    case bottom
    case left
    case right
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case body
}

class TransformViewByPanHelper {
    var minSize: CGSize { CGSize(width: 50, height: 50) }
    
    func viewIsActive (viewFrame: CGRect, point: CGPoint) -> Bool {
        viewFrame.insetBy(dx: -30, dy: -30).contains(point)
    }
    
    func getTouchedEdge(viewFrame: CGRect, point: CGPoint) -> TransformViewEdges {
        guard viewIsActive(viewFrame: viewFrame, point: point) else {
            return .none
        }
        let frame = viewFrame.insetBy (dx: -30, dy: -30)
        
        var bodyRect: CGRect
        if viewFrame.width > 100 && viewFrame.height > 100 {
            bodyRect = viewFrame.insetBy(dx: 30, dy: 30)
        } else if viewFrame.width > 60 && viewFrame.height > 60 {
            bodyRect = viewFrame.insetBy(dx: 15, dy: 15)
        } else {
            bodyRect = viewFrame.insetBy(dx: 7, dy: 7)
        }
        if bodyRect.contains(point) {
            return .body
        }
        
        let cornerSize = CGSize(width: 60, height: 60)
        let topLeftRect = CGRect(origin: frame.origin, size: cornerSize)
        if topLeftRect.contains(point) {
            return .topLeft
        }
        
        let topRightRect = CGRect(origin: CGPoint(x: frame.maxX - cornerSize.width, y: frame.minY), size: cornerSize)
        if topRightRect.contains(point) {
            return .topRight
        }
        
        let bottomLeftRect = CGRect(origin: CGPoint(x: frame.minX, y: frame.maxY - cornerSize.height), size: cornerSize)
        if bottomLeftRect.contains(point) {
            return .bottomLeft
        }
        
        let bottomRightRect = CGRect(origin: CGPoint(x: frame.maxX - cornerSize.width, y: frame.maxY - cornerSize.height), size: cornerSize)
        if bottomRightRect.contains(point) {
            return .bottomRight
        }
        
        let topRect = CGRect(origin: frame.origin, size: CGSize(width: frame.width, height: cornerSize.height))
        if topRect.contains(point) {
            return .top
        }
        
        let bottomRect = CGRect(origin: CGPoint(x: frame.minX, y: frame.maxY - cornerSize.height), size: CGSize(width: frame.width, height: cornerSize.height))
        if bottomRect.contains(point) {
            return .bottom
        }
        
        let leftRect = CGRect(origin: frame.origin, size: CGSize(width: cornerSize.width, height: frame.height))
        if leftRect.contains(point) {
            return .left
        }
        
        let rightRect = CGRect(origin: CGPoint(x: frame.maxX - cornerSize.width, y: frame.minY), size: CGSize(width: cornerSize.width, height: frame.height))
        if rightRect.contains(point) {
            return .right
        }
        
        return .none
    }
    
    func getModifiedFrame(frame: CGRect, by vector: (beginPoint: CGPoint, newPoint: CGPoint)) -> CGRect {
        let edge = getTouchedEdge(viewFrame: frame, point: vector.beginPoint)
        let diffX = ceil(vector.newPoint.x - vector.beginPoint.x)
        let diffY = ceil(vector.newPoint.y - vector.beginPoint.y)
        var x, y, width, height: CGFloat
        switch edge {
        case .none:
            return frame
        case .top:
            x =      frame.origin.x
            y =      frame.origin.y + diffY
            width =  frame.width
            height = frame.height   - diffY
        case .bottom:
            x =      frame.origin.x
            y =      frame.origin.y
            width =  frame.width
            height = frame.height   + diffY
        case .left:
            x =      frame.origin.x + diffX
            y =      frame.origin.y
            width =  frame.width    - diffX
            height = frame.height
        case .right:
            x =      frame.origin.x
            y =      frame.origin.y
            width =  frame.width    + diffX
            height = frame.height
        case .topLeft:
            x =      frame.origin.x + diffX
            y =      frame.origin.y + diffY
            width =  frame.width    - diffX
            height = frame.height   - diffY
        case .topRight:
            x =      frame.origin.x
            y =      frame.origin.y + diffY
            width =  frame.width    + diffX
            height = frame.height   - diffY
        case .bottomLeft:
            x =      frame.origin.x + diffX
            y =      frame.origin.y
            width =  frame.width    - diffX
            height = frame.height   + diffY
        case .bottomRight:
            x =      frame.origin.x
            y =      frame.origin.y
            width =  frame.width    + diffX
            height = frame.height   + diffY
        case .body:
            x =      frame.origin.x + diffX
            y =      frame.origin.y + diffY
            width =  frame.width
            height = frame.height
        }
        if width  < minSize.width  { width  = minSize.width  }
        if height < minSize.height { height = minSize.height }
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
