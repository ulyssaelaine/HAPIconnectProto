//
//  WeightSummaryViewController.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/16/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import UIKit

class WeightSummaryViewController: UITableViewController
{
    // MARK: - IBOutlet
    
    @IBOutlet var weightSummaryTableView    : UITableView!
    
    // MARK: - Variables
    
    var weightSummaryCell                   = WeightSummaryTableViewCell()
    var deviceObj                           = DeviceObject()
    
    var weightRecordArray                   = [WeightRecordObject]()
    var weightRecordFilteredArray           = NSDictionary()
    
    // MARK: - View Management
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        /* Remove TableView Footer */
        
        weightSummaryTableView.tableFooterView = UIView(frame: .zero)
        
        /* Content */
        
        self.loadContent()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.title = "Données de poids enregistrées"
    }
    
    // MARK: - Load Content
    
    func loadContent()
    {
        weightRecordArray           = StorageManager.sharedInstance.getWeightRecordArrayByDeviceID(deviceID: deviceObj.deviceID)
        
        /* Filter Duplicates */
        
        weightRecordFilteredArray   =  Dictionary(grouping: weightRecordArray, by: { $0.weight_date }) as NSDictionary
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showWeightDataSegue"
        {
            let indexPath = sender as? IndexPath
            
            let weightDate : String     = weightRecordFilteredArray.allKeys[(indexPath?.row)!] as! String
            
            let weightHistoryVC : WeightHistoryViewController = segue.destination as! WeightHistoryViewController
            
            weightHistoryVC.deviceObj   = deviceObj
            weightHistoryVC.weightDate  = weightDate
            weightHistoryVC.title       = weightDate
            
            self.title = ""
        }
    }

    // MARK: - UITableViewDelegate, UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return weightRecordFilteredArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        weightSummaryCell = (tableView.dequeueReusableCell(withIdentifier: "WeightSummaryTableViewCell") as? WeightSummaryTableViewCell)!
        
        weightSummaryCell.dateLabel.text    = weightRecordFilteredArray.allKeys[indexPath.row] as? String
        
        return weightSummaryCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "showWeightDataSegue", sender: indexPath)
    }
}
