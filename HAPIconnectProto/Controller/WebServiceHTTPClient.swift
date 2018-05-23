//
//  WebServiceHTTPClient.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/10/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import UIKit
import AFNetworking

class WebServiceHTTPClient: AFHTTPSessionManager
{
    // MARK: - Delegate
    
    var delegate : WebServiceHTTPClientDelegate?
    
    // MARK: Shared Instance
    
    class func sharedHTTPClient() -> WebServiceHTTPClient
    {
        var sharedInstance: WebServiceHTTPClient? = nil
        
        sharedInstance = self.init(baseURL: URL(string: AppUtil.sharedInstance.getDomainURLString() as String))
        let operationQueue: OperationQueue? = sharedInstance?.operationQueue
        sharedInstance?.reachabilityManager.setReachabilityStatusChange({(status: AFNetworkReachabilityStatus) -> Void in
            switch status {
            case AFNetworkReachabilityStatus.reachableViaWWAN, AFNetworkReachabilityStatus.reachableViaWiFi:
                operationQueue?.isSuspended = false
            default:
                operationQueue?.isSuspended = true
            }
        })
        
        return sharedInstance!
    }
    
    // MARK: - Login
    
    func loginwithLoginName(loginName: String, password: String, app : String, carrier : String, loginType : Int, clientId : String)
    {
        print("\(#function)")
        
        let passwordMD5 : String            = AppUtil.sharedInstance.md5Hash(password)
        
        let postURL : NSString              = "\(AppUtil.sharedInstance.loginPathString())\(AppUtil.sharedInstance.lastURLWithToken(string: (passwordMD5 as NSString) as String, sessionID: ""))" as NSString
        
        print("postURL: \(postURL)")
        
        let manager : WebServiceHTTPClient  = WebServiceHTTPClient.sharedHTTPClient()
        
        let parameter : NSMutableDictionary = JsonRequest.sharedInstance.loginUserJson(loginName: loginName, app: app, carrier: carrier, loginType: loginType, clientId: clientId)
        
        print("parameter: \(String(describing: parameter))")
        
        let jsonSerializer = AFJSONRequestSerializer()
        jsonSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer = jsonSerializer
        
        manager.post(postURL as String, parameters: parameter, progress: nil, success: { (operation: URLSessionDataTask, responseObject: Any?) in
            
            self.delegate?.WebServiceHTTPClient(sender: self, loginUserSuccess: responseObject as! NSDictionary)
            
        }, failure: { (operation: URLSessionDataTask?, error: Error?) in
            
            let errorMessage : Error = error! as Error
            
            self.delegate?.WebServiceHTTPClient(sender: self, loginUserFailed: errorMessage.localizedDescription as NSString)
        })
    }
    
    // MARK: - Logout
    
    func logout(sessionID : String)
    {
        print("\(#function)")
        
        let postURL : NSString              = "\(AppUtil.sharedInstance.logoutPathString())?sessionId=\(sessionID)" as NSString
        
        print("postURL: \(postURL)")
        
        let manager : WebServiceHTTPClient  = WebServiceHTTPClient.sharedHTTPClient()
        
        let jsonSerializer = AFJSONRequestSerializer()
        jsonSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer = jsonSerializer
        
        manager.get(postURL as String, parameters: nil, progress: nil, success: { (operation: URLSessionDataTask, responseObject: Any?) in
            
            self.delegate?.WebServiceHTTPClient(sender: self, logoutUserSuccess: responseObject as! NSDictionary)
            
        }, failure: { (operation: URLSessionDataTask?, error: Error?) in
            
            let errorMessage : Error = error! as Error
            
            self.delegate?.WebServiceHTTPClient(sender: self, logoutUserFailed: errorMessage.localizedDescription as NSString)
        })
    }
    
    // MARK: - Sync
    
    func downloadPathFromServer()
    {
        print("\(#function)")
        
        let postURL : NSString              = "\(AppUtil.sharedInstance.downloadPathString())\(AppUtil.sharedInstance.lastURLWithTokenAndSession())" as NSString
        
        print("postURL: \(postURL)")
        
        let manager : WebServiceHTTPClient  = WebServiceHTTPClient.sharedHTTPClient()
        
        let parameter : NSMutableDictionary = JsonRequest.sharedInstance.downloadData()
        
        print("parameter: \(String(describing: parameter))")
        
        let jsonSerializer = AFJSONRequestSerializer()
        jsonSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer = jsonSerializer
        
        manager.post(postURL as String, parameters: parameter, progress: nil, success: { (operation: URLSessionDataTask, responseObject: Any?) in
            
            self.delegate?.WebServiceHTTPClient(sender: self, downloadPathFromServerSuccess: responseObject as! NSDictionary)
            
        }, failure: { (operation: URLSessionDataTask?, error: Error?) in
            
            let errorMessage : Error = error! as Error
            
            self.delegate?.WebServiceHTTPClient(sender: self, downloadPathFromServerFailed: errorMessage.localizedDescription as NSString)
        })
    }
    
    // MARK: - Add, Bind and Unbind Device
    
    func addDeviceToServer(_ protocolType: String)
    {
        print("\(#function)")
        
        let postURL : NSString              = "\(AppUtil.sharedInstance.addDevicePath())\(AppUtil.sharedInstance.lastURLWithTokenAndSession())" as NSString
        
        print("postURL: \(postURL)")
        
        let manager : WebServiceHTTPClient  = WebServiceHTTPClient.sharedHTTPClient()
        
        let parameter : NSMutableDictionary = JsonRequest.sharedInstance.addDevice(protocolType)
        
        print("parameter: \(String(describing: parameter))")
        
        let jsonSerializer = AFJSONRequestSerializer()
        jsonSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer = jsonSerializer
        
        manager.post(postURL as String, parameters: parameter, progress: nil, success: { (operation: URLSessionDataTask, responseObject: Any?) in
            
            self.delegate?.WebServiceHTTPClient(sender: self, addDeviceSuccess: responseObject as! NSDictionary, protocolType: protocolType)
            
        }, failure: { (operation: URLSessionDataTask?, error: Error?) in
            
            let errorMessage : Error = error! as Error
            
            self.delegate?.WebServiceHTTPClient(sender: self, addDeviceFailed: errorMessage.localizedDescription as NSString, protocolType: protocolType)
        })
    }
    
    func bindThirdPartyDevice(_ deviceBindings: NSArray)
    {
        print("\(#function)")
        
        let postURL : NSString              = "\(AppUtil.sharedInstance.bindDevicePath())\(AppUtil.sharedInstance.lastURLWithTokenAndSession())" as NSString
        
        print("postURL: \(postURL)")
        
        let manager : WebServiceHTTPClient  = WebServiceHTTPClient.sharedHTTPClient()
        
        let parameter : NSMutableDictionary = JsonRequest.sharedInstance.bindDevice(deviceBindings)
        
        print("parameter: \(String(describing: parameter))")
        
        let jsonSerializer = AFJSONRequestSerializer()
        jsonSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer = jsonSerializer
        
        manager.post(postURL as String, parameters: parameter, progress: nil, success: { (operation: URLSessionDataTask, responseObject: Any?) in
            
            self.delegate?.WebServiceHTTPClient(sender: self, bindDeviceSuccess: responseObject as! NSDictionary)
            
        }, failure: { (operation: URLSessionDataTask?, error: Error?) in
            
            let errorMessage : Error = error! as Error
            
            self.delegate?.WebServiceHTTPClient(sender: self, bindDeviceFailed: errorMessage.localizedDescription as NSString)
        })
    }
    
    func unbindThirdPartyDevice(_ deviceID : String, userNum : Int, memberID : String)
    {
        print("\(#function)")
        
        let postURL : NSString              = "\(AppUtil.sharedInstance.unbindDevicePath())\(AppUtil.sharedInstance.lastURLWithTokenAndSession())" as NSString
        
        print("postURL: \(postURL)")
        
        let manager : WebServiceHTTPClient  = WebServiceHTTPClient.sharedHTTPClient()
        
        let parameter : NSMutableDictionary = JsonRequest.sharedInstance.unbindDevice(deviceID, userNum: userNum, memberID: memberID)
        
        print("parameter: \(String(describing: parameter))")
        
        let jsonSerializer = AFJSONRequestSerializer()
        jsonSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer = jsonSerializer
        
        manager.post(postURL as String, parameters: parameter, progress: nil, success: { (operation: URLSessionDataTask, responseObject: Any?) in
            
            self.delegate?.WebServiceHTTPClient(sender: self, unbindDeviceSuccess: responseObject as! NSDictionary, deviceID : deviceID)
            
        }, failure: { (operation: URLSessionDataTask?, error: Error?) in
            
            let errorMessage : Error = error! as Error
            
            self.delegate?.WebServiceHTTPClient(sender: self, unbindDeviceFailed: errorMessage.localizedDescription as NSString)
        })
    }
    
    // MARK: - Pedometer
    
    func savePedometerSteps()
    {
        print("\(#function)")
        
        let postURL : NSString              = "\(AppUtil.sharedInstance.pedometerSavePath())\(AppUtil.sharedInstance.lastURLWithTokenAndSession())" as NSString
        
        print("postURL: \(postURL)")
        
        let manager : WebServiceHTTPClient  = WebServiceHTTPClient.sharedHTTPClient()
        
        let jsonSerializer = AFJSONRequestSerializer()
        jsonSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer = jsonSerializer
        
        manager.post(postURL as String, parameters: nil, progress: nil, success: { (operation: URLSessionDataTask, responseObject: Any?) in
            
            self.delegate?.WebServiceHTTPClient(sender: self, savePedometerStepsSuccess: responseObject as! NSDictionary)
            
        }, failure: { (operation: URLSessionDataTask?, error: Error?) in
            
            let errorMessage : Error = error! as Error
            
            self.delegate?.WebServiceHTTPClient(sender: self, savePedometerStepsFailed: errorMessage.localizedDescription as NSString)
        })
    }
    
    func deletePedometerSteps()
    {
        print("\(#function)")
        
        let postURL : NSString              = "\(AppUtil.sharedInstance.pedometerDeletePath())\(AppUtil.sharedInstance.lastURLWithTokenAndSession())" as NSString
        
        print("postURL: \(postURL)")
        
        let manager : WebServiceHTTPClient  = WebServiceHTTPClient.sharedHTTPClient()
        
        let jsonSerializer = AFJSONRequestSerializer()
        jsonSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer = jsonSerializer
        
        manager.post(postURL as String, parameters: nil, progress: nil, success: { (operation: URLSessionDataTask, responseObject: Any?) in
            
            self.delegate?.WebServiceHTTPClient(sender: self, deletePedometerStepsSuccess: responseObject as! NSDictionary)
            
        }, failure: { (operation: URLSessionDataTask?, error: Error?) in
            
            let errorMessage : Error = error! as Error
            
            self.delegate?.WebServiceHTTPClient(sender: self, deletePedometerStepsFailed: errorMessage.localizedDescription as NSString)
        })
    }
    
    // MARK: - Weight
    
    func saveWeight(_ weightRecordObj : WeightRecordObject)
    {
        print("\(#function)")
        
        let postURL : NSString              = "\(AppUtil.sharedInstance.weightSavePath())\(AppUtil.sharedInstance.lastURLWithTokenAndSession())" as NSString
        
        print("postURL: \(postURL)")
        
        let manager : WebServiceHTTPClient  = WebServiceHTTPClient.sharedHTTPClient()
        
        let parameter : NSMutableDictionary = JsonRequest.sharedInstance.addWeight(weightRecordObj)
        
        print("parameter: \(String(describing: parameter))")
        
        let jsonSerializer = AFJSONRequestSerializer()
        jsonSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer = jsonSerializer
        
        manager.post(postURL as String, parameters: parameter, progress: nil, success: { (operation: URLSessionDataTask, responseObject: Any?) in
            
            self.delegate?.WebServiceHTTPClient(sender: self, saveWeightSuccess: responseObject as! NSDictionary, weightRecordObj: weightRecordObj)
            
        }, failure: { (operation: URLSessionDataTask?, error: Error?) in
            
            let errorMessage : Error = error! as Error
            
            self.delegate?.WebServiceHTTPClient(sender: self, saveWeightFailed: errorMessage.localizedDescription as NSString, weightRecordObj: weightRecordObj)
        })
    }
    
    func deleteWeight(_ weightRecordObj : WeightRecordObject)
    {
        print("\(#function)")
        
        let postURL : NSString              = "\(AppUtil.sharedInstance.weightDeletePath())\(AppUtil.sharedInstance.lastURLWithTokenAndSession())" as NSString
        
        print("postURL: \(postURL)")
        
        let manager : WebServiceHTTPClient  = WebServiceHTTPClient.sharedHTTPClient()
        
        let parameter : NSMutableDictionary = JsonRequest.sharedInstance.deleteWeight(weightRecordObj)
        
        print("parameter: \(String(describing: parameter))")
        
        let jsonSerializer = AFJSONRequestSerializer()
        jsonSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer = jsonSerializer
        
        manager.post(postURL as String, parameters: parameter, progress: nil, success: { (operation: URLSessionDataTask, responseObject: Any?) in
            
            self.delegate?.WebServiceHTTPClient(sender: self, deleteWeightSuccess: responseObject as! NSDictionary, weightRecordObj: weightRecordObj)
            
        }, failure: { (operation: URLSessionDataTask?, error: Error?) in
            
            let errorMessage : Error = error! as Error
            
            self.delegate?.WebServiceHTTPClient(sender: self, deleteWeightFailed: errorMessage.localizedDescription as NSString)
        })
    }
    
    // MARK: - Blood Pressure
    
    func saveBloodPressureRecord()
    {
        print("\(#function)")
        
        let postURL : NSString              = "\(AppUtil.sharedInstance.bloodPressureSavePath())\(AppUtil.sharedInstance.lastURLWithTokenAndSession())" as NSString
        
        print("postURL: \(postURL)")
        
        let manager : WebServiceHTTPClient  = WebServiceHTTPClient.sharedHTTPClient()
        
        let jsonSerializer = AFJSONRequestSerializer()
        jsonSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer = jsonSerializer
        
        manager.post(postURL as String, parameters: nil, progress: nil, success: { (operation: URLSessionDataTask, responseObject: Any?) in
            
            self.delegate?.WebServiceHTTPClient(sender: self, saveBloodPressureRecordSuccess: responseObject as! NSDictionary)
            
        }, failure: { (operation: URLSessionDataTask?, error: Error?) in
            
            let errorMessage : Error = error! as Error
            
            self.delegate?.WebServiceHTTPClient(sender: self, saveBloodPressureRecordFailed: errorMessage.localizedDescription as NSString)
        })
    }
    
    func deleteBloodPressureRecord()
    {
        print("\(#function)")
        
        let postURL : NSString              = "\(AppUtil.sharedInstance.bloodPressureDeletePath())\(AppUtil.sharedInstance.lastURLWithTokenAndSession())" as NSString
        
        print("postURL: \(postURL)")
        
        let manager : WebServiceHTTPClient  = WebServiceHTTPClient.sharedHTTPClient()
        
        let jsonSerializer = AFJSONRequestSerializer()
        jsonSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer = jsonSerializer
        
        manager.post(postURL as String, parameters: nil, progress: nil, success: { (operation: URLSessionDataTask, responseObject: Any?) in
            
            self.delegate?.WebServiceHTTPClient(sender: self, deleteBloodPressureRecordSuccess: responseObject as! NSDictionary)
            
        }, failure: { (operation: URLSessionDataTask?, error: Error?) in
            
            let errorMessage : Error = error! as Error
            
            self.delegate?.WebServiceHTTPClient(sender: self, deleteBloodPressureRecordFailed: errorMessage.localizedDescription as NSString)
        })
    }
}

// MARK: - WebServiceHTTPClientDelegate

protocol WebServiceHTTPClientDelegate
{
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, loginUserSuccess success: NSDictionary)
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, loginUserFailed error: NSString)
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, logoutUserSuccess success: NSDictionary)
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, logoutUserFailed error: NSString)
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, downloadPathFromServerSuccess success: NSDictionary)
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, downloadPathFromServerFailed error: NSString)
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, addDeviceSuccess success: NSDictionary, protocolType : String)
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, addDeviceFailed error: NSString, protocolType: String)
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, bindDeviceSuccess success: NSDictionary)
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, bindDeviceFailed error: NSString)
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, unbindDeviceSuccess success: NSDictionary, deviceID : String)
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, unbindDeviceFailed error: NSString)
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, savePedometerStepsSuccess success: NSDictionary)
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, savePedometerStepsFailed error: NSString)
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, deletePedometerStepsSuccess success: NSDictionary)
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, deletePedometerStepsFailed error: NSString)
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, saveWeightSuccess success: NSDictionary, weightRecordObj: WeightRecordObject)
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, saveWeightFailed error: NSString, weightRecordObj: WeightRecordObject)
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, deleteWeightSuccess success: NSDictionary, weightRecordObj: WeightRecordObject)
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, deleteWeightFailed error: NSString)
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, saveBloodPressureRecordSuccess success: NSDictionary)
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, saveBloodPressureRecordFailed error: NSString)
    
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, deleteBloodPressureRecordSuccess success: NSDictionary)
    func WebServiceHTTPClient(sender: WebServiceHTTPClient, deleteBloodPressureRecordFailed error: NSString)
}
