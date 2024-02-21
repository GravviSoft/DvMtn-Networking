//
//  UsersViewController.swift
//  DMNetworkingIntro
//
//  Created by David Ruvinskiy on 4/10/23.
//
/**
 1. Create the user interface. See the provided screenshot for how the UI should look.
 2. Follow the instructions in the `User` file.
 3. Follow the instructions in the `NetworkManager` file.
 4. Create a variable called `users` and set it to an empty array of `User` objects.
 5. Connect the UITableView to the code. Create a function called `configureTableView` that configures the table view. You may find the `Constants` file helpful. Make sure to call the function in the appropriate spot.
 6. Set the `NetworkManager`'s delegate property to the `UsersViewController`. Have the `UsersViewController` conform to the `NetworkManagerDelegate` protocol. Call the `NetworkManager`'s `getUsers` function. In the `usersRetrieved` function, assign the `users` property to the array we got back from the API and call `reloadData` on the table view.
 */

import UIKit

class UsersViewController: UIViewController, NetworkManagerDelegate {

    var users = [User]()
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.delegate = self
        table.dataSource = self
        table.register(UINib(nibName: Constants.nibName, bundle: nil), forCellReuseIdentifier: Constants.userReuseID)
        NetworkManager.shared.getUsers()
    }
    
    
    //MARK: - API Response Error
    func userRetrievedError(error: Error) {
        print("Error pulling API Data: \(error)")
    }
    
    //MARK: - Api Response Data
    func usersRetrieved(_ networkManager: NetworkManager, response: [User]) {
        users = response
        DispatchQueue.main.async{
            self.table.reloadData()
        }
    }
}

//MARK: - TableView Data Source
extension UsersViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(users.count)
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.userReuseID, for: indexPath) as! UserViewCell
        let user = users[indexPath.row]
        cell.assignData(for: user)
        return cell
    }
}
