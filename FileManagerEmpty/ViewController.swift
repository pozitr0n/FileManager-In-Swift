//
//  ViewController.swift
//  FileManagerEmpty
//
//  Created by Raman Kozar on 23/12/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var addressLabel: UILabel!
    
    let fileManager: FileManager = FileManager()
    let tempDirectory: String = NSTemporaryDirectory()
    let fileName: String = "customFile.txt"
    var folderPath: String = ""
    var hasChanges: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")
        
        guard let uPath = path else {
            return
        }
        
        addressLabel.text = uPath
        
    }
    
    func validateCatalog() -> String? {
        
        do {
            
            let objectsInCatalog = try fileManager.contentsOfDirectory(atPath: tempDirectory)
            let objects = objectsInCatalog
            
            if objects.count > 0 {
                if objects.first == fileName {
                    print("\(fileName) found")
                    return objects.first
                } else {
                    print("It has no file \(fileName) in the temp catalog")
                    return nil
                }
            }
            
        } catch let error as NSError {
            print(error)
        }
        
        return nil
    }
    
    @IBAction func createAFileAction(_ sender: Any) {
        
        let filePath = (tempDirectory as NSString).appendingPathComponent(fileName)
        let fileContent = "Some content into the text file"
        
        do {
            try fileContent.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
            addressLabel.text = "File \(fileName) was successfully created"
        } catch let error as NSError {
            addressLabel.text = "Couldn't create file \(fileName) because of error: \(error)"
        }
        
    }
    
    @IBAction func checkTmp(_ sender: Any) {
        
        let filesCatalog = validateCatalog() ?? "Nothing"
        addressLabel.text = filesCatalog
        
    }
    
    @IBAction func createFolder(_ sender: Any) {
        
        let docsFolderPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let logPath = docsFolderPath.appendingPathComponent("CustomFolder")
        
        guard let unwrLogPath = logPath else {
            return
        }
        
        do {
            try FileManager.default.createDirectory(atPath: unwrLogPath.path(), withIntermediateDirectories: true, attributes: nil)
            addressLabel.text = "\(unwrLogPath)"
            print(unwrLogPath)
        } catch let error as NSError {
            addressLabel.text = "Can't create directory because of error: \(error)"
        }
        
    }
    
    @IBAction func folderExistCheck(_ sender: Any) {
        
        let directories: [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if directories.count > 0 {
            
            let directory = directories[0]
            folderPath = directory.appendingFormat("/" + folderPath)
            print("Local path = \(folderPath)")
            
        } else {
            print("Couldn't find local directory for this folder")
            return
        }
        
        if fileManager.fileExists(atPath: folderPath) {
            addressLabel.text = "Folder exist - \(folderPath)"
        } else {
            addressLabel.text = "Folder does not exist"
        }
        
    }
    
    @IBAction func readFileButtonAction(_ sender: Any) {
       
        if hasChanges {
         
            if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                
                let file = fileName
                let fileURL = directory.appendingPathExtension(file)
                
                do {
                    let text = try String(contentsOf: fileURL, encoding: .utf8)
                    addressLabel.text = text
                } catch {
                    addressLabel.text = "Can't read"
                }
                
            }
            
        } else {
         
            let directoryWithFiles = validateCatalog() ?? "Empty"
            let path = (tempDirectory as NSString).appendingPathComponent(directoryWithFiles)
            
            do {
                let contentsOfFile = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
                addressLabel.text = "Content of the file is: \(contentsOfFile)"
            } catch let error as NSError {
                addressLabel.text = "There is file reading error: \(error)"
            }
            
        }
        
    }
    
    @IBAction func writeToAFileAction(_ sender: Any) {
        
        let someTextToWrite = "Add new string for writing"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathExtension(fileName)
            
            do {
                try someTextToWrite.write(to: fileURL, atomically: false, encoding: .utf8)
                addressLabel.text = "\(someTextToWrite) added to the file \(fileName)"
                hasChanges = true
            } catch let error as NSError {
                addressLabel.text = "Unable to write because of error: \(error)"
            }
            
        }
    
    }
    
    @IBAction func removeFileButtonAction(_ sender: Any) {
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let removeFile = dir.appendingPathExtension(fileName)
            
            do {
                try fileManager.removeItem(at: removeFile)
                addressLabel.text = "File \(fileName) removed"
            } catch {
                addressLabel.text = "Can't remove"
            }
            
        }
        
    }
    
}

