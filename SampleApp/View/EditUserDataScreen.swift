//
//  SignUpScreen.swift
//  SampleApp
//
//  Created by DoodleBlue on 13/07/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class EditUserDataScreen: UIViewController {
    
    // MARK: - Outlets & Actions
    
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var ageTxtField: UITextField!
    @IBOutlet weak var mobileNoTxtField: UITextField!
    @IBOutlet weak var emailIdTxtField: UITextField!
    @IBOutlet weak var genderTxtField: UITextField!
    @IBOutlet weak var languageTxtField: UITextField!
    
    @IBAction func backToSignUpScreenBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateDataInFirebaseBtn(_ sender: Any) {
    
        updateDateToFirebase()
        showToast(message: "User Details Updated Successfully")
    }
    
    @IBAction func goToSignUpScreenBtn(_ sender: Any) {
        
        let vc = navigationController?.viewControllers.filter({$0 is SignUpScreen}).first
        self.navigationController?.popToViewController(vc!, animated: true)
    }
    
    // MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
       
    }
    
    // MARK: - SetUp methods
    func setUpUI(){
        self.navigationController?.isNavigationBarHidden = true
        
        DispatchQueue.main.async {
            let userModel = userData[selectedItem]
            self.nameTxtField.text = userModel.name
            self.ageTxtField.text = userModel.age
            self.mobileNoTxtField.text = userModel.mobileNo
            self.emailIdTxtField.text = userModel.mailId
            self.genderTxtField.text = userModel.gender
            self.languageTxtField.text = userModel.language
        }
        
        self.getData()
        print("Trrr....\(userData)")
        
    }

    func updateDateToFirebase(){
        
        guard let name = nameTxtField.text,
              let age = ageTxtField.text,
              let mobileNo = mobileNoTxtField.text,
              let mailId = emailIdTxtField.text,
              let gender = genderTxtField.text,
              let language = languageTxtField.text else {
            return
        }
        let ref = Firestore.firestore()
        let docId = userData[selectedItem].id
        ref.collection("UserDetails").document(docId).updateData(["Name": name, "Age": age, "Mobile Number": mobileNo, "Email Address": mailId, "Gender": gender, "Language": language]){ error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.getData()
                }
                print("Document successfully updated!")
            }
        }
    }
    
    
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
                        }
                    }
                }
            else {
                print("Error retrieving documents: \(String(describing: error?.localizedDescription))")
            }
        }
    }

func showToast(message: String) {
    let toastController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    self.present(toastController, animated: true, completion: nil)
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        toastController.dismiss(animated: true, completion: nil)
        
    }
    }
}



// MARK: -  Negative cases



//func getData(completion: [UserDetail]?){
//    let ref = Firestore.firestore()
//    ref.collection("UserDetails").getDocuments { snapshot, error in
//        if error == nil{
//            if let snapshot = snapshot {
//
//                let data = snapshot.documents.map{ doc in
//
//                    return UserDetail(id: doc.documentID,
//                                          name: doc["Name"] as? String ?? "",
//                                          age: doc["Age"] as? String ?? "",
//                                          mobileNo: doc["Mobile Number"] as? String ?? "",
//                                          mailId: doc["Email Address"] as? String ?? "",
//                                          gender: doc["Gender"] as? String ?? "",
//                                          language: doc["Language"] as? String ?? "")
//
//                }
//                self.userData = data
//                print("forrr....\(self.userData)")
//            }
//
//        }
//        else {
//            print("Error retrieving documents: \(error?.localizedDescription)")
//        }
//    }
//    print("Data....\(self.userData)")
//}






//    extension EditUserDataScreen: UITableViewDelegate, UITableViewDataSource{
//
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return dataLabel.count
//
//        }
//
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "UserDataTableViewCell", for: indexPath) as? UserDataTableViewCell
//            cell?.DataLbl.text = dataLabel[indexPath.row]
//
//            if selectedItem != nil{
//            switch indexPath.row {
//                case 0:
//                    cell?.userInputData.text = userData[selectedItem!].name
//                case 1:
//                    cell?.userInputData.text = userData[selectedItem!].age
//                case 2:
//                    cell?.userInputData.text = userData[selectedItem!].mobileNo
//                case 3:
//                    cell?.userInputData.text = userData[selectedItem!].mailId
//                case 4:
//                    cell?.userInputData.text = userData[selectedItem!].gender
//                case 5:
//                    cell?.userInputData.text = userData[selectedItem!].language
//                default:
//                    cell?.userInputData.text = ""
//                }
//            }
//
//            return cell!
//        }
//    }


//func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
//        // Delete user details from Firebase Realtime Database
//        let user = self.userData[indexPath.row]
//        let ref = Firestore.firestore()
//        ref.collection("UserDetails").document().delete { error in
//            if let error = error {
//                print("Error deleting user: \(error)")
//            } else {
//                self.userData.remove(at: indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: .fade)
//            }
//        }
//    }
//
//    deleteAction.image = UIImage(systemName: "trash")
//    deleteAction.backgroundColor = .lightGray
//
//    return UISwipeActionsConfiguration(actions: [deleteAction])
//
//}


//        guard let indexPaths = signUpTableView.indexPathsForVisibleRows else {
//            return
//        }
//
//        for indexPath in indexPaths {
//            guard let cell = signUpTableView.cellForRow(at: indexPath) as? UserDataTableViewCell,
//                  let textFieldText = cell.userInputData.text else {
//                continue
//            }
//
//            switch indexPath.row {
//            case 0:
//                userData?.name = textFieldText
//            case 1:
//                userData?.age = textFieldText
//            case 2:
//                userData?.mobileNo = textFieldText
//            case 3:
//                userData?.mailId = textFieldText
//            case 4:
//                userData?.gender = textFieldText
//            case 5:
//                userData?.language = textFieldText
//            default:
//                break
//            }
//        }
        
        // Update the data in Firebase Firestore
       //  updateDataInFirestore()


//    func updateDataInFirestore() {
//        guard let userData = userData else {
//            return
//        }
//        ref.collection("UserDetails").order(by: "timestamp", descending: true).limit(to: 1).getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("Error retrieving documents: \(error)")
//                return
//            }
//
//            guard let document = querySnapshot?.documents.first else {
//                print("No documents found")
//                return
//            }
//            let docRef = self.ref.collection("UserDetails").document(document.documentID)
//
//            docRef.updateData([
//                "name": userData.name,
//                "age": userData.age,
//                "mobileNo": userData.mobileNo,
//                "mailId": userData.mailId,
//                "gender": userData.gender,
//                "language": userData.language
//            ]) { error in
//                if let error = error {
//                    print("Error updating document: \(error)")
//                } else {
//                    print("Document successfully updated")
//                }
//            }
//        }
//
//    }




//    func loadDataFromFireBase(){
//
//        ref.collection("UserDetails").getDocuments { [weak self] (querySnapshot, error) in
//            guard let snapshot = querySnapshot else {
//                print("Error fetching documents: \(error!)")
//                return
//            }
//            self?.userData = snapshot.documents.compactMap { document in
//                let documentData = document.data()
//                guard
//                    let name = documentData["Name"] as? String,
//                    let age = documentData["Age"] as? String,
//                    let mobileNo = documentData["Mobile Number"] as? String,
//                    let mailId = documentData["Email Address"] as? String,
//                    let gender = documentData["Gender"] as? String,
//                    let language = documentData["Language"] as? String else {
//                    return nil
 //               }
//
//                return UserDetail(name: name, age: age, mobileNo: mobileNo, mailId: mailId, gender: gender, language: language)
//            }
//            print("DATA...\(self!.userData)")
//            self?.signUpTableView.reloadData()
//        }
//    }
  


//        func getValueForIndexPath(_ indexPath: IndexPath) -> String {
//                let model = userData[indexPath.row]
//
//                switch indexPath.row {
//                case 0:
//                    return model.name
//                case 1:
//                    return model.age
//                case 2:
//                    return model.mobileNo
//                case 3:
//                    return model.mailId
//                case 4:
//                    return model.gender
//                case 5:
//                    return model.language
//                default:
//                    return ""
//                }
//            }
 //   }
    
