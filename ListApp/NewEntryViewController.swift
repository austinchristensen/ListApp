//
//  NewEntryViewController.swift
//  ListApp
//
//  Created by Austin Christensen on 1/19/21.
//

import UIKit

class NewEntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var field: UITextField!
    
    var update: (() -> Void)?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        field.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveItem))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveItem()
        
        return true
    }
    
    @objc func saveItem() {
        guard let text = field.text, !text.isEmpty, var count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        
        count += 1
        UserDefaults().set(count, forKey: "count")
        UserDefaults().set(text, forKey: "item_\(count)")
        
        update?()
        
        navigationController?.popToRootViewController(animated: true)
        
    }

}
