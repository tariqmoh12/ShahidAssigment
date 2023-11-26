//
//  ImageDetailsModel.swift
//  ShahidAssigment
//
//  Created by Tariq Mohammad on 25/11/2023.
//

import Foundation
import RealmSwift

class ImageDetailsModel: Object, Codable {
    @Persisted var data: ImageModel?
}
