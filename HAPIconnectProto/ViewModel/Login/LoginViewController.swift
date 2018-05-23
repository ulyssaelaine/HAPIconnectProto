//
//  LoginViewController.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/10/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate
{
    // MARK: - IBOutlet
    
    @IBOutlet var emailTextField        : UITextField!
    @IBOutlet var passwordTextField     : UITextField!
    @IBOutlet var ai_loader             : UIActivityIndicatorView!
    
    // MARK: - Variables
    
    //var loginPresenter                  : LoginPresenter?
    var manager : WebServiceManager     = WebServiceManager()
    
    // MARK: - View Management
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //self.loginPresenter = LoginPresenter(delegate: self)
        
        self.hideAILoader()
        
        /* Gesture Recognizer */
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Actions
    
    @IBAction func loginButtonTapped(_ sender: UIButton)
    {
        //self.loginPresenter?.login(name: emailTextField.text!, password: passwordTextField.text!)
        
        self.loginAPI()
        
        self.showAILoader()
    }
    
    // MARK: - Show UIAlert
    
    func showAlert(title : String, message : String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction        = UIAlertAction(title: "OK", style: .cancel, handler: { action in
            
            if title == "Login Successful!"
            {
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                
                self.dismiss(animated: true, completion: nil)
            }
            
        })
        
        alertController.addAction(okAction)
        
        DispatchQueue.main.async
            {
                self.present(alertController, animated: true, completion:{})
        }
    }
    
    // MARK: - Show / Hide AI Loader
    
    func showAILoader()
    {
        ai_loader.isHidden = false
        ai_loader.startAnimating()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func hideAILoader()
    {
        ai_loader.isHidden = true
        ai_loader.stopAnimating()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    // MARK: - Tap Gesture
    
    @objc func tapGestureHandler()
    {
        view.endEditing(true)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if string == "\n"
        {
            textField.resignFirstResponder()
            
            return false
        }
        
        return true
    }
}

// MARK: - Extension - WebServiceManagerDelegate

extension LoginViewController : WebServiceManagerDelegate
{
    func loginAPI()
    {
        manager.delegate = self
        manager.loginwithLoginName(loginName: emailTextField.text!, password: passwordTextField.text!, app: "hapiconnect", carrier: "hapiconnect", loginType: 1, clientId: String().UUIDString())
    }
    
    func downloadAPI()
    {
        manager.delegate = self
        manager.downloadSync()
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, loginUserSuccess success : NSString)
    {
        self.downloadAPI()
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, loginUserFailed error: NSString)
    {
        self.hideAILoader()
        
        self.showAlert(title: "Login Failed!", message: error as String)
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, logoutUserSuccess success : NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, logoutUserFailed error: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, downloadPathFromServerSuccess success : NSString)
    {
        self.hideAILoader()
        
        self.showAlert(title: "Login Successful!", message: "")
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, downloadPathFromServerFailed error: NSString)
    {
        self.hideAILoader()
        
        self.showAlert(title: "Login Failed!", message: "")
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, addDeviceSuccess success: NSString, protocolType: String)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, addDeviceFailed error: NSString, protocolType: String)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, bindDeviceSuccess success: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, bindDeviceFailed error: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, unbindDeviceSuccess success: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, unbindDeviceFailed error: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, savePedometerStepsSuccess success: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, savePedometerStepsFailed error: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, deletePedometerStepsSuccess success: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, deletePedometerStepsFailed error: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, saveWeightSuccess success : NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, saveWeightFailed error: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, deleteWeightSuccess success : NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, deleteWeightFailed error: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, saveBloodPressureRecordSuccess success: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, saveBloodPressureRecordFailed error: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, deleteBloodPressureRecordSuccess success: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, deleteBloodPressureRecordFailed error: NSString)
    {
        
    }
}

// MARK: - Extension - Unit Testing

extension LoginViewController : LoginPresenterDelegate
{
    func showProgress()
    {
        
    }
    
    func hideProgress()
    {
        
    }
    
    func loginDidSucceed()
    {
        print("Successful")
    }
    
    func loginDidFail(message: String)
    {
        print("message")
    }
}
