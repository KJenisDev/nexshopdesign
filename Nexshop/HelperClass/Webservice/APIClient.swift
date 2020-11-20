
import Foundation
import Alamofire

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}

class APIClient: NSObject {
    
    static let shared = APIClient()
    
    let session = Alamofire.SessionManager.default
    
    func performTask(with request: APIRequest) {
        

        let headers = APIClient.httpsHeaders(with: request.authorizedToken)
        
        session.request(request.path, method: request.method,
                        parameters: request.parameter,
                        encoding: URLEncoding.default,
                        headers: headers)
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error):
                    request.resultCompletion?(.fail(error.localizedDescription))
                    
                case .success(let value):
                    if let json = value as? ResponseBody {
                        print(json)
                        let responseObj = APIResponse(json)
                                                
                        if responseObj.statusCode == 1 {

                            request.resultCompletion?(.success(responseObj))
                        } else if responseObj.statusCode == 3 {
                            if let loginVc = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
                                appDelegate.SetLoginRoot()
                            }
                        } else {
                            request.resultCompletion?(.fail(responseObj.message))
                        }
                    } else {
                        request.resultCompletion?(.fail(ResponseParseErrorMessage))
                    }
                }
        }
    }
    
    
    
    func performMultipartTask(with request: APIRequest) {
        
        let headers = APIClient.httpsHeaders(with: request.authorizedToken)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for item in request.multipartItems! {
                multipartFormData.append(item.data!,
                                         withName: item.name,
                                         fileName: item.filename,
                                         mimeType: item.mimeType.rawValue)
            }
            
            if let params = request.parameter {
                for (key, value) in params {
                    multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                }
            }
            
        }, to: request.path, method: .post, headers: headers) { (result) in
            
            switch result {
            case .failure(let error):
                request.resultCompletion?(.fail(error.localizedDescription))
                
            case .success(let upload, _, _) :
                
                upload.uploadProgress(closure: { (progress) in
                    let dict = ["upload" :progress.fractionCompleted]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Upload Progress"), object: dict)
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                upload.responseJSON { (response) in
                    switch response.result {
                    case .failure(let error ):
                        request.resultCompletion?(.fail(error.localizedDescription))
                        
                    case .success(let value):
                        if let json = value as? ResponseBody {
                            let response = APIResponse(json)
                            
                            if response.statusCode == 1 {
                                print(response.body ?? "")
                                request.resultCompletion?(.success(response))
                            } else if response.statusCode == 3 {
                                if let loginVc = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
                                    appDelegate.SetLoginRoot()
                                }
                            } else {
                                request.resultCompletion?(.fail(response.message))
                            }
                        } else {
                            request.resultCompletion?(.fail(ResponseParseErrorMessage))
                        }
                    }
                }
            }
        }
    }
    
    
    func performDownloadTask(with request: APIRequest) {
        
    }
    
    func performUploadTask(with endpoint: APIRequest) {
        
    }
    
    
    
    // class methods
    class func httpsHeaders(with token: String?) -> HTTPHeaders {
        var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        if let token = token {
            defaultHeaders["Authorization"] = "Bearer \(appDelegate.get_user_Data(Key: "token"))"//\(token)"
        }
        return defaultHeaders
    }
    
}


// MARK: - Helper Classes

struct APIResponse {
    var statusCode: Int = -1
    var body: ResponseBody?
    var message: String = ""
    
    init() {
        //
    }
    
    init(_ json: ResponseBody) {
        // handle response code and message
        // it may be different as per API development.
       
        var code = json["status"] as? Int
      
        // custom status can be handle here as per server response.
        //example
        if code == nil {
            let status = json["status"] as? String
            code = status?.lowercased() == "OK".lowercased() ? 1 : 0
        }
        
        // handle response message
        let msg = json["message"] as? String
        
        statusCode = code!
        body =  json
        message = msg ?? ""
    }
}
