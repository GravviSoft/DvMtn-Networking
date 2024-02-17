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

protocol NetworkManagerDelegate{
    func usersRetrieved(_ networkManager: NetworkManager, response: [Data])
    func userRetrievedError(error: Error)
}

class NetworkManager {
    static let shared = NetworkManager()
    private let baseUrl = "https://reqres.in/api/"
    
//    private init() {}
    var delegate: NetworkManagerDelegate?

    var usersResponse = [Data]()
    func getUsers() {
        
        let apiURL = "\(baseUrl)users"
        print(apiURL)
        if let url = URL(string: apiURL){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let safeError = error{
                    self.delegate?.userRetrievedError(error: safeError)
                }
                if let safeData = data{
                    let decoder = JSONDecoder()
                    do{
                        let decodeData = try decoder.decode(User.self, from: safeData)
                        for i in decodeData.data.indices{
                            let id = decodeData.data[i].id
                            let email = decodeData.data[i].email
                            let first = decodeData.data[i].first_name
                            let last = decodeData.data[i].last_name
                            let avatar = decodeData.data[i].avatar
                            let userApiData = Data(id: id, email: email, first_name: first, last_name: last, avatar: avatar)
                            print(userApiData)
                            self.usersResponse.append(userApiData)
                        }
                        self.delegate?.usersRetrieved(self, response: self.usersResponse)
                    }catch{
                        print("Error decoding data ")
                        self.delegate?.userRetrievedError(error: error)
                    }
                }
            }
            task.resume()
        }
    }
}
