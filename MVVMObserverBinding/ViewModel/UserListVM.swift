//
//  UserListVM.swift
//  MVVMBindings
//
//  Created by Umair on 21/08/2021.
//

import Foundation

struct UserListVM {
    var users : Observable<[UserTVCellVM]> = Observable([])
}
