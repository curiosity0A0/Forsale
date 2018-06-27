//
//  constants.swift
//  Forsale
//
//  Created by 洪森達 on 2018/6/12.
//  Copyright © 2018年 sen. All rights reserved.
//

import Foundation
import Firebase





let oneSignalAPPID = "b0d9e463-aaad-47a2-a080-f5f46c387470"
var backendless = Backendless.sharedInstance()
var firebase = Database.database().reference()
var notificationHander: UInt = 0
let notificationRef = firebase.child(kNnotification)
public let kOneSignalAppID = "4a4d442c-4c40-43ec-b762-f55f767339f2"
public let kFileRefrence = "gs://second-hand-store-fb37c.appspot.com"
//fuser
public let kStatus = "Status"
public let kOBJECTID = "objectId"
public let kUSER = "User"
public let kCREATEDAT = "createdAT"
public let kUpdated = "updatedAT"
public let kDisplayName = "displayName"
public let kPushID = "pushId"
public let kAvatar = "avatar"
public let kPhoneNumber = "phoneNumber"
public let kIsSubscription = "isSubscription"
public let kFavoritProperties = "favoritProperties"
public let KcurrentUser = "currentUser"
public let kVERIFICATION = "verification"
public let KoneSignalID = "OneSignalID"
public let KMaximum = 20
public let KMinimum = 10
public let KuserEmail = "Email"


//Parameter
public let typeArray  = ["Select","Computer","iPad","Phone","Watch","Laptop","TV"]
public let brand = ["Select","Apple","Samsung","Asus","SONY","LG","Nokia","Mi","Others"]
public let warrantyArray = ["Select","YES","NO"]

public let dateOfPurchaseArray = ["Select","2018","2017","2016","2015","2014"]
public  let cityArray = ["Select","Keelung","Taipei","Hsinchu","Taichung","Tainan","Kaohsiung"," NewTaipei","Yilan"," Taoyuan"," Miaoli"," Changhua","Nantou","Yunlin","Chiayi","Pingtung","Taitung","Hualien","Penghu"]
public let statusArray = ["Select","90%","80%","70%","60%"]
public let DealWayArray = ["Select","Face","Mail","transfer"]
public let minPreceArray = ["Minimum","Any","10000","20000","30000","40000","50000","60000","70000","80000","90000","100000"]
public let maxPreceArray = ["Maximum","Any","10000","20000","30000","40000","50000","60000","70000","80000","90000","100000"]

//NOTIFICATION
 public let kNnotification = "Notification"
 public let kNnotificationId = "NotificationId"
 public let KNcreatedAt = "CreatedAt"
 public let  kNproductTitle = "ProductTitle"
 public let  kNproductObjectId = "ProductObjectId"
 public let   kNbuyerName = "BuyerName"
 public let  kNbuyerId = "BuyerId"
 public let  kNagentId = "AgentId"
 public let  kNbuyerPhoneNumber = "BuyerPhoneNumber"
 public let  kNbuyeremail = "Buyeremail"
 public let  kNbuyerMessage:String = "BuyerMessage"

