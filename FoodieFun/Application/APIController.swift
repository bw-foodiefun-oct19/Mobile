//
//  APIController.swift
//  FoodieFun
//
//  Created by John Kouris on 10/17/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation
import CoreData

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
    
//    init() {
//        fetchExperiencesFromServer()
//    }
    
    private let baseURL = URL(string: "https://backend-foodie-fun.herokuapp.com/api/")!
    var token: Token?
    
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
                let statusCodeError = NSError(domain: "com.LambdaSchool.FoodieFun2", code: response.statusCode, userInfo: nil)
                completion(statusCodeError)
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                let noDataError = NSError(domain: "com.LambdaSchool.FoodieFun2", code: -1, userInfo: nil)
                completion(noDataError)
                return
            }
            
            do {
                let token = try JSONDecoder().decode(Token.self, from: data)
                self.token = token
                self.fetchExperiencesFromServer()
            } catch {
                NSLog("Error decoding the bearer token: \(error)")
                completion(error)
            }
            
            completion(nil)
        }.resume()
    }
    
    @discardableResult func createExperience(id: Int? = nil,
                                             userID: Int? = nil,
                                             itemName: String,
                                             restaurantName: String?,
                                             restaurantType: String?,
                                             itemPhoto: String?,
                                             foodRating: Int?,
                                             itemComment: String?,
                                             waitTime: String?,
                                             dateVisited: String?) -> Experience {
        let experience = Experience(restaurantName: restaurantName,
                                    restaurantType: restaurantType,
                                    itemName: itemName,
                                    itemPhoto: itemPhoto,
                                    foodRating: foodRating,
                                    itemComment: itemComment,
                                    waitTime: waitTime,
                                    dateVisited: dateVisited,
                                    context: CoreDataStack.shared.mainContext)
        post(experience: experience)
        CoreDataStack.shared.save()
        return experience
    }
    
    func delete(experience: Experience) {
        CoreDataStack.shared.mainContext.delete(experience)
        CoreDataStack.shared.save()
    }
    
    func fetchExperiencesFromServer(completion: @escaping (Error?)-> Void = { _ in }) {
        guard let token = token else {
            print("there is no bearer for fetchingMeals")
            return
        }
        
        let instructorURL = self.baseURL.appendingPathComponent("meals")
        
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
            
            do {
                let decoder = JSONDecoder()
                let experienceRepresentations = try decoder.decode([ExperienceRepresentation].self, from: data)
                self.updateExperiences(with: experienceRepresentations)
            } catch {
                NSLog("Error decoding experience objects: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    func updateExperience(experience: Experience,
                          itemName: String,
                          restaurantName: String?,
                          restaurantType: String?,
                          itemPhoto: String?,
                          foodRating: Int?,
                          itemComment: String?,
                          waitTime: String?,
                          dateVisited: String?) {
        experience.itemName = itemName
        experience.restaurantName = restaurantName
        experience.restaurantType = restaurantType
        experience.itemPhoto = itemPhoto
        experience.foodRating = Int16(foodRating ?? 0)
        experience.itemComment = itemComment
        experience.waitTime = waitTime
        experience.dateVisited = dateVisited
        
        post(experience: experience)
        CoreDataStack.shared.save()
    }
    
    func updateExperiences(with representations: [ExperienceRepresentation]) {
        let identifiersToFetch = representations.compactMap( {$0.id} )
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var experiencesToCreate = representationsByID
        
        let context = CoreDataStack.shared.mainContext
        context.performAndWait {
            do {
                let fetchRequest: NSFetchRequest<Experience> = Experience.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
                
                let existingExperiences = try context.fetch(fetchRequest)
                
                for experience in existingExperiences {
                    let id = Int(experience.id)
                    guard let representation = representationsByID[id] else { continue }
                    
                    experience.itemName = representation.itemName
                    experience.restaurantName = representation.restaurantName
                    experience.restaurantType = representation.restaurantType
                    experience.itemPhoto = representation.itemPhoto
                    experience.foodRating = Int16(representation.foodRating ?? 0)
                    experience.itemComment = representation.itemComment
                    experience.waitTime = representation.waitTime
                    experience.dateVisited = representation.dateVisited
                    
                    experiencesToCreate.removeValue(forKey: id)
                }
                
                for representation in experiencesToCreate.values {
                    Experience(experienceRepresentation: representation, context: context)
                }
                
                CoreDataStack.shared.save(context: context)
            } catch {
                print("Error fetching experiences from persistent store: \(error)")
            }
        }
    }
    
    func post(experience: Experience, completion: @escaping () -> Void = {}) {
        guard let token = self.token else {
            completion()
            return
        }
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        let requestURL = baseURL.appendingPathComponent("meals")
        var request = URLRequest(url: requestURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token.token, forHTTPHeaderField: "Authorization")
        request.httpMethod = HTTPMethod.post.rawValue
        
        guard let experienceRepresentation = experience.experienceRepresentation else {
            print("Experience representation is nil")
            completion()
            return
        }
        
        do {
            request.httpBody = try encoder.encode(experienceRepresentation)
        } catch {
            print("Error encoding experience representation: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("Error POSTing experience: \(error)")
                completion()
                return
            }
            completion()
        }.resume()
    }
    
}
