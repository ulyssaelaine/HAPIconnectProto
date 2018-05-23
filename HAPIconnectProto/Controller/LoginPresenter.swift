//
//  LoginPresenter.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/11/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

protocol LoginPresenterDelegate
{
    func showProgress()
    func hideProgress()
    func loginDidSucceed()
    func loginDidFail(message : String)
}

class LoginPresenter
{
    // MARK: - Variable
    
    var delegate : LoginPresenterDelegate
    
    init(delegate : LoginPresenterDelegate)
    {
        self.delegate = delegate
    }
    
    func login(name: String, password: String)
    {
        if name.isEmpty
        {
            print("Failed")
            self.delegate.loginDidFail(message: "E-mail can't be blank")
        }
    }
}
