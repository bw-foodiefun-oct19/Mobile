//
//  APIController.swift
//  FoodieFun
//
//  Created by John Kouris on 10/17/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
}

class APIController {
    
    private let baseURL = URL(string: "https://backend-foodie-fun.herokuapp.com/api/")!
    var token: Token?
    
    //for local array from fetching experiences
    var experiences: [Experience] = []
    
    //TODO: - fix to use result type instead of just networkError
    func signUp(with user: User, completion: @escaping(Error?) -> Void) {
        
        let requestURL = baseURL
            .appendingPathComponent("auth")
            .appendingPathComponent("register")
        
        // Build the request
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        // Tell the API that the body is in JSON format
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        
        do {
            let userJSON = try encoder.encode(user)
            request.httpBody = userJSON
        } catch {
            completion(error)
        }
        
        // Perform the request (data task)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Handle errors
            if let error = error {
                NSLog("Error signing up user: \(error)")
                completion(error)
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(error)
            }
            
            // nil means there was no error, everything succeeded
            completion(nil)
        }.resume()
        
    }
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        let requestURL = baseURL
            .appendingPathComponent("auth")
            .appendingPathComponent("login")
        
        var request = URLRequest(url: requestURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error encoding user for sign in: \(error)")
            completion(error)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error signing in user: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                let statusCodeError = NSError(domain: "com.JohnKouris.AnimalSpotter", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                let noDataError = NSError(domain: "com.JohnKouris.AnimalSpotter", code: -1, userInfo: nil)
                completion(noDataError)
                return
            }
            
            do {
                let token = try JSONDecoder().decode(Token.self, from: data)
                self.token = token
            } catch {
                NSLog("Error decoding the bearer token: \(error)")
                completion(error)
            }
            
            completion(nil)
        }.resume()
    }
    
    //Creating Experience - POST - requried fields -> item_name
    func createExperience(for itemName: String, restaurantName: String, restaurantType: String, itemPhoto: String, foodRating: Int, itemComment: String, waitTime: String, dateVisited: Date, completion:@escaping(Error?)->()) {
    
        //change id and userID in experience to be optional and id and userID here to be nil
        let experience = Experience(id: 0, restaurantName: restaurantName, restaurantType: restaurantType, itemName: itemName, itemPhoto: itemPhoto, foodRating: foodRating, itemComment: itemComment, waitTime: waitTime, dateVisited: Date(), userID: 0)
        
        //POST
        let createExperienceURL = self.baseURL.appendingPathComponent("meals")
        
        guard let bearer = self.token else {
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: createExperienceURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(bearer.token, forHTTPHeaderField: "Authorization")
        
        let jsonEncoder = JSONEncoder()
        
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        
        do {
            let jsonData = try jsonEncoder.encode(experience)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user objects: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let _ = error {
                completion(NSError())
                return
            }
            self.experiences.append(experience)
            completion(nil)
            }.resume()
    }
}
