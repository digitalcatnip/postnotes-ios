//
//  NetworkManager.swift
//  Post Notes
//
//  Created by James McCarthy on 1/11/17.
//  Copyright © 2017 Digital Catnip. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

import Foundation

//For error handling purposes, let's define a few
//macros
//FYI - PN is short for Post Notes
enum PNNetworkError : String, Error {
    case NoError = ""
    case InvalidURL = "Invalid endpoint"
    case NoData = "Invalid data"
    case JSONFormat = "Invalid json"
    case MajorError = "Internal error"
    case AuthorizeError = "Cannot construct authorization key"
    case InvalidParams = "Invalid URL parameters"
    case InBackground = "The App is currently in the background"
}


class NetworkManager {
    static let apiKey = ""
    static let apiURL = "";
    static var hasInitialized = false
    static var inBackground = false
    static var session = URLSession.shared

    class func initializeSession() {
        configureSession()
        hasInitialized = true
        inBackground = false
    }
    
    //This function sets the Api-Key header on our HTTP request
    //so that the api key is sent on every request and we don't have
    //to always set it.
    class func configureSession() {
        let config = URLSessionConfiguration.default
        let dict = ["Api-Key": apiKey];
        if hasInitialized {
            session.finishTasksAndInvalidate()
        }
        config.httpAdditionalHeaders = dict
        session = URLSession(configuration: config)
    }
    
    //This function sends the fully formed HTTP request to the Post Notes server,
    //then parses the JSON response and passes it to the handler
    class func sendRequest(request:NSMutableURLRequest, handler:@escaping (NSDictionary, PNNetworkError) -> Void) {
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            do {
                guard let dat = data else { throw PNNetworkError.NoData }
                //For debugging, uncomment this to print out the actual unparsed JSON
                //if let s = NSString(data: dat, encoding: NSUTF8StringEncoding) {
                //     print("Response: \(s)")
                //}
                guard let json = try JSONSerialization.jsonObject(with: dat, options: []) as? NSDictionary else { throw PNNetworkError.JSONFormat }
                handler(json, PNNetworkError.NoError)
            } catch let error as PNNetworkError {
                handler(NSDictionary(), error)
            } catch {
                print(error);
                handler(NSDictionary(), PNNetworkError.MajorError);
            }
        }.resume()
    }
    
    //This function forms the HTTP GET request and then calls sendRequest
    class func getEndPoint(endpoint:String, parameters: String, handler: @escaping (NSDictionary, PNNetworkError)->Void) throws {
        let fullURL = URL(string:"\(NetworkManager.apiURL)/\(endpoint)?\(parameters)")
        if let url = fullURL {
            //Uncomment this to debug your request
            //print("Query is " + url.absoluteString)
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "GET"
            sendRequest(request: request, handler: handler)
        } else {
            throw PNNetworkError.InvalidURL
        }
    }
    
    //This function lets you specify an endpoint on the server (like "/notes"), any parameters,
    //and a callback.  It then makes the GET network call for you.  The handler gets called when
    //the network call is complete.
    class func GET(endpoint:String, parameters:[String: AnyObject], handler: @escaping (NSDictionary,PNNetworkError) -> Void) throws {
        let paramString = parameters.stringFromHttpParameters()
        try getEndPoint(endpoint: endpoint, parameters: paramString, handler: handler)
    }
    
    class func putEndPoint(endpoint:String, contentType: String, parameters:String, handler: @escaping (NSDictionary,PNNetworkError) -> Void) throws {
        if inBackground {
            throw PNNetworkError.InBackground
        }
        if let fullURL = URL(string: "\(NetworkManager.apiURL)/\(endpoint)") {
            //Uncomment this to debug your request
            //print("Query is " + fullURL.absoluteString)
            //print("Parameters are " + parameters)
            let request = NSMutableURLRequest(url: fullURL)
            request.httpMethod = "PUT"
            request.httpBody = parameters.data(using: String.Encoding.utf8)
            request.addValue(contentType, forHTTPHeaderField: "content-type")
            sendRequest(request: request, handler: handler)
        } else {
            throw PNNetworkError.InvalidURL
        }
    }
    
    //This function lets you specify an endpoint on the server (like "/note/new"), any parameters,
    //and a callback.  It then makes the PUT network call for you.  The handler gets called when
    //the network call is complete.
    class func PUT(endpoint:String, parameters:[String: AnyObject], handler: @escaping (NSDictionary, PNNetworkError) -> Void) throws {
        let contentType = "application/x-www-form-urlencoded; charset=utf-8"
        let paramString = parameters.stringFromHttpParameters()
        try putEndPoint(endpoint: endpoint, contentType: contentType, parameters: paramString, handler: handler)
    }
}
