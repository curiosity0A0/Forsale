//
//  download.swift
//  Forsale
//
//  Created by 洪森達 on 2018/6/19.
//  Copyright © 2018年 sen. All rights reserved.
//

import Foundation
import Firebase

let storage = Storage.storage()

func downloadImages(urls:String,withBlock:@escaping(_ images: [UIImage?])->Void){
    
    let linkArray = separateImageLinks(allLinks: urls)
    var imageArray:[UIImage] = []
    var downLoadCounter = 0
    
    for link in linkArray {
        
        let url = NSURL(string: link)
        
        let downLoadQueue = DispatchQueue(label: "imageDownloadQueue")
        
        downLoadQueue.async {
            
            downLoadCounter += 1
            let data = NSData(contentsOf: url! as URL)
            
            if data != nil {
                
                
                imageArray.append(UIImage(data: data! as Data)!)
                if downLoadCounter == imageArray.count {
                    
                    DispatchQueue.main.async {
                        withBlock(imageArray)
                    }
                }
            
            
            }else{
                
                print("couldnt download image")
                withBlock(imageArray)
            }

        }
        
        
        
    }
    
    
    
}

func uploadImages(images:[UIImage],userId:String,refereceNumber:String,titile:String,withBlcok: @escaping (_ imageLink: String?)->Void){
    
    convertImagesTodate(images: images) { (pictures) in
        
        var uploadCounter = 0
        var nameSuffix = 0
        var linkString = ""
        for picture in  pictures {
            
            let fileName = userId + "/" + refereceNumber + "/" + titile + "/image" + "\(nameSuffix)" + ".jpg"
            
            nameSuffix += 1
            
            let storageRef = storage.reference(forURL: kFileRefrence).child(fileName)
            
            
            var task : StorageUploadTask!
            
                task = storageRef.putData(picture, metadata: nil, completion: { (metadate, error) in
                    
                    uploadCounter += 1
                    
                    if error != nil {
                    
                        print("error uploading picture\(error!.localizedDescription)")
                        
                    }
                    
                    let link = metadate!.downloadURL()
                    linkString = linkString + link!.absoluteString + ","
                    
                    if uploadCounter == pictures.count {
                        
                        task.removeAllObservers()
                        withBlcok(linkString)
                    }
                })
        }
        
        
    }
    
    
    
}


//MARK: HELPERS
func convertImagesTodate(images: [UIImage],withblock: @escaping(_  datas: [Data])->Void){
    
    var dataArray :[Data] = []
    for image in images {
        
        dataArray.append(UIImageJPEGRepresentation(image, 0.5)!)
        
    }
    
    withblock(dataArray)
}






func separateImageLinks(allLinks:String)->[String]{
    
    var linkArray = allLinks.components(separatedBy: ",")
    linkArray.removeLast()
    return linkArray
}


