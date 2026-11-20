//
//  ViewController.swift
//  Horoscopo
//
//  Created by Turno Mananas on 18/11/2026.
//


import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    // MARK: Properties
    var horoscopeList:  [Horoscope] = Horoscope.horoscopeList
    
    // MARK: Outles
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional set after loading the view.
        
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController

        tableView.dataSource = self
    }
    
    // MARK: TableView CataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return horoscopeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Horoscope Cell", for: indexPath) as! HoroscopeViewCell

        let horoscope = horoscopeList[indexPath.row]
        cell.render(with: horoscope)

        return cell
    }
    
    // MARK: SearchBar Delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        if searchText.isEmpty{
            horoscopeList = Horoscope.horoscopeList
        } else {
            horoscopeList = Horoscope.horoscopeList.filter { it in
                it.name.lowercased().contains(searchText.lowercased()) ||
                it.dates.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        horoscopeList = Horoscope.horoscopeList
        tableView.reloadData()
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let detailViewControler = segue.destination as! DetailViewController
        let indexPath = tableView.indexPathForSelectedRow!
        let horoscope = horoscopeList[indexPath.row]
        detailViewControler.horoscope = horoscope
        tableView.deselectRow(at: indexPath, animated: false)
    }
}



