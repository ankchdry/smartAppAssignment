//
//  ApiClient.swift
//  AssignmentSmartApp
//
//  Created by Ankit Chaudhary on 14/05/20.
//  Copyright © 2020 spectorAi. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire


class ApiClient {
    
    struct GenericResponse<T: Codable>: Codable {
        var data: T?
        var status:Int?
        var message:String?
    }
    
    // Default Session Manager.
    static let AF = SessionManager.default
    
    // Login API
    static func fetchTopRatedMovies() -> Observable<MovieListModel>  {
        return request(ApiRouter.getTopRatedItems)
    }
    
    static func fetchNowPlayingMovies() -> Observable<MovieListModel> {
        return request(ApiRouter.getNowPlayingItems)
    }
    
    
    //-------------------------------------------------------------------------------------------------
    //MARK: - The request function to get results in an Observable
    private static func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        //Create an RxSwift observable, which will be the one to call the request when subscribed to
        return Observable<T>.create { observer in
            //Trigger the HttpRequest using AlamoFire (AF)
            let request = AF.request(urlConvertible).responseJSON { (response: DataResponse<Any>) in
                //Check the result from Alamofire's response and check if it's a success or a failure
                switch response.result {
                case .success( _):
                    //Everything is fine, return the value in onNext
                    let data = try! JSONDecoder.init().decode(T.self, from: response.data!)
                    observer.onNext(data)
                    observer.onCompleted()
                    
                case .failure(let error):
                    //Something went wrong, switch on the status code and return the error
                    switch response.response?.statusCode {
                    case 401:
                        observer.onError(ApiError.invalidUser)
                    case 403:
                        observer.onError(ApiError.forbidden)
                    case 404:
                        observer.onError(ApiError.notFound)
                    case 409:
                        observer.onError(ApiError.conflict)
                    case 500:
                        observer.onError(ApiError.internalServerError)
                    default:
                        observer.onError(error)
                    }
                }
            }
            
            //Finally, we return a disposable to stop the request
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

