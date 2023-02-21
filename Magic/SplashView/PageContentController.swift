//
//  PageContentController.swift
//  Magic
//
//  Created by Nodir on 28/11/22.
//

import UIKit

class PageContentController: UIViewController {
    
    lazy var imageView: UIImageView = {
        var img = UIImageView()
        img.contentMode = .center
        img.translatesAutoresizingMaskIntoConstraints = false
        
        return img
    }()
    
    lazy var gradientView: UIView = {
        var vc = UIView()
        vc.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        vc.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    lazy var titleScreen: UILabel = {
        var lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Poppins-Bold", size: 48)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    lazy var subtitleSplash: UILabel = {
        var lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Poppins-Regular", size: 24)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    lazy var onboardingImages: UIImageView = {
        var img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    //MARK: - Properties
    var pageIndex: Int = 0
    var strTitle: String!
    var strDesc: String!
    var strColorName: UIColor!
    var image: UIImage!
    var onboadingImage: UIImage!
  

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGradientToView(view: gradientView)
        setupView()
        imageView.image = image
        titleScreen.text = strTitle
        subtitleSplash.text = strDesc
        onboardingImages.image = onboadingImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Helper.shared.updateOnboardUI(index: pageIndex)
    }

    private func setupView() {
        
        self.view.addSubview(imageView)
        self.view.addSubview(gradientView)
        self.view.addSubview(titleScreen)
        self.view.addSubview(subtitleSplash)
        self.view.addSubview(onboardingImages)
        
        NSLayoutConstraint.activate([
            
//            imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
//            imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//            imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
//            titleScreen.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            titleScreen.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
//            titleScreen.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 158),
//            titleScreen.widthAnchor.constraint(equalToConstant: 320),
            
//            subtitleSplash.widthAnchor.constraint(equalToConstant: self.view.frame.width - 50),
//            subtitleSplash.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            subtitleSplash.topAnchor.constraint(equalTo: self.titleScreen.bottomAnchor, constant: 16),
//            
//            onboardingImages.widthAnchor.constraint(equalToConstant: self.view.frame.width),
//            onboardingImages.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
//            onboardingImages.topAnchor.constraint(equalTo: self.subtitleSplash.bottomAnchor, constant: 40),
        ])
        
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        titleScreen.snp.makeConstraints { make in
            make.width.equalTo(self.view.snp.width).inset(-50)
            make.left.equalToSuperview().inset(25)
            make.right.equalToSuperview().inset(25)
            make.top.equalToSuperview().inset(158)
        }
        
        subtitleSplash.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(25)
            make.right.equalToSuperview().inset(25)
            make.height.equalTo(135)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleScreen.snp.top).inset(60)
        }

        onboardingImages.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(180) //180
            make.width.equalTo(self.view.snp.width).inset(300)
            make.centerY.equalToSuperview()
            make.top.equalTo(subtitleSplash).inset(120) //120
        }
    }
    
    private func addGradientToView(view: UIView) {
        //gradient layer
        let gradientLayer = CAGradientLayer()
        
        //define colors
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        
        //define locations of colors as NSNumbers in range from 0.0 to 1.0
        //if locations not provided the colors will spread evenly
        gradientLayer.locations = [0.3, 1]
        
        //define frame
        gradientLayer.frame = view.bounds
        
        //insert the gradient layer to the view layer
        view.layer.insertSublayer(gradientLayer, above: view.layer)
    }
    
}
