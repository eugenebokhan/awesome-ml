//
//  SettingsViewController.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var downloadedModelsTableView: UITableView!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure(downloadedModelsTableView)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        downloadedModelsTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDownloadedModelsURLs() -> [URL] {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var mlmodelcFiles: [URL] = []
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: [])
            print(directoryContents)
            
            // If you want to filter the directory contents you can do like this:
            mlmodelcFiles = directoryContents.filter { $0.pathExtension == "mlmodelc" }
            
            let mlmodelcFileNames = mlmodelcFiles.map { $0.deletingPathExtension().lastPathComponent }
            print("mlmodelc list:", mlmodelcFileNames)
            
        } catch {
            print(error.localizedDescription)
        }
        
        return mlmodelcFiles
        
    }

}

extension SettingsViewController: UITableViewDelegate {
    
    func configure(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.allowsSelection = false
    }
    
}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getDownloadedModelsURLs().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let downloadedModelTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DownloadedModelTableViewCell", for: indexPath) as! DownloadedModelTableViewCell
        
        let modelFileURL = getDownloadedModelsURLs()[indexPath.row]
        let modelFileName = modelFileURL.deletingPathExtension().lastPathComponent
        let coremlmodecFolderSize = String(format: "%.1f", Double(folderSize(folderPath: modelFileURL.path) / 1048576)) + " mb"
        
        downloadedModelTableViewCell.modelNameLabel.text = modelFileName
        downloadedModelTableViewCell.modelSizeLabel.text = coremlmodecFolderSize
        
        return downloadedModelTableViewCell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row <= getDownloadedModelsURLs().count - 1
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            do {
                let modelFileURL = self.getDownloadedModelsURLs()[indexPath.row]
                if FileManager.default.fileExists(atPath: modelFileURL.path) {
                    try FileManager.default.removeItem(at: modelFileURL)
                    self.downloadedModelsTableView.deleteRows(at: [indexPath], with: .automatic)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.downloadedModelsTableView.reloadData()
                    })
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return [delete]
    }
    
    func reloadTableView() {
        let range = NSMakeRange(0, downloadedModelsTableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        downloadedModelsTableView.reloadSections(sections as IndexSet, with: .automatic)
    }
    
}
