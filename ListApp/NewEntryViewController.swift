//
//  NewEntryViewController.swift
//  ListApp
//
//  Created by Austin Christensen on 1/19/21.
//

import UIKit

class NewEntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var field: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addButton: UIButton!
    
    var update: ((_ newItem: ListItem) -> Void)?
    
    var detailItems: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        field.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveItem))
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveItem()
        
        return true
    }
    
    @IBAction func didTapAdd() {
        promptForAnswer()
    }
    
    func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0].text
            self.detailItems.append(answer ?? "You didn't put anything?")
            self.tableView.reloadData()
        }

        ac.addAction(submitAction)

        present(ac, animated: true)
    }
    
    @objc func saveItem() {
        guard let text = field.text, !text.isEmpty else {
            return
        }
        
        let newItem = ListItem(title: text, createdAt: Date(), itemIdentifier: UUID(), index: 0, detailItems: detailItems)
        
        update?(newItem)
        
        navigationController?.popToRootViewController(animated: true)
        
    }

}

extension NewEntryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NewEntryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let item = detailItems[indexPath.row]

        cell.textLabel?.text = item

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            detailItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
