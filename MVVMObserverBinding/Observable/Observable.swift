//
//  Observable.swift
//  MVVMBindings
//
//  Created by Umair on 21/08/2021.
//

import Foundation

class Observable<T> {
    var value :T? {
        didSet{
            listener?(value)
        }
    }
    
    init(_ value : T?) {
        self.value = value
    }
    
    private var listener : ((T?) -> ())?
    
    func bind(_ listener: @escaping (T?) -> ()) {
        listener(value)
        self.listener = listener
    }
}
