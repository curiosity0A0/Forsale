//
//  NotificationVC.swift
//  Forsale
//
//  Created by 洪森達 on 2018/6/25.
//  Copyright © 2018年 sen. All rights reserved.
//

import UIKit



class NotificationVC: UIViewController,UITableViewDelegate,UITableViewDataSource{

    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noNotificationLabel: UILabel!
    
    var Allnotification:[Notification] = []
   
 
    
    @IBAction func goToback(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotificaiton()
        // Do any additional setup after loading the view.
        tableView.reloadData()
 
    }



    
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

    //MARK: TABEL VIEW DATA SOURCE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Allnotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! notificationCell
        
        cell.bibData(FbNotification: Allnotification[indexPath.row])
        //bib
        
        return cell
        
    }
    
    //MARK : TABEL VIEW DELEGATE
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        
        view.backgroundColor = UIColor.clear
        
        return view
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     
       
        deleteNotification(fbNotification: Allnotification[indexPath.row])
        Allnotification.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    

    //MARK: LoadNotification
    
    func loadNotificaiton(){
        
        fetchAgentNotification(agentId: Fuser.currentId()) { (allNotif) in
            
            self.Allnotification = allNotif as! [Notification]
            
            if self.Allnotification.count == 0 {
                self.noNotificationLabel.isHidden = false
                print("No notifications")
            }
            
            self.tableView.reloadData()
            
        }
    }
   
    

}
