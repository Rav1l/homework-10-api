//
//  CharactersTableVC.swift
//  Homework 10 API
//
//  Created by Ravil Gubaidulin on 02.01.2023.
//

import UIKit

class CharactersTableVC: UITableViewController {

    private let url = "https://rickandmortyapi.com/api/character"
    private let networkService = NetworkService()
    private var characters = [Character]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath)

        cell.textLabel?.text = self.characters[indexPath.row].name

        return cell
    }
    

    private func fetchData() {
        self.networkService.getCharacters { result in
            DispatchQueue.main.async {
                self.characters = (try? result.get()) ?? []
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showCharacterVC" else { return }
        
        guard let destination = segue.destination as? CharacterVC else { return }
        
        if let index = self.tableView.indexPathForSelectedRow {
            let url = URL(string: self.characters[index.row].image)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    destination.imageView.image = UIImage(data: data!)
                    destination.nameLable.text = self.characters[index.row].name
                    destination.speciesLable.text = "Species: \(self.characters[index.row].species.rawValue)"
                    destination.statusLable.text = "Status: \(self.characters[index.row].status.rawValue)"
                    destination.locationLable.text = "Location: \(self.characters[index.row].location.name)"
                }
            }
        }
    }

}
