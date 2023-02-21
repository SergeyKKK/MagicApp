//
//  Helpers.swift
//  Magic
//
//  Created by Nodir on 02/11/22.
//

import Foundation

protocol controlOnboardDelegate {
    func updatePageControl(index : Int)
    
}
class Helper {
    var page : Int = 0
    static let shared = Helper()
    private init(){}
    var onboardDelegate : controlOnboardDelegate?
    
    func updateOnboardUI(index : Int){
        self.onboardDelegate?.updatePageControl(index: index)
    }
}
