//
//  SignUpScreen.swift
//  SampleApp
//
//  Created by DoodleBlue on 14/07/23.
//

import UIKit
import FirebaseFirestore
import DropDown

class SignUpScreen: UIViewController {
    
    let dropDownForGenderOption = DropDown()
    let dropDownForLanguageOption = DropDown()
    // MARK: - OutLets
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var AgeTxtField: UITextField!
    @IBOutlet weak var MobileNoTxtField: UITextField!
    @IBOutlet weak var emailIdTxtField: UITextField!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var languagelbl: UILabel!
     
    @IBOutlet weak var languageOptionBtnOutlet: UIButton!
    @IBOutlet weak var genderOptionBtnOutlet: UIButton!
    // MARK: -  Action
    
    @IBAction func submitDataBtn(_ sender: Any) {
        if (nameTxtField.text?.isEmpty ?? true) && (AgeTxtField.text?.isEmpty ?? true) && (MobileNoTxtField.text?.isEmpty ?? true) && (emailIdTxtField.text?.isEmpty ?? true) && (genderLbl.text?.isEmpty ?? true) && (languagelbl.text?.isEmpty ?? true){
            
            showToast(message: "Please fill in the required fields.")
        } else {
            uploadToFireBase()
            showToast(message: "User Details Submitted Successfully")
            
        }
    }
    
    @IBAction func sellAllDetailsBtnAction(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(identifier: "AllDetailsScreen") as? AllDetailsScreen
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func backToHomeBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func genderDropDownBtn(_ sender: Any) {
        dropDownForGenderOption.anchorView = genderLbl
                dropDownForGenderOption.show()
    }
    
    @IBAction func languageDropDownBtn(_ sender: Any) {
        dropDownForLanguageOption.anchorView = languagelbl
                dropDownForLanguageOption.show()
        
    }
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    // MARK: - SetUp Methods
    func setUp(){
          
        self.navigationController?.isNavigationBarHidden = true
        
        // Setup For Gender Option
        dropDownForGenderOption.dataSource = ["Female", "Male"]
        dropDownForGenderOption.selectionAction = { [unowned self] (index: Int, item: String) in
            genderLbl.text = item
            dropDownForGenderOption.bottomOffset = CGPoint(x: 0, y: genderLbl.bounds.height)
            }
        // Setup For Language Option
        dropDownForLanguageOption.dataSource = ["English", "Tamil"]
        dropDownForLanguageOption.selectionAction = { [unowned self] (index: Int, item: String) in
            languagelbl.text = item
            dropDownForLanguageOption.bottomOffset = CGPoint(x: 0, y: languagelbl.bounds.height)
            }
    }
    
    func uploadToFireBase(){
        
        guard let name = nameTxtField.text,
              let age = AgeTxtField.text,
              let mobileNo = MobileNoTxtField.text,
              let mailId = emailIdTxtField.text,
              let gender = genderLbl.text,
              let language = languagelbl.text else {
            return
        }
//
        let db = Firestore.firestore()
        db.collection("UserDetails").addDocument(data: ["Name": name, "Age": age, "Mobile Number": mobileNo, "Email Address": mailId, "Gender": gender, "Language": language]){ error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
        nameTxtField.text = nil
        AgeTxtField.text = nil
        MobileNoTxtField.text = nil
        emailIdTxtField.text = nil
        genderLbl.text = nil
        languagelbl.text = nil
    }

func showToast(message: String) {
    let toastController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    self.present(toastController, animated: true, completion: nil)
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
        toastController.dismiss(animated: true, completion: nil)
    }
    
}
}
