//
//  AccountViewController.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/15/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController
{
    // MARK: - IBOutlet
    
    @IBOutlet var pictureImageView      : UIImageView!
    @IBOutlet var nameLabel             : UILabel!
    @IBOutlet var emailLabel            : UILabel!
    @IBOutlet var birthdayLabel         : UILabel!
    @IBOutlet var devicesTableView      : UITableView!
    
    // MARK: - Variables
    
    var manager                         : WebServiceManager                 = WebServiceManager()
    
    var headerCell                      : AvailableDevicesTableViewCell?
    var devicesCell                     : AvailableDevicesTableViewCell?
    
    var headerCellIdentifier            : String                            = "headerCell"
    var devicesCellIdentifier           : String                            = "devicesCell"
    
    var devicesArray                    = [NSString]()
    
    enum DEVICELIST: Int
    {
        case WEIGHT = 0 , PEDOMETER = 1, BLOOD_PRESSURE = 2
    }
    
    // MARK: - View Management
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        /* Check if User is Logged In */
        
        if !UserDefaults.standard.bool(forKey: "isLoggedIn")
        {
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
        
        /* Remove TableView Footer */
        
        devicesTableView.tableFooterView = UIView(frame: .zero)
        
        /* Content */
        
        devicesArray = ContentUtil.sharedInstance.devicesArray()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        /* Content */
        
        self.displayUserInfo()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayUserInfo()
    {
        if let accountID = UserDefaults.standard.value(forKey: "accountID") as? String
        {
            let accountObj  : AccountObject = StorageManager.sharedInstance.getAccountInfo(accountID: accountID)
            let memberObj   : MemberObject  = StorageManager.sharedInstance.getMemberInfo(accountID: accountID)
            
            nameLabel.text          = "Name : \(memberObj.firstName)"
            emailLabel.text         = "Email : \(accountObj.email)"
            birthdayLabel.text      = "Birthday : \(memberObj.birthday)"
            
            if let photoURL : URL   = URL(string: memberObj.pictureURL)
            {
                pictureImageView.setImageWith(photoURL, placeholderImage: UIImage(named:"blank_profile_image.png"))
            }
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem)
    {
        self.logoutAPI()
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showDeviceSegue"
        {
            let indexPath : Int = (sender as? Int)!
            
            let deviceListVC : DeviceListViewController = segue.destination as! DeviceListViewController
            
            if indexPath == DEVICELIST.WEIGHT.rawValue
            {
                deviceListVC.deviceType     = [LS_WEIGHT_SCALE.rawValue,LS_FAT_SCALE.rawValue,LS_KITCHEN_SCALE.rawValue]
                deviceListVC.protocolType   = "A3"
            }
            else if indexPath == DEVICELIST.PEDOMETER.rawValue
            {
                deviceListVC.deviceType     = [LS_PEDOMETER.rawValue]
                deviceListVC.protocolType   = "A2"
            }
            else if indexPath == DEVICELIST.BLOOD_PRESSURE.rawValue
            {
                deviceListVC.deviceType     = [LS_SPHYGMOMETER.rawValue]
                deviceListVC.protocolType   = "A3"
            }
        }
    }
}

// MARK: - Extension - UITableViewDelegate, UITableViewDataSource

extension AccountViewController : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 1
        {
            return devicesArray.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 1
        {
            devicesCell = (tableView.dequeueReusableCell(withIdentifier: devicesCellIdentifier) as? AvailableDevicesTableViewCell)!
            
            devicesCell?.deviceLabel.text = devicesArray[indexPath.row] as String
            
            return devicesCell!
        }
        
        headerCell = (tableView.dequeueReusableCell(withIdentifier: headerCellIdentifier) as? AvailableDevicesTableViewCell)!
        
        return headerCell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 1
        {
            self.performSegue(withIdentifier: "showDeviceSegue", sender: indexPath.row)
        }
    }
}

// MARK: - Extension - WebServiceManagerDelegate

extension AccountViewController : WebServiceManagerDelegate
{
    func logoutAPI()
    {
        manager.delegate = self
        manager.logout()
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, loginUserSuccess success : NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, loginUserFailed error: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, logoutUserSuccess success : NSString)
    {
        self.performSegue(withIdentifier: "loginSegue", sender: self)
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, logoutUserFailed error: NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, downloadPathFromServerSuccess success : NSString)
    {
        
    }
    
    func WebServiceManagerClient(manager: WebServiceManager, downloadPathFromServerFailed error: NSString)
    {
        
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
