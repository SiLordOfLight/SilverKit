//
//  DownloadHelper.swift
//  MerTranslatorApp
//
//  Created by Jake Trimble on 11/7/18.
//  Copyright © 2018 Jake Trimble. All rights reserved.
//

import Foundation

/**
 A helper for downloading server-based files to the local file architecture
 
 - Author: Jake Trimble
 
 - Version: 1.0.0
*/
public class SlvDownloadHelper {
    /**
     Downloads the specified file to a given path and optionally executes a closure on completion
     
     - parameter srcUrl: The URL of the file to download
     - parameter destFile: The file path to save the downloaded file to
     - parameter completion: A function that executes upon completing the download
    */
    public static func downloadFile(from srcUrl:URL, to destFile:String, then completion:@escaping () -> Void={}){
        // Create destination URL
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationFileUrl = documentsUrl.appendingPathComponent(destFile)
        
        //Create URL to the source file you want to download
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let request = URLRequest(url:srcUrl)
        
        //print(destinationFileUrl)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            //print(tempLocalUrl!)
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }
                
                do {
                    //print(tempLocalUrl)
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                    return
                }
                
                completion()
                
            } else {
                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription ?? "");
            }
        }
        task.resume()
        
        //print("asa")
    }
}
