//
//  WebServiceManager.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/10/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import UIKit

class WebServiceManager: NSObject
{
    // MARK: - Delegate
    
    var delegate : WebServiceManagerDelegate?
}

// MARK: - WebServiceManagerDelegate

@objc protocol WebServiceManagerDelegate
{
    func WebServiceManagerClient(manager: WebServiceManager, loginUserSuccess success : NSString)
    func WebServiceManagerClient(manager: WebServiceManager, loginUserFailed error: NSString)
    
    func WebServiceManagerClient(manager: WebServiceManager, logoutUserSuccess success : NSString)
    func WebServiceManagerClient(manager: WebServiceManager, logoutUserFailed error: NSString)
    
    func WebServiceManagerClient(manager: WebServiceManager, downloadPathFromServerSuccess success : NSString)
    func WebServiceManagerClient(manager: WebServiceManager, downloadPathFromServerFailed error: NSString)
    
    func WebServiceManagerClient(manager: WebServiceManager, addDeviceSuccess success: NSString, protocolType: String)
    func WebServiceManagerClient(manager: WebServiceManager, addDeviceFailed error: NSString, protocolType: String)
    
    func WebServiceManagerClient(manager: WebServiceManager, bindDeviceSuccess success: NSString)
    func WebServiceManagerClient(manager: WebServiceManager, bindDeviceFailed error: NSString)
    
    func WebServiceManagerClient(manager: WebServiceManager, unbindDeviceSuccess success: NSString)
    func WebServiceManagerClient(manager: WebServiceManager, unbindDeviceFailed error: NSString)
    
    func WebServiceManagerClient(manager: WebServiceManager, savePedometerStepsSuccess success: NSString)
    func WebServiceManagerClient(manager: WebServiceManager, savePedometerStepsFailed error: NSString)
    
    func WebServiceManagerClient(manager: WebServiceManager, deletePedometerStepsSuccess success: NSString)
    func WebServiceManagerClient(manager: WebServiceManager, deletePedometerStepsFailed error: NSString)
    
    func WebServiceManagerClient(manager: WebServiceManager, saveWeightSuccess success : NSString)
    func WebServiceManagerClient(manager: WebServiceManager, saveWeightFailed error: NSString)
    
    func WebServiceManagerClient(manager: WebServiceManager, deleteWeightSuccess success : NSString)
    func WebServiceManagerClient(manager: WebServiceManager, deleteWeightFailed error: NSString)
    
    func WebServiceManagerClient(manager: WebServiceManager, saveBloodPressureRecordSuccess success: NSString)
    func WebServiceManagerClient(manager: WebServiceManager, saveBloodPressureRecordFailed error: NSString)
    
    func WebServiceManagerClient(manager: WebServiceManager, deleteBloodPressureRecordSuccess success: NSString)
    func WebServiceManagerClient(manager: WebServiceManager, deleteBloodPressureRecordFailed error: NSString)
}

// MARK: - WebServiceHTTPClientDelegate

var client : WebServiceHTTPClient = WebServiceHTTPClient()

extension WebServiceManager: WebServiceHTTPClientDelegate
{
    func loginwithLoginName(loginName: String, password: String, app : String, carrier : String, loginType : Int, clientId : String)
    {
        client.delegate = self
        client.loginwithLoginName(loginName: loginName, password: password, app: app, carrier: carrier, loginType: loginType, clientId: clientId)
    }
    
    func logout()
    {
        let sessionId : String = UserDefaults.standard.value(forKey: "sessionId") as! String
        
        client.delegate = self
        client.logout(sessionID: sessionId)
    }
    
    func downloadSync()
    {
        client.delegate = self
        client.downloadPathFromServer()
    }
    
    func addDeviceToServer(_ protocolType : String)
    {
        client.delegate = self
        client.addDeviceToServer(protocolType)
    }
    
    func bindDeviceToServer(_ deviceBindings : NSArray)
    {
        client.delegate = self
        client.bindThirdPartyDevice(deviceBindings)
    }
    
    func unbindThirdPartyDevice(_ deviceID : String, userNum : Int, memberID : String)
    {
        client.delegate = self
        client.unbindThirdPartyDevice(deviceID, userNum: userNum, memberID: memberID)
    }
    
    func savePedometerSteps()
    {
        client.delegate = self
        client.savePedometerSteps()
    }
    
    func deletePedometerSteps()
    {
        client.delegate = self
        client.deletePedometerSteps()
    }
    
    func saveWeight(_ weightRecordObj : WeightRecordObject)
    {
        client.delegate = self
        client.saveWeight(weightRecordObj)
    }
    
    func deleteWeight(_ weightRecordObj : WeightRecordObject)
    {
        client.delegate = self
        client.deleteWeight(weightRecordObj)
    }
    
    func addBloodPressureRecord()
    {
        client.delegate = self
        client.saveBloodPressureRecord()
    }
    
    func deleteBloodPressureRecord()
    {
        client.delegate = self
        client.deleteBloodPressureRecord()
    }
    
    // MARK: - WebServiceHTTPClient
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, loginUserSuccess success: NSDictionary)
    {
        print("success: \(success)")
        
        if JsonHandler.sharedInstance.getLoginResponse(response: success)
        {
            self.delegate?.WebServiceManagerClient(manager: self, loginUserSuccess: "OK")
        }
        else
        {
            self.delegate?.WebServiceManagerClient(manager: self, loginUserFailed: "Failed")
        }
    }
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, loginUserFailed error: NSString)
    {
        print("error: \(error)")
        
        self.delegate?.WebServiceManagerClient(manager: self, loginUserFailed: error)
    }
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, logoutUserSuccess success: NSDictionary)
    {
        print("success: \(success)")
        
        AppUtil.sharedInstance.clearCoreDataAndNSUserDefaults()
        
        self.delegate?.WebServiceManagerClient(manager: self, logoutUserSuccess: "OK")
    }
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, logoutUserFailed error: NSString)
    {
        print("error: \(error)")
        
        self.delegate?.WebServiceManagerClient(manager: self, logoutUserFailed: error)
    }
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, downloadPathFromServerSuccess success: NSDictionary)
    {
        print("success: \(success)")
        
        if JsonHandler.sharedInstance.getSyncResponse(response: success)
        {
            self.delegate?.WebServiceManagerClient(manager: self, downloadPathFromServerSuccess: "OK")
        }
        else
        {
            self.delegate?.WebServiceManagerClient(manager: self, downloadPathFromServerFailed: "Failed")
        }
    }
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, downloadPathFromServerFailed error: NSString)
    {
        print("error: \(error)")
        
        self.delegate?.WebServiceManagerClient(manager: self, downloadPathFromServerFailed: error)
    }
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, addDeviceSuccess success: NSDictionary, protocolType: String)
    {
        print("success: \(success)")
        
        self.delegate?.WebServiceManagerClient(manager: self, addDeviceSuccess: "OK", protocolType: protocolType)
    }
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, addDeviceFailed error: NSString, protocolType: String)
    {
        print("error: \(error)")
        
        self.delegate?.WebServiceManagerClient(manager: self, addDeviceFailed: error, protocolType: protocolType)
    }
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, bindDeviceSuccess success: NSDictionary)
    {
        print("success: \(success)")
        
        self.delegate?.WebServiceManagerClient(manager: self, bindDeviceSuccess: "OK")
    }
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, bindDeviceFailed error: NSString)
    {
        print("error: \(error)")
        
        self.delegate?.WebServiceManagerClient(manager: self, bindDeviceFailed: error)
    }
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, unbindDeviceSuccess success: NSDictionary, deviceID: String)
    {
        print("success: \(success)")
        
        let deviceObj : DeviceObject = StorageManager.sharedInstance.getDeviceByDeviceID(deviceID: deviceID)
        let deviceBindingObj : DeviceBindingObject = StorageManager.sharedInstance.getDeviceBindingByDeviceID(deviceID: deviceID)
        
        StorageManager.sharedInstance.deleteObject(obj: deviceObj)
        StorageManager.sharedInstance.deleteObject(obj: deviceBindingObj)
        
        self.delegate?.WebServiceManagerClient(manager: self, unbindDeviceSuccess: "OK")
    }
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, unbindDeviceFailed error: NSString)
    {
        print("error: \(error)")
        
        self.delegate?.WebServiceManagerClient(manager: self, unbindDeviceFailed: error)
    }
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, savePedometerStepsSuccess success: NSDictionary)
    {
        print("success: \(success)")
        
        self.delegate?.WebServiceManagerClient(manager: self, savePedometerStepsSuccess: "OK")
    }
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, savePedometerStepsFailed error: NSString)
    {
        print("error: \(error)")
        
        self.delegate?.WebServiceManagerClient(manager: self, savePedometerStepsFailed: error)
    }
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, deletePedometerStepsSuccess success: NSDictionary)
    {
        print("success: \(success)")
        
        self.delegate?.WebServiceManagerClient(manager: self, deletePedometerStepsSuccess: "OK")
    }
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, deletePedometerStepsFailed error: NSString)
    {
        print("error: \(error)")
        
        self.delegate?.WebServiceManagerClient(manager: self, deletePedometerStepsFailed: error)
    }
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, saveWeightSuccess success: NSDictionary, weightRecordObj: WeightRecordObject)
    {
        print("success: \(success)")
        
        weightRecordObj.weight_state    = WeightRecordObject.WEIGHTSTATE.WEIGHT_SYNC
        
        StorageManager.sharedInstance.updateObject(obj: weightRecordObj)
        
        self.delegate?.WebServiceManagerClient(manager: self, saveWeightSuccess: "OK")
    }
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, saveWeightFailed error: NSString, weightRecordObj: WeightRecordObject)
    {
        print("error: \(error)")
        
        weightRecordObj.weight_state    = WeightRecordObject.WEIGHTSTATE.WEIGHT_FAILED
        
        StorageManager.sharedInstance.updateObject(obj: weightRecordObj)
        
        self.delegate?.WebServiceManagerClient(manager: self, saveWeightFailed: error)
    }
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, deleteWeightSuccess success: NSDictionary, weightRecordObj: WeightRecordObject)
    {
        print("success: \(success)")
        
        StorageManager.sharedInstance.deleteObject(obj: weightRecordObj)
        
        self.delegate?.WebServiceManagerClient(manager: self, deleteWeightSuccess: "OK")
    }
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, deleteWeightFailed error: NSString)
    {
        print("error: \(error)")
        
        self.delegate?.WebServiceManagerClient(manager: self, deleteWeightFailed: error)
    }
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, saveBloodPressureRecordSuccess success: NSDictionary)
    {
        print("success: \(success)")
        
        self.delegate?.WebServiceManagerClient(manager: self, saveBloodPressureRecordSuccess: "OK")
    }
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, saveBloodPressureRecordFailed error: NSString)
    {
        print("error: \(error)")
        
        self.delegate?.WebServiceManagerClient(manager: self, saveBloodPressureRecordFailed: error)
    }
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, deleteBloodPressureRecordSuccess success: NSDictionary)
    {
        print("success: \(success)")
        
        self.delegate?.WebServiceManagerClient(manager: self, deleteBloodPressureRecordSuccess: "OK")
    }
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, deleteBloodPressureRecordFailed error: NSString)
    {
        print("error: \(error)")
        
        self.delegate?.WebServiceManagerClient(manager: self, deleteBloodPressureRecordFailed: error)
    }
}
