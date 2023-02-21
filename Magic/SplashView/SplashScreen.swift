//
//  SplashScreen.swift
//  Magic
//
//  Created by Nodir on 02/11/22.
//

import UIKit
import SnapKit

//MARK: - controlOnboardDelegate
extension SplashScreen : controlOnboardDelegate{
    func updatePageControl(index: Int) {
        pageControl.currentPage = index
        
    }
}
class SplashScreen: UIViewController {
//  MARK:- UI declaration

    lazy var startButton: UIButton = {
        var btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "StartButton"), for: .normal)
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(startPressed(_:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var contentPage: UIView = {
        var vc = UIView()
        vc.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    lazy var pageControl: UIPageControl = {
        var pgc = UIPageControl()
        pgc.currentPage = 0
        pgc.numberOfPages = 3
        pgc.addBorderLeft(size: 1, color: .green)
        pgc.currentPageIndicatorTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        pgc.pageIndicatorTintColor = #colorLiteral(red: 0.5764705882, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
        pgc.translatesAutoresizingMaskIntoConstraints = false
                        
        return pgc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        Helper.shared.onboardDelegate = self
    }
    
    func setupUI() {
        
        self.view.addSubview(contentPage)
        self.view.addSubview(pageControl)
        self.view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            
//            contentPage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            contentPage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            contentPage.widthAnchor.constraint(equalTo: view.widthAnchor),
//            contentPage.heightAnchor.constraint(equalTo: view.heightAnchor),

            
//            startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            startButton.widthAnchor.constraint(equalToConstant: 364),
//            startButton.heightAnchor.constraint(equalToConstant: 64),
//            startButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 30),
            
//            pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            pageControl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 700),
        ])
        contentPage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(364)
            make.height.equalTo(64)
            make.top.equalTo(contentPage.snp.bottom).inset(100)
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentPage.snp.bottom).inset(130)
        }
        
        let controller = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        contentPage.addSubview(controller.view)
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: contentPage.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: contentPage.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: contentPage.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: contentPage.bottomAnchor)
        ])

        controller.didMove(toParent: self)
    }
    
    @objc func startPressed(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "LaunchedBefore")
        
        let newViewController = PaywallView()
        newViewController.modalTransitionStyle = .coverVertical
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true)
    }

}
