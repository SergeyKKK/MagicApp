//
//  EditScreen.swift
//  Magic
//
//  Created by Nodir on 04/11/22.
//

import UIKit

class EditScreen: UIViewController, SliderDelegate {
    
    var imageName: String = ""
    var image: UIImage? {

        didSet {
            imageView.image = image
        }
    }

    lazy var backButton: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(named: "Back"), for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn.addTarget(self, action: #selector(backPresssed(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var shareButton: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(named: "Save"), for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn.addTarget(self, action: #selector(sharePresssed(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var imageView: UIImageView = {
        var img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    // Constants
    let defaultHeight: CGFloat = 400
    let dismissibleHeight: CGFloat = 200
    let maximumContainerHeight: CGFloat = 400
    let minimumContainerHeight: CGFloat = 150
    
    // keep current new height, initial is default height
    var currentContainerHeight: CGFloat = 350
    
    // Dynamic container constraint
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    var context: CIContext!
    var currentFilter: CIFilter!
    var originalImage: CIImage!
    var output: CIImage!
    var effects: [FiltterType: Float] = [:]
    let effectView = EditingToolsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupConstraints()
        // Add action
        setupPanGesture()
        
        effectView.sliderDelegate = self
        context = CIContext()
        originalImage = CIImage(image: image!)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animatePresentContainer()
    }
    
    private func setupConstraints() {
        view.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        //NAVBAR
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareButton)
        
        if #available(iOS 13, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()

            navigationController?.navigationBar.standardAppearance = appearance
        }  else {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.isTranslucent = true
        }
        
        // cosmetics
        self.view.addSubview(imageView)
        self.view.addSubview(effectView)
        self.view.addSubview(backButton)
        self.view.addSubview(shareButton)
        
        effectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalToConstant: calculateImageHeight(sourceImage: imageView.image!, scaledToWidth: view.frame.width)),
            
            // set container static constraint (trailing & leading)
            effectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            effectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

        ])
        
        
        // Set dynamic constraints
        // First, set container to default height
        // after panning, the height can expand
        containerViewHeightConstraint = effectView.heightAnchor.constraint(equalToConstant: defaultHeight)

        // By setting the height to default height, the container will be hide below the bottom anchor view
        // Later, will bring it up by set it to 0
        // set the constant to default height to bring it down again
        containerViewBottomConstraint = effectView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        // Activate constraints
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
        
    }
    
    func calculateImageHeight(sourceImage: UIImage, scaledToWidth: CGFloat) -> CGFloat {
        let oldWidth = CGFloat(sourceImage.size.width)
        let scaleFactor = scaledToWidth / oldWidth
        let newHeight = CGFloat(sourceImage.size.height) * scaleFactor
        return newHeight
    }
    
    
    @objc func backPresssed(_ sender: UIButton) {
    
        let viewHome = HomeScreen()
        let presenter = HomePresenter(view: viewHome)
        viewHome.present = presenter
        

        
        navigationController?.popViewController(animated: true)
        viewHome.photos = DatabaseService().files(for: "")
        print("After pop")
    }
    
    @objc func sharePresssed(_ sender: UIButton) {
        
        let image = image
        let imageShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func applyFilter(_ at: Int, type: Int, value: Float) {

        let filter = FiltterType.allName[at][type]
//        let effectName = filter.effectName
//        let inputKey = filter.inputKey
        
        if effects.contains(where: { (key: FiltterType, valuse: Float) in
            if key == filter {
                
                return true
            } else {
                return false
            }
        }) {
            effects.removeValue(forKey: filter)
            print("has Value")
            effects.updateValue(value, forKey: filter)
            
        } else {
            print("Has not")
            effects.updateValue(value, forKey: filter)
        }
        
        for (key, values) in effects {
            currentFilter = CIFilter(name: key.effectName)
            currentFilter.setValue(originalImage, forKey: kCIInputImageKey)
            currentFilter.setValue(values, forKey: key.inputKey)
        }
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: (originalImage?.extent)!), forKey: "inputRectangle")

        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        image = processedImage
        
//replace yourimage with the name of your image
        
//        currentFilter = CIFilter(name: effectName)
//        currentFilter.setValue(originalImage, forKey: kCIInputImageKey)
//        currentFilter.setValue(value, forKey: inputKey)
//
//        let cropFilter = CIFilter(name: "CICrop")
//        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
//        cropFilter!.setValue(CIVector(cgRect: (originalImage?.extent)!), forKey: "inputRectangle")
//
//        let output = cropFilter!.outputImage
//        let cgimg = context.createCGImage(output!, from: output!.extent)
//        let processedImage = UIImage(cgImage: cgimg!)
//        image = processedImage
    }
    
    func saveImage() {
        DatabaseService().saveImageToDocumentDirectory(image: image!, filemame: imageName)
    }
}

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
        // Drag to top will be minus value and vice versa
//        print("Pan gesture y offset: \(translation.y)")
        
        // Get drag direction
        let isDraggingDown = translation.y > 0
//        print("Dragging direction: \(isDraggingDown ? "going down" : "going up")")
        
        // New height is based on value of dragging plus current container height
        let newHeight = currentContainerHeight - translation.y
        
        // Handle based on gesture state
        switch gesture.state {
        case .changed:
            // This state will occur when user is dragging
            if newHeight < maximumContainerHeight {
                // Keep updating the height constraint
                containerViewHeightConstraint?.constant = newHeight
                // refresh layout
                view.layoutIfNeeded()
            }
        case .ended:
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
            self.containerViewHeightConstraint?.constant = height
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
            self.containerViewBottomConstraint?.constant = 0
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }

}
