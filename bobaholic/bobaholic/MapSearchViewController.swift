//
//  MapSearchViewController.swift
//  bobaholic
//

import UIKit
import MapKit

// Resource:
// // https://www.jeffedmondson.dev/blog/swift_location_search/
class MapSearchViewController: UIViewController, UISearchBarDelegate, MKLocalSearchCompleterDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTable: UITableView!
    
    var mapView:MKMapView?
    
    // Create a seach completer object
    var searchCompleter = MKLocalSearchCompleter()
    
    // These are the results that are returned from the searchCompleter & what we are displaying
    // on the searchTable
    var searchResults = [MKLocalSearchCompletion]()

    // This method declares that whenever the text in the searchbar is change to also update
    // the query that the searchCompleter will search based off of
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
    // This method declares gets called whenever the searchCompleter has new search results
    // If you wanted to do any filter of the locations that are displayed on the the table view
    // this would be the place to do it.
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        // Setting our searchResults variable to the results that the searchCompleter returned
        completer.region = mapView!.region
        searchResults = completer.results
        
        // Reload the tableview with our new searchResults
        searchTable.reloadData()
    }
    
    // This method is called when there was an error with the searchCompleter
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // Error
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchCompleter.delegate = self
        searchBar?.delegate = self
        
        searchTable?.delegate = self
        searchTable?.dataSource = self
    }

}

// Setting up extensions for the table view
extension MapSearchViewController: UITableViewDataSource {
    // This method declares the number of sections that we want in our table.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // This method declares how many rows are the in the table
    // We want this to be the number of current search results that the
    // searchCompleter has generated for us
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    // This method delcares the cells that are table is going to show at a particular index
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the specific searchResult at the particular index
        let searchResult = searchResults[indexPath.row]

        //Create  a new UITableViewCell object
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)

        //Set the content of the cell to our searchResult data
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle

        return cell
    }
}

extension MapSearchViewController: UITableViewDelegate {
    // This method declares the behavior of what is to happen when the row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            // Reference:
            // https://stackoverflow.com/questions/40331986/adding-pins-to-map-using-mapkit-swift-3-0
            let annotation = MKPointAnnotation()
            annotation.coordinate = (response?.mapItems[0].placemark.coordinate)!
            annotation.title = response?.mapItems[0].name
            self.mapView!.addAnnotation(annotation)
            let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
            let region = MKCoordinateRegion(center: (response?.mapItems[0].placemark.coordinate)!, span: span)
            self.mapView!.setRegion(region, animated: true)
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}
