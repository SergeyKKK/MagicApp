//
//  ImageScreeen.swift
//  Magic
//
//  Created by Nodir on 10/11/22.
//

import UIKit
import StoreKit
import Purchases

class SettingScreeen: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    enum Product: String, CaseIterable{

        case weaklySubscription = "com.temporary.weakly"
    }
    
    lazy var effectName: UILabel = {
        var lbl = UILabel()
        lbl.font = UIFont(name: "Poppins-Bold", size: 14)
        lbl.numberOfLines = 1
        lbl.text = "Settings"
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: 353, height: 199), style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 5
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(SettingTableCell.self, forCellReuseIdentifier: "cell")
        tableView.register(SettingHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let section = ["General"]
    let tableCell = [["VIP", "Privacy Policy", "Terms of Service", "Restore purchase"]]
    let tableImages = ["crown", "privacy", "terms", "purchase"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.hidesBarsOnSwipe = true
        view.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)
        
        setupUI()
        
    }
    
    func setupUI() {
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
        ])
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let oProduct = response.products.first{
            print("Product is available")
            self.purchase(aproduct: oProduct)
        } else{
            print("Product is not available")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState{
            case .purchasing:
                print("Customer is in the process of purchase")
            case .purchased:
                SKPaymentQueue.default() .finishTransaction (transaction)
                print("purchased" )
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                print("failed" )
            case .restored:
                print("restore")
            case .deferred:
                print("deferred" )
            default: break
            }
        }
    }
    
    func purchase(aproduct: SKProduct){
        let payment = SKPayment(product: aproduct)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
    
    
    /// OTHER VARIANT
    
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
}

extension SettingScreeen: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return section.count
    }
    
    //MARK: Header funcs
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! SettingHeader
        headerView.sectionTitle.text = self.section[section]
        headerView.sectionTitle.font = UIFont(name: "Poppins-SemiBold", size: 22)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    //MARK:- Cell funcs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableCell[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingTableCell
        cell.cellName.text = tableCell[0][indexPath.row]
        cell.icon.image = UIImage(named: tableImages[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // VIP
        if indexPath.row == 0 {
            let newViewController = PaywallView()
            Purchases.shared.purchaserInfo { [weak self] info, error in
                guard let info = info, error == nil else { return }
                
                print(info.entitlements)
                // Проверка на наличие подписки
                if info.entitlements.all["Weakly"]?.isActive == true {
                    self!.fetchPackage { [weak self] package in
                        self?.purchases(package: package)
                    }
                } else{
                    DispatchQueue.main.async {
                        // Если подписки нет, вызывает пейфолл с оплатой
                            newViewController.modalTransitionStyle = .coverVertical
                            newViewController.modalPresentationStyle = .fullScreen
                            self!.present(newViewController, animated: true)
                    }
                }
            }
        } else {
            print("Eror purchases")
        }
        
        // PRIVACY POLICY
        if indexPath.row == 1 {
            let url = URL(string: "https://cutt.ly/W0ol4hW")!
            if #available(iOS 10.0, *) {
                
                UIApplication.shared.open(url, options: [ : ] , completionHandler: nil)
                
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        // TERMS OF SERVICE 
        if indexPath.row == 2 {
            let url = URL(string: "https://cutt.ly/D0ozslI")!
            if #available(iOS 10.0, *) {
                
                UIApplication.shared.open(url, options: [ : ] , completionHandler: nil)
                
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
        if indexPath.row == 3 {
            fetchPackage { [weak self] package in
                self?.purchases(package: package)
            }
        }
    }
    
}
