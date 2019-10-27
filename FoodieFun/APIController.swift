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
    
    var allMeals: [Meal] = []
    
    var token: String?
    let tokenFromUserDefaults = UserDefaults.standard.string(forKey: .saveToken)
    
    private let baseUrl = URL(string: "https://backend-foodie-fun.herokuapp.com/api/")!
    
    
    //Sign up - POST
    func signUp(with user: User, completion: @escaping (Error?)-> Void) {
        let signUpURL = baseUrl.appendingPathComponent("auth/register")
        
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
            print("passed sign up")
        }.resume()
    }
    
    //SignIn - POST  - requried fields -> username, password
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        let signInURL = baseUrl.appendingPathComponent("auth/login")
        
        //        let clientURL = baseUrl.appendingPathComponent("client-register")
        
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
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
            
            do {
                let bearerSignIn = try jsonDecoder.decode(BearerSignIn.self, from: data)
                self.token = bearerSignIn.token
                
                let userDefaults = UserDefaults.standard
                //this saves token into bearerSignIn
                userDefaults.set(self.token, forKey: .saveToken)
                
                
                print(self.token!)
                completion(nil)
                
            } catch {
                NSLog("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    //FetchingMeals - GET - requried fields -> username, password and token
    func fetchMeals(completion: @escaping (Error?)-> Void) {
        
        if let tokenFromUserDefaults = self.tokenFromUserDefaults {
            self.token = tokenFromUserDefaults
        }
        
        guard let token = self.token else {
            print("there is no token from initial login")
            return
        }
    
        
        
        let instructorURL = baseUrl.appendingPathComponent("meals")
        
        var request = URLRequest(url: instructorURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
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
                let allMeals = try jsonDecoder.decode([Meal].self, from: data)
                
                /*
                 it seems like backend is not designed to combine all experiences (meals) from all users
                 myMeals for each user
                 let userID = self.bearer?.id
                 let myMeals = fitnessClasses.filter{$0.id == userID}
                 self.meals = myMeals
                 */
                
                //all meals from all users
                self.allMeals = allMeals
                
                completion(nil)
            } catch {
                NSLog("Error decoding meals objects: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    //Creating Meals - POST - requried fields -> item_name
    func createMeal(for itemName: String, restaurantName: String, itemPhoto: String?, foodRating: Int?, comment: String, completion:@escaping(Error?)->()) {
        
        //dateFormatter for dateVisited
        //        let formatter = DateFormatter()
        //        formatter.dateStyle = .medium
        //        formatter.timeStyle = .none
        //
        //        formatter.locale = Locale(identifier: "en_US")
        //        let dateString = formatter.string(from: Date())
        //        print(dateString)
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let dateString = dateFormatter.string(from: Date())
        print(dateString)
        
        
        let meal = Meal(id: nil, restaurantName: restaurantName, itemName: itemName, itemPhoto: nil, foodRating: foodRating, itemComment: comment, dateVisited: dateString, userId: nil)
        
        //POST
        let createMealURL = self.baseUrl.appendingPathComponent("meals")
        
        guard let token = self.token else {
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: createMealURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        let jsonEncoder = JSONEncoder()
        
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        
        do {
            let jsonData = try jsonEncoder.encode(meal)
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
            self.allMeals.append(meal)
            completion(nil)
        }.resume()
    }
    
    //Updating meals - PUT - meals/id# for this specifi meal
    func updateMeal(for meal: Meal, changeitemNameto: String, changerestaurantNameto: String, changeitemPhototo: String, changefoodRatingto: Int?, changeitemCommentto: String, completion:@escaping (Error?)->Void) {
        
        //making sure passed meal exists in array of allMeals
        guard let index = self.allMeals.firstIndex(of: meal) else {return}
        self.allMeals[index].itemName = changeitemNameto
        //        self.allMeals[index].restaurantName = changerestaurantNameto!
        //        self.allMeals[index].restaurantType = changerestaurantTypeto!
        //add more change update as needed
        
        //let updatedClass = fitnessClasses[index]
        //PUT
        guard let mealID = meal.id else {return}
        
        let updateMealURL = self.baseUrl.appendingPathComponent("meals/\(mealID)")
        
        //creating its own json file for name change
        
        let params = ["item_name": changeitemNameto, "restaurant_name": changerestaurantNameto, "food_rating": changefoodRatingto ?? 0, "item_comment": changeitemCommentto] as [String: Any]
        let json = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        
        
        guard let token = self.token else {
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: updateMealURL)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        //request httpBody of our own json format
        request.httpBody = json
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                print(error)
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    //Delete
    func deleteMeal(for meal: Meal, completion: @escaping (Error?) -> Void) {
        
        //Delete locally
        guard let index = self.allMeals.firstIndex(of: meal) else {return}
        self.allMeals.remove(at: index)
        
        guard let mealID =  meal.id else {return}
        
        let deleteMealURL = baseUrl.appendingPathComponent("meals/\(mealID)")
        
        
        guard let token = self.token else {
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: deleteMealURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                    return
                }
            }
            
            if let error = error {
                print(error)
                return
            }
            completion(nil)
        }.resume()
    }
}
