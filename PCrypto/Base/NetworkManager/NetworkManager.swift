//
//  NetworkManager.swift
//  PCrypto
//
//  Created by Ram Sharma on 15/03/22.
//

import UIKit

class NetworkManager: NSObject {
    func request(endPoint: Endpoint,success : ((_ response:Data?) -> ())? = nil,  failure: ((_ error:NSError) -> ())? = nil) {
        let url = URL(string: Constants.BASE_URL + endPoint.description)
        self.getDataFromServer(url: url!, success: success, failure: failure)
    }
    
    private func getDataFromServer(url:URL, success : ((_ response:Data?) -> ())? = nil,
                                   failure: ((_ error:NSError) -> ())? = nil) {
        let config = URLSessionConfiguration.default
        var request = URLRequest(url: url)
        
        let session = URLSession(configuration: config)
        request.setValue("468", forHTTPHeaderField: "x-app-version-code")
        request.setValue("iOS", forHTTPHeaderField: "x-device-family")
        
        let task = session.dataTask(with: request) {(data, response, error) in
            
            guard error == nil else {
                failure?(error! as NSError)
                return
            }
            
            guard let content = data else {
                failure?(error! as NSError)
                return
            }
            
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary else {
                print("Not containing JSON")
                return
            }
            print(json)
            
            success?(content);
        }
        
        task.resume()
        
    }
}
