//
//  EditScreen+DelegatesExtension.swift
//  Magic
//
//  Created by Devel on 22.12.2022.
//

import UIKit

extension EditScreen: SliderDelegate {
    func applyFilter(_ at: Int?, type: Int?, value: Any?) {
        if let at, let type, let value {
            let filter = FiltterType.allName[at][type]
            effects[filter] = value
        }
        var currentImage: CIImage = croppedImage ?? originalImage
        
        if let selectedSize,
           let cropArea {
            image = selectedSize.cropImageWithRenderer(image: UIImage(ciImage: currentImage), to: cropArea)
            croppedImage = CIImage(image: image!)
            currentImage = CIImage(image: image!) ?? CIImage()
        }
        let key = FiltterType.CIColorCurves
        if let values = effects[.CIColorCurves] {
            let currentFilter = CIFilter(name: key.effectName)
            currentFilter?.setValue(currentImage, forKey: kCIInputImageKey)
            currentFilter?.setValue(values, forKey: key.inputKey)
            currentImage = currentFilter?.outputImage ?? CIImage()
            image = CropSizes.free.cropImage(image: currentImage, to: (croppedImage ?? originalImage).extent)
            currentImage = CIImage(image: image!) ?? CIImage()
        }
        
        for (key, values) in effects {
            if key == .CIColorCurves { continue }
            currentFilter = CIFilter(name: key.effectName)
            currentFilter.setValue(currentImage, forKey: kCIInputImageKey)
            currentFilter.setValue(values, forKey: key.inputKey)
            currentImage = currentFilter.outputImage ?? CIImage()
        }
        
        if currentFilter != nil {
            image = CropSizes.free.cropImage(image: currentImage, to: (croppedImage ?? originalImage).extent)
        }
        currentFilter = nil
    }
    func applyFilter () {
        applyFilter(nil, type: nil, value: nil)
    }
    
    func saveImage() {
        DatabaseService().saveImageToDocumentDirectory(image: image!, filemame: imageName)
    }
}

extension EditScreen: CropToolViewDelegate {
    func cropSizeSelected(to selectedSize: CropSizes?) {
        self.selectedSize = selectedSize
        setupCropRectangle()
    }
}

extension EditScreen: StickersToolViewDelegate {
    func selectedSticker(sticker: Sticker?) {
        setupSticker(sticker: sticker)
    }
}

extension EditScreen: AddTextToolViewDelegate {
    func selectedFont(font: String?) {
        selectedFont = font
    }
}

extension EditScreen: AddTextViewDelegate {
    func updateAddTextPosition(object: AddTextView) {
        remakeStartConstraints(view: object)
    }
    
    func showTextRedactor (object: AddTextView) {
        let editingVC = EditingTextToolView()
        editingVC.setup(for: object)
        navigationController?.present(editingVC, animated: true)
    }
}

extension EditScreen: CCToolDelegate {
    func correctColors(with inputCurves: InputCurves) {
        self.inputCurves = inputCurves
    }
}
