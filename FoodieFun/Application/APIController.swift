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
    
    var allExperiences: [Experience] = []
    
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
    
    
    
    
    
      //FetchingMeals - GET - requried fields -> username, password and token
       func fetchExperiences(completion: @escaping (Error?)-> Void) {
           
           guard let token = token else {
               print("there is no bearer for fetchingMeals")
               return
           }
           
           
           let instructorURL = baseURL.appendingPathComponent("meals")
           
           var request = URLRequest(url: instructorURL)
           request.httpMethod = HTTPMethod.get.rawValue
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           request.addValue(token.token, forHTTPHeaderField: "Authorization")
           
           URLSession.shared.dataTask(with: request) { (data, response, error) in
               if let response = response as? HTTPURLResponse,
                   response.statusCode != 200 {
                   completion(error)
                   return
               }
               
               if let error = error {
                   completion(error)
                   return
               }
               
               guard let data = data else {
                   completion(error)
                   return
               }
               
               let jsonDecoder = JSONDecoder()
               
               jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
               
               do {
                   let allExperiences = try jsonDecoder.decode([Experience].self, from: data)
                   
                   /*
                   it seems like backend is not designed to combine all experiences (meals) from all users
                   myMeals for each user
                   let userID = self.bearer?.id
                   let myMeals = fitnessClasses.filter{$0.id == userID}
                   self.meals = myMeals
                   */
                   
                   //all meals from all users
                   self.allExperiences = allExperiences
    
                   completion(nil)
               } catch {
                   NSLog("Error decoding animal objects: \(error)")
                   completion(error)
                   return
               }
               }.resume()
       }
    
}
