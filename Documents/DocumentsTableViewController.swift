//
//  DocumentsTableViewController.swift
//  Documents
//
//  Created by Grant Maloney on 8/26/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit

class DocumentsTableViewController: UITableViewController {
    
    var documents = [DocumentLoaded]()
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let formatter = DateFormatter()
    
    @IBAction func addButton(_ sender: Any) {
        self.performSegue(withIdentifier: "moveToNotepad", sender: nil)
    }
    @IBOutlet weak var addButtonItem: UIBarButtonItem!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        documents = loadDocuments()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        self.navigationItem.rightBarButtonItem = addButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        documents = loadDocuments()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        if let cell = cell as? DocumentTableViewCell {
            
            let document = documents[indexPath.row]
            
            cell.documentTitle.text = document.documentTitle
            cell.documentSize.text = document.documentSize
            cell.dateModified.text = document.dateModified
        }

        return cell
    }
    
    func loadDocuments() -> [DocumentLoaded] {
        var foundDocuments = [DocumentLoaded]()
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            
            for url in fileURLs {
                let fileName = documentsURL.appendingPathComponent(url.lastPathComponent)
                do {
                    let data = try Data(contentsOf: fileName, options: .mappedIfSafe)
                    let decoder = JSONDecoder()
                    let foundDocument = try decoder.decode(Document.self, from: data)

                    if let date = url.modificationDate {
                        
                        let formattedDate = formatter.string(from: date)
                        foundDocuments.append(DocumentLoaded(documentTitle: foundDocument.documentTitle, documentContent: foundDocument.documentContent, documentSize: "Size: \(url.fileSize) bytes", dateModified: "Modified: \(formattedDate)"))
                    }
                    
                } catch let err {
                    print("Error decoding information", err)
                }
            }
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        
        return foundDocuments;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DocumentViewController {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let selectedRow = indexPath.row
                
                destination.activeDocument = self.documents[selectedRow]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "moveToNotepad", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                
                try FileManager.default.removeItem(at: documentsURL.appendingPathComponent("\(documents[indexPath.row].documentTitle).json"))
            } catch let err {
                
                print("Error deleting file", err)
            }
            
            documents.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
