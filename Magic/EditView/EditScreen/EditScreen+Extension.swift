//
//  EditScreen+Extension.swift
//  Magic
//
//  Created by Devel on 22.12.2022.
//

import UIKit

extension EditScreen {
    func setupPanGesture() {
        // add pan gesture recognizer to the view controller's view (the whole screen)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        // change to false to immediately listen on gesture movement
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: Pan gesture handler
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let point = gesture.location(in: view)
        // Drag to top will be minus value and vice versa
//        print("Pan gesture y offset: \(translation.y)")
        var transformView: TransformViews = .none
        if containerViewIsChanging {
            transformView = .none
        } else if imageView.subviews.contains(cropRectangle) && !cropRectangle.isHidden {
            transformView = .cropRectangle
        } else if !stickers.isEmpty {
            transformView = .stickers
        } else if !addTexts.isEmpty {
            transformView = .addText
        } else {
            transformView = .none
        }
        // Get drag direction
        let isDraggingDown = translation.y > 0
//        print("Dragging direction: \(isDraggingDown ? "going down" : "going up")")
        
        // New height is based on value of dragging plus current container height
        let newHeight = currentContainerHeight - translation.y
        
        // Handle based on gesture state
        switch gesture.state {
        case .began:
            beginPoint = point
            if effectView.frame.contains(point) {
                containerViewIsChanging = true
                return
            }
            switch transformView {
            case .none:
                containerViewIsChanging = true
            case .cropRectangle:
                transformViewBeginFrame = imageView.convert(cropRectangle.frame, to: view)
                if let transformViewBeginFrame,
                   TransformViewByPanHelper().viewIsActive(
                    viewFrame: transformViewBeginFrame, point: point) {
                    transformViewIsChanging = true
                    transformingView = cropRectangle
                }
            case .stickers:
                for stickerView in stickers {
                    let tmpFrame = imageView.convert(stickerView.frame, to: view)
                    if TransformViewByPanHelper().viewIsActive(
                        viewFrame: tmpFrame, point: point) {
                        transformViewIsChanging = true
                        transformViewBeginFrame = tmpFrame
                        transformingView = stickerView
                    }
                }
            case .addText:
                for addTextView in addTexts {
                    let tmpFrame = imageView.convert(addTextView.frame, to: view)
                    if TransformViewByPanHelper().viewIsActive(
                        viewFrame: tmpFrame, point: point) {
                        transformViewIsChanging = true
                        transformViewBeginFrame = tmpFrame
                        transformingView = addTextView
                    }
                }
            }
        case .changed:
            switch transformView {
            case .none:
                if containerViewIsChanging &&
                    newHeight < maximumContainerHeight {
                    // Keep updating the height constraint
                    //                containerViewHeightConstraint?.constant = newHeight
                    containerViewHeightConstraint?.update(offset: newHeight)
                    // refresh layout
                    view.layoutIfNeeded()
                }
            case .cropRectangle, .stickers, .addText:
                let transformHelper = TransformViewByPanHelper()
                if let beginPoint,
                   let transformViewBeginFrame,
                   transformViewIsChanging {
                    let newFrame = transformHelper.getModifiedFrame(
                        frame: transformViewBeginFrame, by: (beginPoint: beginPoint, newPoint: point))
                    let convertedBackFrame = view.convert(newFrame, to: imageView)
                    if transformView == .cropRectangle {
                        setupCropRectangle(to: convertedBackFrame)
                    } else if let transformingView {
                        moveViewToRect(view: transformingView, to: convertedBackFrame)
                    }
                }
            }
        case .ended:
            defer {
                beginPoint = nil
                transformViewBeginFrame = nil
                containerViewIsChanging = false
                transformViewIsChanging = false
                transformingView        = nil
                imageView.isUserInteractionEnabled = isEditingStickers || isEditingTexts
            }
            guard containerViewIsChanging else {
                return
            }
            // This happens when user stop drag,
            // so we will get the last height of container
            
            // Condition 1: If new height is below min, dismiss controller
            if newHeight < dismissibleHeight {
                animateContainerHeight(minimumContainerHeight)
            }
            else if newHeight < defaultHeight {
                // Condition 2: If new height is below default, animate back to default
                animateContainerHeight(defaultHeight)
            }
            else if newHeight < maximumContainerHeight && isDraggingDown {
                // Condition 3: If new height is below max and going down, set to default height
                animateContainerHeight(defaultHeight)
            }
            else if newHeight > defaultHeight && !isDraggingDown {
                // Condition 4: If new height is below max and going up, set to max height at top
                animateContainerHeight(maximumContainerHeight)
            }
        default:
            break
        }
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            // Update container height
//            self.containerViewHeightConstraint?.constant = height
            self.containerViewHeightConstraint?.update(offset: height)
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        // Save current height
        currentContainerHeight = height
    }
    
    // MARK: Present and dismiss animation
    func animatePresentContainer() {
        // update bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
//            self.containerViewBottomConstraint?.constant = 0
            self.containerViewBottomConstraint?.update(offset: 0)
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }

}
