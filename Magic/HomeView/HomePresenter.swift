//
//  HomePresenter.swift
//  Magic
//
//  Created by Nodir on 08/11/22.
//

import UIKit

protocol HomeViewPresenter: AnyObject {
    init(view: ViewUpdate)
    func viewDidLoad()
    
}

class HomePresenter: HomeViewPresenter {
    
    private let dataService = DatabaseService()
    var view: ViewUpdate?
    
    required init(view: ViewUpdate) {
        self.view = view
    }
    
    func viewDidLoad() {
        dataService.retrievePhotos(callback: view!.onRetrieveData(_:))
    }

}
