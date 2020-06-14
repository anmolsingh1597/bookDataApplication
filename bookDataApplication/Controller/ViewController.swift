//
//  ViewController.swift
//  bookDataApplication
//
//  Created by Anmol singh on 2020-06-13.
//  Copyright © 2020 Swift Project. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var books: [Book]?
    
    @IBOutlet var textFields: [UITextField]!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        //MARK:- Notification for checking when user went out of app
        NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: UIApplication.willResignActiveNotification, object: nil)
        
        loadData()
    }

    func getDataFilePath() -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let filePath = documentPath.appending("/book-data.txt")
        return filePath
    }
    
    func loadData(){
        books = [Book]()
        
        let filePath = getDataFilePath()
        if FileManager.default.fileExists(atPath: filePath) {
            
            do{
                //creating string of file path
                let fileContent = try String(contentsOfFile: filePath)
                // seperating books from each other
                let contentArray = fileContent.components(separatedBy: "\n")
                for content in contentArray {
                    //seperating each book's content
                    let bookContent = content.components(separatedBy: ",")
                    if bookContent.count == 4 {
                        let book = Book(title: bookContent[0], author: bookContent[1], pages: Int(bookContent[2])!, year: Int(bookContent[3])!)
                        books?.append(book)
                    }
                }
                
            }catch {
                print(error)
            }
        }
    }

    @IBAction func addBook(_ sender: UIBarButtonItem) {
        let title = textFields[0].text ?? ""
        let author = textFields[1].text ?? ""
        let pages = Int(textFields[2].text ?? "0") ?? 0
        let year = Int(textFields[3].text ?? "1900") ?? 1900

        let book = Book(title: title, author: author, pages: pages, year: year)
        
        self.books?.append(book)
        
            textFields[0].text = ""
            textFields[1].text = ""
            textFields[2].text = ""
            textFields[3].text = ""
    }
    
    // calling variable of another viewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let bookListTableVC = segue.destination as? BookListTableViewController {
            bookListTableVC.books = self.books
        }
    }
    
    @objc func saveData() {
        let filePath = getDataFilePath()
        
        var saveString = ""
        
        for book in self.books! {
            saveString = "\(saveString)\(book.title),\(book.author),\(book.pages),\(book.year)\n"
        }
        
        do{
            try saveString.write(toFile: filePath, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
        
        
    }
}
