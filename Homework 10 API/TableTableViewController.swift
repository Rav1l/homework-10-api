import UIKit

class TableTableViewController: UITableViewController {
    
    private let url = "https://api.imgflip.com/get_memes"
    private let networkService = NetworkService()
    private var memes = [Mem]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = memes[indexPath.row].name
        return cell
    }
    
    private func fetchData() {
        self.networkService.getMemes(url: url) { result in
            DispatchQueue.main.async {
                self.memes = (try? result.get()) ?? []
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showSecond" else { return }
        
        guard let destination = segue.destination as? ViewController else { return }
        
        if let index = self.tableView.indexPathForSelectedRow {
            let url = URL(string: self.memes[index.row].url)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    destination.nameLable.text = self.memes[index.row].name
                    destination.imageView.image = UIImage(data: data!)
                }
            }
        }
    }
}


