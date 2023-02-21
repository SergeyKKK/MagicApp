//
//  StickersToolModel.swift
//  Magic
//
//  Created by Devel on 22.12.2022.
//

import UIKit

struct Sticker: Decodable {
    let name:  String
    let group: String
    let order: Int
}

struct Stickers: Decodable {
    let stickers: [Sticker]   
}
