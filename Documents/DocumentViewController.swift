//
//  NotePadViewController.swift
//  Documents
//
//  Created by Grant Maloney on 8/26/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    var activeDocument:DocumentLoaded?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let foundDocument = activeDocument {
            contentTextView.text = foundDocument.documentContent
            titleTextField.text = foundDocument.documentTitle
        } else {
            contentTextView.text = ""
            titleTextField.text = ""
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.saveNote))
        
        titleTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    func saveNote() {
        if titleTextField.text == "" {
            print("Error, empty text field!")
            return
        }
        
        if contentTextView.text == "" {
            print("Error, empty text view!")
            return
        }
        
        let document = Document(documentTitle: titleTextField.text!, documentContent: contentTextView.text)
        
        let fileNameTwo = documentsURL.appendingPathComponent("\(document.documentTitle).json")
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let productJSON = try encoder.encode(document)
            try productJSON.write(to: fileNameTwo)
        } catch let err {
            print("Error Saving \(document.documentTitle)", err)
        }

        print("Saved Successfully")
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc
    func textFieldDidChange() {
        self.navigationItem.title = titleTextField.text
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
