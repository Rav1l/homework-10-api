//
//  PhotoTableVC.swift
//  Homework 10 API
//
//  Created by Ravil Gubaidulin on 03.01.2023.
//

import UIKit

class PhotoTableVC: UITableViewController {

    private let networkService = NetworkService()
    private var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath)
        
        cell.textLabel?.text = "Photo №\(indexPath.row + 1)"
        return cell
    }
 
    
    private func fetchData() {
        self.networkService.getPhotos { result in
            DispatchQueue.main.async {
                self.photos = (try? result.get()) ?? []
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showPhotoVC" else { return }
        
        guard let destination = segue.destination as? PhotoVC else { return }
        
        if let index = self.tableView.indexPathForSelectedRow {
            let url = URL(string: self.photos[index.row].downloadUrl)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    destination.authorLable.text = self.photos[index.row].author
                    destination.imageView.image = UIImage(data: data!)
                }
            }
        }
    }
}
