//
//  PaywallView.swift
//  Magic
//
//  Created by Руслан Трищенков on 14.12.2022.
//

import UIKit
import Purchases
import ImageIO
import SnapKit

class PaywallView: UIViewController {
    
    enum Product: String, CaseIterable{
     
        case weaklySubscription = "com.temporary.weakly"
    }
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        button.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(closePressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var animationImage: UIImageView = {
        let image = UIImageView()
        image.loadGif(name: "gif")
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    
    
    lazy var titleAfterImage: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.text = "Get exclusive access to premium features"
        label.font = UIFont(name: "Poppins-Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var subscriptionButton: UIButton = {
      let button = UIButton()
        button.setTitle("Weekly 4,99 US$", for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.024, green: 0.698, blue: 0.651, alpha: 1).cgColor
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 14)
        button.addTarget(self, action: #selector(subscriptionButtonTouched(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
      return button
    }()
    
    lazy var useTrialLabel: UILabel = {
        let label = UILabel()
        label.text = "Use Free Trial."
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        
        return label
    }()
    
    lazy var switcher: UISwitch = {
       let switcher = UISwitch()
        switcher.isOn = false
        switcher.translatesAutoresizingMaskIntoConstraints = false
        switcher.isHidden = true
        return switcher
    }()
    
    lazy var continueButton: UIButton = {
       let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(red: 0.024, green: 0.698, blue: 0.651, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 14)
        button.addTarget(self, action: #selector(closePressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
       return button
    }()
    
    lazy var labelAboutSubscription: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 3
        label.textColor = UIColor(red: 0.533, green: 0.533, blue: 0.533, alpha: 1)
        label.text = "Renews automatically. Cancel at least 24 hours prior to your renewal date."
        label.font = UIFont(name: "Poppins-Regular", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        
       return label
    }()
    
    lazy var termOfUsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 0.533, green: 0.533, blue: 0.533, alpha: 1), for: .normal)
        button.setTitle("Terms of Use", for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 11)
        button.addTarget(self, action: #selector(termOfUsButtonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
       return button
    }()
    
    lazy var privacyPolicyButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 0.533, green: 0.533, blue: 0.533, alpha: 1), for: .normal)
        button.setTitle("Privacy Policy", for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 11)
        button.addTarget(self, action: #selector(privacyPolicyButtonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
       return button
    }()
    
    lazy var restoreButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 0.533, green: 0.533, blue: 0.533, alpha: 1), for: .normal)
        button.setTitle("Restore", for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 11)
        button.addTarget(self, action: #selector(subscriptionButtonTouched(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
       return button
    }()
    
    lazy var freeTriallabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "3 days free trial"
        label.numberOfLines = 0
        label.font = UIFont(name: "Poppins-Medium", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setConstraints()
        
        setUp()
    }
    
    func setConstraints() {
        self.view.addSubview(closeButton)
        self.view.addSubview(animationImage)
        self.view.addSubview(titleAfterImage)
        self.view.addSubview(subscriptionButton)
        self.view.addSubview(freeTriallabel)
        self.view.addSubview(useTrialLabel)
        self.view.addSubview(switcher)
        self.view.addSubview(continueButton)
        self.view.addSubview(labelAboutSubscription)
        self.view.addSubview(termOfUsButton)
        self.view.addSubview(privacyPolicyButton)
        self.view.addSubview(restoreButton)
        
        
        NSLayoutConstraint.activate([
            
//            closeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 23),
//            closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 62),
            
//            animationImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            animationImage.topAnchor.constraint(equalTo: closeButton.topAnchor, constant: 80),
//            animationImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            animationImage.widthAnchor.constraint(equalToConstant: 420),
//            animationImage.heightAnchor.constraint(equalToConstant: 230),
            
//            titleAfterImage.topAnchor.constraint(equalTo: animationImage.bottomAnchor, constant: 48),
//            titleAfterImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
//            subscriptionButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            subscriptionButton.topAnchor.constraint(equalTo: titleAfterImage.bottomAnchor, constant: 34),
//            subscriptionButton.widthAnchor.constraint(equalToConstant: 309),
//            subscriptionButton.heightAnchor.constraint(equalToConstant: 53),
            
//            useTrialLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
//            useTrialLabel.topAnchor.constraint(equalTo: subscriptionButton.bottomAnchor, constant: 56),
            
//            switcher.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
//            switcher.topAnchor.constraint(equalTo: subscriptionButton.bottomAnchor, constant: 56),
            
//            continueButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            continueButton.topAnchor.constraint(equalTo: subscriptionButton.bottomAnchor, constant: 100),
//            continueButton.widthAnchor.constraint(equalToConstant: 309),
//            continueButton.heightAnchor.constraint(equalToConstant: 53),
            
//            labelAboutSubscription.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            labelAboutSubscription.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 45),
//            labelAboutSubscription.heightAnchor.constraint(equalToConstant: 55),
//            labelAboutSubscription.widthAnchor.constraint(equalToConstant: self.view.frame.width - 30),
            
//            termOfUsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -89),
//            termOfUsButton.topAnchor.constraint(equalTo: labelAboutSubscription.bottomAnchor, constant: 28),
            
//            privacyPolicyButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            privacyPolicyButton.topAnchor.constraint(equalTo: labelAboutSubscription.bottomAnchor, constant: 28),
//
//            restoreButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 89),
//            restoreButton.topAnchor.constraint(equalTo: labelAboutSubscription.bottomAnchor, constant: 28),
            
            ])
        
        closeButton.snp.makeConstraints { make in
            make.left.equalTo(23)
            make.top.equalTo(45)
        }
        
        animationImage.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(closeButton.snp.top).inset(60)
            make.centerX.equalToSuperview()
            make.height.equalTo(230)
        }
        
        titleAfterImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(animationImage.snp.top).inset(260)
        }
        
        subscriptionButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleAfterImage.snp.top).inset(34)
            make.width.equalTo(309)
            make.height.equalTo(53)
        }
        
        freeTriallabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(subscriptionButton.snp.top).inset(85)
        }
        
        useTrialLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(30)
            make.top.equalTo(freeTriallabel.snp.top).inset(35)
        }
        
        switcher.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(30)
            make.top.equalTo(freeTriallabel.snp.top).inset(30)
        }
        
        continueButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(subscriptionButton.snp.top).inset(140)
            make.width.equalTo(309)
            make.height.equalTo(53)
        }
        
        labelAboutSubscription.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(privacyPolicyButton.snp.bottom).inset(20)
            make.height.equalTo(55)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        
        termOfUsButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(60)
            make.bottom.equalTo(-10)
        }
        
        privacyPolicyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-10)
        }
        
        restoreButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(89)
            make.bottom.equalTo(-10)
        }
    }
    
    @objc func subscriptionButtonTouched(_ sender: UIButton) {
        fetchPackage { [weak self] package in
            self?.purchases(package: package)
        }
    }
    
    @objc func closePressed(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "LaunchedBefore")
        let newViewController = TabBarScreen()
        newViewController.modalTransitionStyle = .coverVertical
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @objc func termOfUsButtonPressed(_ sender: UIButton) {
        let url = URL(string: "https://cutt.ly/D0ozslI")!
        if #available(iOS 10.0, *) {
            
        UIApplication.shared.open(url, options: [ : ] , completionHandler: nil)

        } else {
        UIApplication.shared.openURL(url)
        }
    }
    
    @objc func privacyPolicyButtonPressed(_ sender: UIButton) {
        let url = URL(string: "https://cutt.ly/W0ol4hW")!
        if #available(iOS 10.0, *) {
            
        UIApplication.shared.open(url, options: [ : ] , completionHandler: nil)

        } else {
        UIApplication.shared.openURL(url)
        }
    }
    
    func purchases(package: Purchases.Package){
        Purchases.shared.purchasePackage(package) { transaction, info, error, userCancelled in
            guard let transaction = transaction,
                  let info = info, error == nil, !userCancelled else {
                return
            }
            print(transaction.transactionState)
            print(info.entitlements)
        }
    }
    
    func restorePurchases() {
        Purchases.shared.restoreTransactions() { info, error in
            guard let info = info, error == nil else {return}
            
        }
    }
    
    func fetchPackage(completion: @escaping (Purchases.Package) -> Void) {
        Purchases.shared.offerings { offerings, error in
            guard let offerings = offerings, error == nil else { return }
            
            guard let package = offerings.all.first?.value.availablePackages.first else {return}
            completion(package)
        }
    }
    
    func setUp() {
        Purchases.shared.purchaserInfo { [weak self] info, error in
            guard let info = info, error == nil else { return }
            
            print(info.entitlements)
            if info.entitlements.all["Weakly"]?.isActive == true {
                self?.subscriptionButton.isHidden = true
            } else{
                DispatchQueue.main.async {
                    self?.subscriptionButton.isHidden = false
                }
            }
        }
    }
}
