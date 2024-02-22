//
//  NetworkManager.swift
//  DMNetworkingIntro
//
//  Created by David Ruvinskiy on 4/10/23.
/**
 3.1 Create a protocol called `NetworkManagerDelegate` that contains a function called `usersRetrieved`.. This function should accept an array of `User` and should not return anything.
 3.2 Create a variable called `delegate` of type optional `NetworkManagerDelegate`. We will be using the delegate to pass the `Users` to the `UsersViewController` once they come back from the API.
 3.3 Makes a request to the API and decode the JSON that comes back into a `UserResponse` object.
 3.4 Call the `delegate`'s `usersRetrieved` function, passing the `data` array from the decoded `UserResponse`.
 This is a tricky function, so some starter code has been provided.
 3.3 Append the "/users" endpoint to the base URL and store the result in a variable. You should end up with this String: //"https://reqres.in/api/users".
 3.3 Create a `URL` object from the String. If the `URL` is nil, break out of the function.
 */

import Foundation
import UIKit

//protocol NetworkManagerDelegate{
//    func usersRetrieved(_ networkManager: NetworkManager, response: [User])
//    func userRetrievedError(error: Error)
//}

class NetworkManager {
    static let shared = NetworkManager()
    private let baseUrl = "https://reqres.in/api/"
    
    private init() {}
//    var delegate: NetworkManagerDelegate?

    func getUsers(completion: @escaping (Result<[User], DMError>) -> ()) {
        
        let apiURL = "\(baseUrl)users"
//        let apiURL = ""
        
        guard let url = URL(string: apiURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            //Handle Errors
            if error != nil{
                completion(.failure(.unableToComplete))
            }
            
            //Handle Data
            guard let safeData = data else{
                completion(.failure(.invalidData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do{
                let decodeData = try decoder.decode(UserResponse.self, from: safeData)
//                self.delegate?.usersRetrieved(self, response: decodeData.data)
                completion(.success(decodeData.data))
            }catch{
                completion(.failure(.invalidResponse))
//                self.delegate?.userRetrievedError(error: error)
            }
        }
        
        task.resume()
}
    

    func getAvatar(for user: User, closure: @escaping (UIImage?) -> ()){
        
        guard let url = URL(string: user.avatar) else {
            closure(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let safeData = data else {
                closure(nil)
                return
            }
            let image = UIImage(data: safeData)
            closure(image)
        }
        
        task.resume()
    }
}

