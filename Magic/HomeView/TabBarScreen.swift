//
//  TabBarScreen.swift
//  Magic
//
//  Created by Nodir on 02/11/22.
//

import UIKit
import Purchases

class TabBarScreen: UITabBarController, UITabBarControllerDelegate {
    
    enum Product: String, CaseIterable{
     
        case weaklySubscription = "com.temporary.weakly"
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
    
    func fetchPackage(completion: @escaping (Purchases.Package) -> Void) {
        Purchases.shared.offerings { offerings, error in
            guard let offerings = offerings, error == nil else { return }
            
            guard let package = offerings.all.first?.value.availablePackages.first else {return}
            completion(package)
        }
    }
    
    let viewHome = HomeScreen()
    let viewHome1 = HomeScreen()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let presenter = HomePresenter(view: viewHome)
        viewHome.present = presenter
        
        setupVCs()
        delegate = self
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor(named: "BLUE")!, size: CGSize(width: tabBar.frame.width/CGFloat(20), height:  tabBar.frame.height - 3), lineThickness: 2.0, side: .bottom)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.tintColor = #colorLiteral(red: 0.02352941176, green: 0.6980392157, blue: 0.6509803922, alpha: 1)
        tabBar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        tabBar.isTranslucent = false
        tabBar.clipsToBounds = true
        tabBar.frame.size.height = 105
        tabBar.frame.origin.y = view.frame.height - 106

    }
    
    fileprivate func createNavController(for rootViewController: UIViewController, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = image
        
        navController.navigationBar.clipsToBounds = true
        return navController
    }
    
    
    func setupVCs() {
        viewControllers = [
            createNavController(for: viewHome, image: UIImage(named: "Home")!),
            createNavController(for: ViewController(), image: UIImage(named: "Add")!),
            createNavController(for: SettingScreeen(), image: UIImage(named: "More")!)
        ]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 1 {
            
            //Делаем проверку на то есть ли платеж здесь, иначе ограничиваем весь функционал
            
            Purchases.shared.purchaserInfo { [weak self] info, error in
                guard let info = info, error == nil else { return }
                
                print(info.entitlements)
                // Проверка на наличие подписки
                if info.entitlements.all["Weakly"]?.isActive == true {
                    ImagePickerScreen().pickImage(viewController) { [self] image, fileName  in
                        print("Img: \(image) Name: \(fileName)")
                        DatabaseService().saveImageToDocumentDirectory(image: image, filemame: fileName)
                        self!.viewHome.photos = DatabaseService().files(for: "")
                    }
                } else{
                    DispatchQueue.main.async {
                        // Если подписки нет, вызывает пейфолл с оплатой
                            let newViewController = PaywallView()
                            newViewController.modalTransitionStyle = .coverVertical
                            newViewController.modalPresentationStyle = .fullScreen
                            self!.present(newViewController, animated: true)
                    }
                }
            }
        }
    }
}

enum Side: String {
    case top, left, right, bottom
}

extension UIImage {
    func createSelectionIndicator(color: UIColor, size: CGSize, lineThickness: CGFloat, side: Side) -> UIImage {
        var xPosition = 0.0
        var yPosition = 0.0
        var imgWidth = 2.0
        var imgHeight = 2.0
        switch side {
            case .top:
                xPosition = 0.0
                yPosition = 0.0
                imgWidth = Double(size.width)
                imgHeight = Double(lineThickness)
            case .bottom:
                xPosition = 0.0
                yPosition = Double(size.height - 10)
                imgWidth = Double(size.width)
                imgHeight = Double(lineThickness)
            case .left:
                xPosition = 0.0
                yPosition = 0.0
                imgWidth = Double(lineThickness)
                imgHeight = Double(size.height)
            case .right:
                xPosition = Double(size.width - lineThickness)
                yPosition = 0.0
                imgWidth = Double(lineThickness)
                imgHeight = Double(size.height)
        }
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: xPosition, y: yPosition, width: imgWidth, height: imgHeight))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
