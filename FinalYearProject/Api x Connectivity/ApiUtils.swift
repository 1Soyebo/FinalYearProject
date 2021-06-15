//
//  ApiUtils.swift
//  ApiUtils
//
//  Created by Ibukunoluwa Soyebo on 21/09/2020.
//

import Foundation

import Alamofire
import PKHUD

class ApiUtil{
    static var successBool = "status"
    static var message = "message"
    static var errorMssg = "errorMssg"
    
//    static let headers: HTTPHeaders = ["content-Type":"application/json"]

    
    static func postRequest(viewController:UIViewController,endpoint:String,params:Parameters,displayErrorAsAlert:Bool, jsonHandler: @escaping (AFDataResponse<Any>) -> Void, showHUd: Bool = false){
        Connectivity.isConnectedToInternet(viewcontroller: viewController)
        HUD.show(.progress)
        
        AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate(statusCode: 200...400)
            .responseJSON{
                response in
                switch response.result{
                case .success:
                    guard response.error == nil else {
                        // got an error in getting the data, need to handle it
                        print("error calling POST on /todos/1")
                        print(response.error!)
                        HUD.flash(.labeledError(title: "Network Error", subtitle: "Check internet Connection"),delay: 1)
                        return
                    }
                    // make sure we got some JSON since that's what we expect
                    guard let json = response.value as? [String: Any] else {
                        print("didn't get todo object as JSON from API")
                        if let error = response.error {
                            print("Error: \(error)")
                        }
                        return
                    }
                    print(json)
                    let success = json[successBool] as! Bool
                    //var myMessage = json[message] as! String
                    let errMssg = json[errorMssg] as! String
                    
                    if success{
                        HUD.hide()
                        jsonHandler(response)
                    }else{
                        print(params)
                        //print(myMessage)
                        if displayErrorAsAlert{
                            displayErrorMessageAsAlert(viewcontroller: viewController, errorMessage: errMssg)
                        }else{
                            HUD.flash(.labeledError(title: "Error", subtitle: errMssg),delay: 1)

                        }
                    }
                case .failure(let error):
                    displayErrorMessageAsAlert(viewcontroller: viewController, errorMessage: error.localizedDescription)
                    print(response.value as? [String:Any])
                    print("mess up")
                }
        }
        
    }
    
    
    static func getRequest(viewController:UIViewController,endpoint:String,customError:Bool, jsonHandler:@escaping (AFDataResponse<Any>)->Void, onFailure:@escaping ()-> Void){
        Connectivity.isConnectedToInternet(viewcontroller: viewController)
        AF.request(endpoint)
            .validate(statusCode: 200...400)
            .responseJSON{
            response in
                switch response.result{
                case .success:
                    guard response.error == nil else {
                        // got an error in getting the data, need to handle it
                        print("error calling POST on /todos/1")
                        print(response.error!)
                        HUD.flash(.labeledError(title: "Network Error", subtitle: "Check internet Connection"),delay: 1)
                        return
                    }
                    // make sure we got some JSON since that's what we expect
                    guard let json = response.value as? [String: Any] else {
                        print("didn't get todo object as JSON from API")
                        if let error = response.error {
                            print("Error: \(error)")
                        }
                        return
                    }
                    print(json)
                    print("K")
//                    let success = json[successBool] as! Bool
//                    var errMSg = json[errorMessage] as! String
//                    if success{
                        HUD.hide()
                        jsonHandler(response)
//                    }else{
//                        if customError{
//                            onFailure()
//                        }else{
//                            errMSg = errMSg == "" ? "Something went wrong":errMSg
//                            displayErrorMessageAsAlert(viewcontroller: viewController, errorMessage: errMSg)
//                            //HUD.flash(.labeledError(title: "Error", subtitle: errMSg),delay: 1)
//                        }
//                    }
                case .failure(let error):
                    HUD.flash(.label(error.localizedDescription), delay: 1)
                    //displayErrorMessageAsAlert(viewcontroller: viewController, errorMessage: )
                    print("wahala dey")
                }
        }
        
    }
    
    
    static func getUnwrappedRequest(viewController:UIViewController,endpoint:String,customError:Bool, jsonHandler:@escaping ([String:Any], Bool?, String?, String?)->Void, onFailure:@escaping ()-> Void){
        Connectivity.isConnectedToInternet(viewcontroller: viewController)
        HUD.show(.progress)
        AF.request(endpoint)
            .validate(statusCode: 200...400)
            .responseJSON{
            response in
                switch response.result{
                case .success:
                    guard response.error == nil else {
                        // got an error in getting the data, need to handle it
                        print("error calling POST on /todos/1")
                        print(response.error!)
                        HUD.flash(.labeledError(title: "Network Error", subtitle: "Check internet Connection"),delay: 1)
                        return
                    }
                    // make sure we got some JSON since that's what we expect
                    guard let json = response.value as? [String: Any] else {
                        print("didn't get todo object as JSON from API")
                        if let error = response.error {
                            print("Error: \(error)")
                        }
                        return
                    }
                    //let jsonDict = response.value as? [String:Any]
                    let status = json[ApiUtil.successBool] as? Bool
                    let message = json[ApiUtil.message] as? String
                    let errMsg = json[ApiUtil.errorMssg] as? String
                    print("K")
                    HUD.hide()
                    jsonHandler(json,status,message,errMsg)
                case .failure(let error):
                    HUD.flash(.label(error.localizedDescription), delay: 1)
                    //displayErrorMessageAsAlert(viewcontroller: viewController, errorMessage: )
                    print("wahala dey")
                }
        }
        
    }
    
    static func displayErrorMessageAsAlert(viewcontroller:UIViewController, errorMessage:String){
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        viewcontroller.present(alert, animated: true, completion: ({
          HUD.hide()
        }))
        
    }
    
    static func hmm(){
        let k: HTTPHeaders = ["":""]
        AF.request("hmm",headers:k).responseJSON{
            response in
            let k = response.value as! [String:Any]
        }
            
    }
    
}
