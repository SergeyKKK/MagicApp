//
//  EditScreen.swift
//  Magic
//
//  Created by Nodir on 04/11/22.
//

import UIKit
import SnapKit

final class EditScreen: UIViewController {
    
    var imageName: String = ""
    var imgSize = CGSize(width: 1, height: 1)
    var image: UIImage? {
        didSet {
            guard let image = image,
                  image.size.width > 0 &&
                    image.size.height > 0 else {
                return
            }
            imageView.image = image
            imgSize = image.size
            setupImageViewConstraints()
            setupCropRectangle()
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
    
    let defaultConfirmationImage = "checkmark"
    lazy var confirmButton: UIButton = {
        var btn = UIButton()
        let btnImg = UIImage(systemName: defaultConfirmationImage)?
            .withTintColor(.black, renderingMode: .alwaysOriginal)
        btn.setImage(btnImg, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(confirmPresssed(_:)), for: .touchUpInside)
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
        img.layer.zPosition = -1
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    lazy var cropRectangle = SelectAreaView()
    
    // Constants
    let defaultHeight:          CGFloat = 400
    let dismissibleHeight:      CGFloat = 200
    let maximumContainerHeight: CGFloat = 400
    let minimumContainerHeight: CGFloat = 150
    
    // Transform view
    var beginPoint:               CGPoint? = nil
    var transformViewBeginFrame:  CGRect?  = nil
    var transformViewIsChanging = false
    var transformingView:         UIView? = nil
    
    // keep current new height, initial is default height
    var currentContainerHeight: CGFloat = 350
    var containerViewIsChanging = false
    
    // Dynamic container constraint
    var containerViewHeightConstraint: Constraint?
    var containerViewBottomConstraint: Constraint?
    
    // images
    var originalImage: CIImage!
    var output: CIImage!
    // crop
    var croppedImage:  CIImage!
    var selectedSize: CropSizes? {
        didSet {
            if selectedSize == nil {
                let btnImg = UIImage(systemName: defaultConfirmationImage)? //scissors
                    .withTintColor(.black, renderingMode: .alwaysOriginal)
                confirmButton.setImage(btnImg, for: .normal)
            } else {
                let btnImg = UIImage(systemName: "scissors")?
                    .withTintColor(.black, renderingMode: .alwaysOriginal)
                confirmButton.setImage(btnImg, for: .normal)
            }
        }
    }
    var cropArea: CGRect?
    // stickers
    var stickers = [StickerView]()
    var isEditingStickers = false {
        didSet {
            if selectedSize == nil && !isEditingTexts {
                confirmButton.isHidden = !isEditingStickers
            }
            imageView.isUserInteractionEnabled = isEditingStickers || isEditingTexts
        }
    }
    // add text
    var addTexts = [AddTextView]()
    var isEditingTexts = false {
        didSet {
            if selectedSize == nil && !isEditingStickers {
                confirmButton.isHidden = !isEditingTexts
            }
            imageView.isUserInteractionEnabled = isEditingStickers || isEditingTexts
            setupAddText()
        }
    }
    var addText:      String? = nil
    var selectedFont: String? = nil {
        didSet {
            isEditingTexts = selectedFont == nil ? false : true
        }
    }
    // color correction
    var inputCurves = InputCurves.defaultValues {
        didSet {
            let filterType = FiltterType.CIColorCurves
            let at = FiltterType.allName.firstIndex { filterArray in
                filterArray.contains(filterType)
            }
            let value = NSData(bytes: &inputCurves, length:MemoryLayout<InputCurves>.size) as Data
            applyFilter(at, type: 0, value: value)
        }
    }
    // filters
    var currentFilter: CIFilter!
    var effects: [FiltterType: Any] = [:]
    let effectView = EditingToolsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        setupConfirmButton ()
        // Add action
        setupPanGesture()
        effectView.sliderDelegate      = self
        effectView.cropToolDelegate    = self
        effectView.stickerToolDelegate = self
        effectView.addTextToolDelegate = self
        effectView.cCToolDelegate      = self
        originalImage = CIImage(image: image!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePresentContainer()
    }
    
    func setupSticker (sticker: Sticker?) {
        guard let sticker else {
            isEditingStickers = false
            stickers.forEach { view in
                view.removeFromSuperview()
            }
            stickers = []
            return
        }
        isEditingStickers = true
        guard let image = UIImage(named: sticker.name) else {
            print("setupSticker: no image with name \(sticker.name)")
            return
        }
        let stickerView = StickerView()
        stickerView.setup(image: image)
        moveViewToRect(view: stickerView)
        stickers.append(stickerView)
    }
    
    func setupAddText () {
        guard isEditingTexts else {
            addTexts.forEach { view in
                view.removeFromSuperview()
            }
            addTexts = []
            return
        }
        let addTextView = AddTextView()
        addTextView.setup(fontName: selectedFont ?? "", text: "", color: .black)
        addTextView.delegate = self
        moveViewToRect(view: addTextView)
        addTexts.append(addTextView)
        showTextRedactor(object: addTextView)
    }
    
    func setupViews() {
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
        view.addSubview(effectView)
        view.addSubview(backButton)
        view.addSubview(shareButton)
        setupContainerConstraints()
    }
    
    @objc
    func backPresssed(_ sender: UIButton) {
        let viewHome = HomeScreen()
        let presenter = HomePresenter(view: viewHome)
        viewHome.present = presenter
        navigationController?.popViewController(animated: true)
        viewHome.photos = DatabaseService().files(for: "")
        print("After pop")
    }
    
    @objc
    func confirmPresssed(_ sender: UIButton) {
        if selectedSize != nil {
            cropImage()
            return
        }
        let imViews: [ImageViewProtocol] = isEditingStickers ? stickers : addTexts
        confirmAction(imViews: imViews)
    }
    
    @objc
    func sharePresssed(_ sender: UIButton) {
        let image = image
        let imageShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func getCurrentScale () -> CGFloat {
        guard let width = image?.size.width,
              let height = image?.size.height else {
            return 1
        }
        let imageRatio = imageView.bounds.width / imageView.bounds.height
        let imageViewRatio = width / height
        
        let scale: CGFloat
        if imageRatio > imageViewRatio {
            scale = height / imageView.bounds.height
        } else {
            scale = width / imageView.bounds.width
        }
        return scale
    }
    
    private func cropImage () {
        guard let width = image?.size.width,
              let height = image?.size.height else {
            return
        }
        let rect = cropRectangle.frame
        let scale = getCurrentScale()
        let size = CGSize(width: rect.width*scale, height: rect.height*scale)
        let origin = CGPoint(x: width  / 2 - (imageView.bounds.midX - rect.minX) * scale,
                             y: height / 2 - (imageView.bounds.midY - rect.minY) * scale)
        cropArea = CGRect(origin: origin, size: size)
        applyFilter()
    }
    
    private func confirmAction (imViews: [ImageViewProtocol]) {
        guard !imViews.isEmpty else {
            return
        }
        let scale = getCurrentScale()
        if let image {
            self.image = image.buildImage(imViews: imViews, scale: scale)
        }
        if let croppedImage {
            var image = UIImage(ciImage: croppedImage)
            image = image.buildImage(imViews: imViews, scale: scale)
            self.croppedImage = CIImage(image: image)
        } else if let image {
            self.originalImage = CIImage(image: image)
        }
        setupSticker(sticker: nil)  // remove stickers
        isEditingTexts = false
    }
    
    private func setupConfirmButton () {
        navigationItem.titleView = confirmButton
        confirmButton.isHidden = true
        confirmButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
    }
}



