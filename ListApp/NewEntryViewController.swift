//
//  NewEntryViewController.swift
//  ListApp
//
//  Created by Austin Christensen on 1/19/21.
//

import UIKit

class NewEntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var field: UITextField!
    
    var update: ((_ newItem: ListItem) -> Void)?
    

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
        guard let text = field.text, !text.isEmpty else {
            return
        }
        
        let newItem = ListItem(title: text, createdAt: Date(), itemIdentifier: UUID())
        
        update?(newItem)
        
        navigationController?.popToRootViewController(animated: true)
        
    }

}
