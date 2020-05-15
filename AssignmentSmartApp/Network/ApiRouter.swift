//
//  ApiRouter.swift
//  AssignmentSmartApp
//
//  Created by Ankit Chaudhary on 14/05/20.
//  Copyright © 2020 spectorAi. All rights reserved.
//

import Foundation
import Alamofire

enum ApiRouter: URLRequestConvertible {
    enum ParameterType { case url, params, slashUrl }
    
    // API Request Enums
    case getNowPlayingItems
    case getTopRatedItems
    
    func asURLRequest() throws -> URLRequest {
        let url = try NetworkConstants.baseUrl.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        //Http method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(NetworkConstants.ContentType.json.rawValue, forHTTPHeaderField: NetworkConstants.HttpHeaderField.contentType.rawValue)

        // Attach API Key here.
        
        
        //Encoding
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        // Append API key to url
        urlRequest.url = URL.init(string: (urlRequest.url?.absoluteString ?? "") + "?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        
        if parameters?.1 == .params {
            return try encoding.encode(urlRequest, with: parameters?.0)
        }
        
        if parameters?.1 == .slashUrl {
            urlRequest.url = URL.init(string: (urlRequest.url?.absoluteString ?? "") + (parameters?.0?.first?.value as? String ?? ""))
        } else {
            let urlParams = parameters?.0?.reduce("", { (finalString, dict) -> String in
                var result = finalString
                result += (result.isEmpty ? "?" : "&") + (dict.key + "=" + (dict.value as! String))
                return result
            })
            urlRequest.url = URL.init(string: (urlRequest.url?.absoluteString ?? "") + (urlParams ?? ""))!
        }
        
        return try encoding.encode(urlRequest, with: nil)
    }
    
    //MARK: - HttpMethod
    //This returns the HttpMethod type. It's used to determine the type if several endpoints are peresent
    private var method: HTTPMethod {
        switch self {
        case .getNowPlayingItems:
            return .get
        case .getTopRatedItems:
            return .get
        }
    }
    
    //MARK: - Path
    private var path: String {
        switch self {
        case .getNowPlayingItems:
            return "/movie/now_playing"
        case .getTopRatedItems:
            return "/movie/top_rated"
        }
    }
    
    //MARK: - Parameters
    //This is the queries part, it's optional because an endpoint can be without parameters
    private var parameters: (Parameters?, ParameterType)?  {
        switch self {
        case .getNowPlayingItems:
            return nil
            
        case .getTopRatedItems:
            return nil
        }
    }
}


