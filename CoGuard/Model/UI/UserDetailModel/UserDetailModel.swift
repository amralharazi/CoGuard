//
//  RegisterationDetail.swift
//  CoGuard
//
//  Created by عمرو on 26.05.2023.
//

import Foundation

struct UserDetailModel {
    var id: Int
    var userDetail: UserDetail
    var value: Any?
    
    init(userDetail: UserDetail, value: Any? = nil) {
        self.id = userDetail.id
        self.userDetail = userDetail
        self.value = value
    }
}
