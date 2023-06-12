//
//  RegistertionDetail.swift
//  CoGuard
//
//  Created by عمرو on 19.05.2023.
//

import UIKit

protocol UserDetail {
    var id: Int {get}
    var title: String {get}
    var img: UIImage? {get}
    var dataType: TextFieldEntryDataType {get}
    var options: [String]? {get}
}
