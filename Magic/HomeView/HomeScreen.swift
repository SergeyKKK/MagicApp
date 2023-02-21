//
//  ViewController.swift
//  Magic
//
//  Created by Nodir on 02/11/22.
//

import UIKit
import StoreKit
import SnapKit

protocol ViewUpdate {
    func onRetrieveData(_ model: [ImageData])
    func didFailWithError(error: Error)
}

class HomeScreen: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    
    enum Product: String, CaseIterable{
        // You can add other cases for in-app purchase
        case weaklySubscription = "com.temporary.weakly"
    }
    let layout = HomeCollectionLayout()
    var photos: [ImageData] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var present: HomePresenter!
    
    lazy var collectionView: UICollectionView = {
        var clView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        clView.backgroundColor = .clear
        clView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        clView.translatesAutoresizingMaskIntoConstraints = false
        clView.showsVerticalScrollIndicator = false
        return clView
    }()
  
  private lazy var firstImageView = UIImageView()
    
    
    //MARK: Create Rate App Alert after 30 seconds before loading app
    func createPromptAlert() {
        _ = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(alertRateUs(_:)), userInfo: nil, repeats: false)
    }
    
    @objc
    func alertRateUs(_ sender: UIButton) {
        guard let scene = view.window?.windowScene else {
            print("no scene")
            return
        }
        SKStoreReviewController.requestReview(in: scene)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.layout.delegate = self
        setupConstrains()
        present.viewDidLoad()
        createPromptAlert()
      
      setupFirstImageView(firstImageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //TODO: Need to optimise when comes back from Edit
        present.viewDidLoad()
    }
    
    var buttonPurch: UIButton = {
        var btn = UIButton(frame: CGRect(x: 600, y: 600, width: 200, height: 60))
        btn.backgroundColor = .orange
        btn.titleLabel?.text = "Puchase"
        return btn
    }()
    
    func setupConstrains() {
        view.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)

        let leftBarButton = UIBarButtonItem()
        
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40),
            collectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 65),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,  constant: -10)
        ])
    }
  
  private func setupFirstImageView(_ imageView: UIImageView) {
    imageView.image = UIImage(named: "onvoardImage")
    view.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.center.equalToSuperview()
      make.height.equalToSuperview().dividedBy(1.5)
    }
  }
    
    // MARK: In-App purchase
    
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
    
    func weaklySuns() {
        if SKPaymentQueue.canMakePayments(){
            let set: Set<String> = [Product.weaklySubscription.rawValue]
            
            let productRequest = SKProductsRequest(productIdentifiers: set)
            productRequest.delegate = self
            productRequest.start()
        }
    }
    
    func purchase(aproduct: SKProduct){
        let payment = SKPayment(product: aproduct)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
    

}

extension HomeScreen : UICollectionViewDataSource, UICollectionViewDelegate  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
        
        cell.applyButton.tag = indexPath.row
        cell.image.image = photos[indexPath.row].image
        cell.applyButton.addTarget(self, action: #selector(applyPressed(_:)), for: .touchUpInside)
        
        return cell
        
    }
    
    @objc func applyPressed(_ sender: UIButton) {
        let newViewController = EditScreen()
        newViewController.image = photos[sender.tag].image
        newViewController.imageName = photos[sender.tag].imageName
        newViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
}

extension HomeScreen: HomeCollectionLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        
        let imgHeight = calculateImageHeight(sourceImage: photos[indexPath.row].image , scaledToWidth: cellWidth)
        return (imgHeight + 55)
        
    }
    
    func calculateImageHeight(sourceImage: UIImage, scaledToWidth: CGFloat) -> CGFloat {
        let oldWidth = CGFloat(sourceImage.size.width)
        let scaleFactor = scaledToWidth / oldWidth
        let newHeight = CGFloat(sourceImage.size.height) * scaleFactor
        return newHeight
    }
    
}

extension HomeScreen: ViewUpdate {
    func onRetrieveData(_ model: [ImageData]) {
        self.photos = model
      self.firstImageView.isHidden = !model.isEmpty
        self.collectionView.reloadData()
    }
    
    func didFailWithError(error: Error) {
        print("Failed with error: ", error)
    }
    
    
}
