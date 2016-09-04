//
//  CreatePasswordViewModel.swift
//  RxSwiftExample
//
//  Created by Justine Kay on 8/28/16.
//  Copyright © 2016 Justine Kay. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class CreatePasswordViewModel: NSObject {
    
    let password = Variable("")
    let passwordConfirmation = Variable("")
    var passwordIsMinLength = Variable(false)
    var passwordMinCheckmarkHidden = Variable(true)
    
    let passwordMinLength = 8
    let disposeBag = DisposeBag()
    
    var passwordsMatchObservable: Observable<Bool>? = nil
    
    override init() {
        super.init()
        
        passwordsMatchObservable = Observable.combineLatest(password.asObservable(), passwordConfirmation.asObservable()) { $0 == $1 }
        
        password.asObservable().subscribeNext() { password in
            self.passwordIsMinLength.value = password.characters.count >= self.passwordMinLength
            }
            .addDisposableTo(disposeBag)
        
        password.asObservable().subscribeNext() { password in
            self.passwordMinCheckmarkHidden.value = password.characters.count < self.passwordMinLength
            }
            .addDisposableTo(disposeBag)
    }
}
