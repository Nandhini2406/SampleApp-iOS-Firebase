//
//  AllDetailsScreen.swift
//  SampleApp
//
//  Created by DoodleBlue on 19/07/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class AllDetailsScreen: UIViewController {
    
    
    // MARK: -  Outlets & Actions
    @IBOutlet weak var AllUsersTableView: UITableView!
    
    @IBAction func backToSignUpScreenBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: -  LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
       
        self.AllUsersTableView.delegate = self
        self.AllUsersTableView.dataSource = self
        
        AllUsersTableView.register(UINib(nibName: "UserDataTableViewCell", bundle: nil), forCellReuseIdentifier: "UserDataTableViewCell")
    
    }
    
    // MARK: -  Firebase Methods
    func getData(){
        let ref = Firestore.firestore()
        ref.collection("UserDetails").getDocuments { snapshot, error in
            if error == nil{
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        userData = snapshot.documents.map{ doc in
                            return UserDetail(id: doc.documentID,
                                              name: doc["Name"] as? String ?? "",
                                              age: doc["Age"] as? String ?? "",
                                              mobileNo: doc["Mobile Number"] as? String ?? "",
                                              mailId: doc["Email Address"] as? String ?? "",
                                              gender: doc["Gender"] as? String ?? "",
                                              language: doc["Language"] as? String ?? "")
                            }
                        self.AllUsersTableView.reloadData()
                        }
                    }
                }
            else {
                print("Error retrieving documents: \(error?.localizedDescription)")
            }
        }
        
    }
    
    func deleteDocument(at indexPath: IndexPath) {
        let user = userData[indexPath.row]
        let db = Firestore.firestore()
        let docRef = db.collection("UserDetails").document(user.id)
        
        docRef.delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed from Firestore!")
                DispatchQueue.main.async {
                    userData.remove(at: indexPath.row)
                    self.AllUsersTableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
}

// MARK: - TableView Methods
extension AllDetailsScreen: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Count...\(userData.count)")
        return userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserDataTableViewCell") as? UserDataTableViewCell
        let name = userData[indexPath.row].name
        cell?.DataLbl.text = name
        print("ID...\(userData[indexPath.row].id)")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Cell Selected...\(selectedItem)")
        let vc = storyboard?.instantiateViewController(withIdentifier: "EditUserDataScreen") as? EditUserDataScreen
        selectedItem = indexPath.row
       
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            // Delete user details from Firestore
            self.deleteDocument(at: indexPath)
            completion(true)
        }
    
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .lightGray
    
        return UISwipeActionsConfiguration(actions: [deleteAction])
    
    }

}



// MARK: - Negative Cases

//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
//            let ref = Firestore.firestore()
//            ref.collection("UserDetails").document().delete { error in
//                if error == nil{
//                    DispatchQueue.main.async {
//                      self.userData.remove(at: indexPath.row)
////                        self.AllUsersTableView.deleteRows(at: [indexPath], with: .fade)
//                        self.deleteDocument(at: indexPath)
//                        tableView.deleteRows(at: [indexPath], with: .fade)
//                        completion(true)
//                        self.AllUsersTableView.reloadData()
//
//                    }
//                } else {
//                    print("Error while deleting: \(error?.localizedDescription)")
//                }
//            }
//        }
//        deleteAction.image = UIImage(systemName: "trash")
//        deleteAction.backgroundColor = .lightGray
//        let config = UISwipeActionsConfiguration(actions: [deleteAction])
//        return config
//    }
    
//    let user = self.userData[indexPath.row]
//    let ref = Firestore.firestore()
//    ref.collection("UserDetails").document().delete { error in
//        if let error = error {
//            print("Error deleting user: \(error)")
//        } else {
//            self.userData.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
//
//
    
//func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
    // Delete user details from Firebase Realtime Database
//    let user = self.userData[indexPath.row]
//    let ref = Firestore.firestore()
//    ref.collection("UserDetails").document().delete { error in
//        if let error = error {
//            print("Error deleting user: \(error)")
//        } else {
//            self.userData.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
//}
//
//deleteAction.image = UIImage(systemName: "trash")
//deleteAction.backgroundColor = .lightGray
//
//return UISwipeActionsConfiguration(actions: [deleteAction])
//}

//
//    func deleteDocument(at indexPath: IndexPath) {
//            let user = userData[indexPath.row]
//            let db = Firestore.firestore()
//            let docRef = db.collection("users").document(user.id)
//            docRef.delete { error in
//                if let error = error {
//                    print("Error removing document: \(error)")
//                } else {
//                    print("Document successfully removed!")
//                    do {
//                        try DispatchQueue.main.async {
//                        self.userData.removeAll { dat in
//                        return dat.id == user.id
//                            print("user id..\(user.id)")
//                            self.AllUsersTableView.deleteRows(at: [indexPath], with: .fade)
//                        }
//
//                    }
//                    } catch{
//                        print("Erroring....: \(error)")
//                    }
//                    //self.AllUsersTableView.reloadData()
//                }
//            }
////          self.userData.remove(at: indexPath.row)
////          self.AllUsersTableView.deleteRows(at: [indexPath], with: .fade)
//    }

        
//    func deleteDocument(at indexPath: IndexPath){
//        let db = Firestore.firestore()
//        let docId = userData[indexPath.row].id
//        db.collection("UserDetails").document(docId).delete{ error in
//            if error == nil{
//
//                DispatchQueue.main.async {
//                    self.userData.removeAll { dat in
//                        return dat.id == self.userData[indexPath.row].id
//                    }
//                    self.AllUsersTableView.reloadData()
//                }
//
//            } else {
//                print("Error while deleting: \(error?.localizedDescription)")
//            }
//        }
//    }
//}

//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
//            let ref = Firestore.firestore()
//            ref.collection("UserDetails").document().delete { error in
//                if error == nil{
//                    DispatchQueue.main.async {
//                      self.userData.remove(at: indexPath.row)
////                        self.AllUsersTableView.deleteRows(at: [indexPath], with: .fade)
//                        self.deleteDocument(at: indexPath)
//                        tableView.deleteRows(at: [indexPath], with: .fade)
//                        completion(true)
//                        self.AllUsersTableView.reloadData()
//
//                    }
//                } else {
//                    print("Error while deleting: \(error?.localizedDescription)")
//                }
//            }
//        }
//        deleteAction.image = UIImage(systemName: "trash")
//        deleteAction.backgroundColor = .lightGray
//        let config = UISwipeActionsConfiguration(actions: [deleteAction])
//        return config
//    }
    
//    let user = self.userData[indexPath.row]
//    let ref = Firestore.firestore()
//    ref.collection("UserDetails").document().delete { error in
//        if let error = error {
//            print("Error deleting user: \(error)")
//        } else {
//            self.userData.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
//
//
    
//func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
    // Delete user details from Firebase Realtime Database
//    let user = self.userData[indexPath.row]
//    let ref = Firestore.firestore()
//    ref.collection("UserDetails").document().delete { error in
//        if let error = error {
//            print("Error deleting user: \(error)")
//        } else {
//            self.userData.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
//}
//
//deleteAction.image = UIImage(systemName: "trash")
//deleteAction.backgroundColor = .lightGray
//
//return UISwipeActionsConfiguration(actions: [deleteAction])
//}





