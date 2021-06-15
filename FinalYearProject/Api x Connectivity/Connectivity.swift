//
//  Connectivity.swift
//  ApiUtils
//
//  Created by Ibukunoluwa Soyebo on 21/09/2020.
//

import Foundation
import Alamofire
import PKHUD

class Connectivity: NSObject {

    class func isConnectedToInternet(viewcontroller: UIViewController) {
        if !NetworkReachabilityManager()!.isReachable {
         
         let alert = UIAlertController(title: "No Internet Connectivity", message: "Please check for internet connnectivity", preferredStyle: UIAlertController.Style.alert)
                                  alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                                  viewcontroller.present(alert, animated: true, completion: ({
                                    HUD.hide()
                                  }))
         return
        }
    }
    
}
