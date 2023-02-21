//
//  AddTextToolModel.swift
//  Magic
//
//  Created by Devel on 27.12.2022.
//

import Foundation

struct AddTextFont: Decodable {
    let name:  String
}

struct AddTextFonts: Decodable {
    let fonts: [AddTextFont]
}
