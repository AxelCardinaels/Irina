//
//  SearchViewController.swift
//  Irina
//
//  Created by Axel Cardinaels on 29/08/15.
//  Copyright (c) 2015 Axel Cardinaels. All rights reserved.
//

import UIKit
import CoreData


class SearchViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var movieTable: UITableView!
    var movies: NSMutableArray = [];
    var selectedMovie = NSDictionary();
    var searchBar = UISearchBar()
    var imageToTransmit = UIImageView();
    var titleToTransmit = UILabel();
    var dateToTransmit =  UILabel();
    var noteToTransmit =  UILabel();
    var genreToTransmit =  UILabel();
    
    
    //Mise en place de l'interface quand on clique sur la barre de recherche
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        if searchBar.text == ""{
            
            searchBar.setShowsCancelButton(true, animated: true)
            searchBar.tintColor = UIColor.whiteColor()
        }
        
    }
    
    
    //Quand la valeur du champ de recherche change, on lance la rehcerche
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == ""{
            
            movies = [];
            movieTable.reloadData()
        }else{
            let searchString = searchBar.text!.stringByReplacingOccurrencesOfString(" ", withString: "+");
            irina.searchMovies(searchString, completionHandler: {data, error -> Void in
                
                if (data != nil) {
                    self.movies = NSMutableArray(array: data);
                    dispatch_async(dispatch_get_main_queue(), { self.movieTable.reloadData() })
                } else {
                    print("api.getData failed")
                    print(error)
                }
            })
        }
        
        
    }
    
    
    //On lance la recherche au click sur le bouton "rechercher"
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.endEditing(true);
        
        if searchBar.text == ""{
            
            
        }else{
            let searchString = searchBar.text!.stringByReplacingOccurrencesOfString(" ", withString: "+");
            irina.searchMovies(searchString, completionHandler: {data, error -> Void in
                
                if (data != nil) {
                    self.movies = NSMutableArray(array: data);
                    dispatch_async(dispatch_get_main_queue(), { self.movieTable.reloadData() })
                } else {
                    print("api.getData failed")
                    print(error)
                }
            })
        }
    }
    
    //Suppression du bouton cancel + bouton suivi activé de nouveau au click sur le bouton annuler de la bar
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.endEditing(true);
        searchBar.setShowsCancelButton(false, animated: true);
        searchBar.text = "";
        movies = [];
        movieTable.reloadData()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.searchBar.endEditing(true);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        //Mise en place de la barre de recherche dans la bar de navigation
        
        let colorTextSearchBar = searchBar.valueForKey("searchField") as? UITextField
        colorTextSearchBar?.textColor = UIColor.whiteColor()
        searchBar.sizeToFit()
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchBar.placeholder = "Rechercher un film"
        self.navigationItem.titleView = searchBar;
        addBlurEffect(self);
        
        
        searchBar.keyboardType = UIKeyboardType.WebSearch
        searchBar.delegate = self;
        
        // Do any additional setup after loading the view.
        
        movieTable.rowHeight = UITableViewAutomaticDimension
        movieTable.estimatedRowHeight = 77.0;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count;
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("movieCell", forIndexPath: indexPath) as! MovieTableViewCell
        
        
        //Téléchargement de l'image :
        
        let urlToDownload = NSURL(string: movies[indexPath.row]["poster"] as! String);
        let urlRequest = NSURLRequest(URL: urlToDownload!);
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            if error != nil{
                print(error)
            }else{
                let image = UIImage(data: data!);
                cell.moviePoster.image = image;
            }
        }
        
        
        let fullDate: String = self.movies[indexPath.row]["release_date"] as! String
        var fullDateParts = fullDate.componentsSeparatedByString("-")
        
        
        if let actualMovie = self.movies[indexPath.row]["title"] as? NSString {
            
            cell.movieTitle?.text = "\(actualMovie as String) (\(fullDateParts[0]))"
        } else {
            cell.movieTitle?.text = "No Name"
        }
        
        let notes = self.movies[indexPath.row]["notes"] as! NSDictionary;
        let note : AnyObject = notes["mean"]!
        let noteMiddle = String(note);
        let noteFull = ((noteMiddle as NSString).floatValue)*2
        let noteShort = (NSString(format: "%.01f", noteFull))
        
        
        cell.movieRate.text = "\(noteShort)/10";
        
        let genres = self.movies[indexPath.row]["genres"] as! NSArray
        
        var genre1 = "";
        var genre2 = "";
        
        
        if genres.count == 0{
            genre1 = "Pas de genres";
            genre2 = "";
        }
        
        
        if genres.count == 1 {
            genre1 = genres[0] as! String;
            genre2 = "";
        }
        
        if genres.count > 1{
            genre1 = genres[0] as! String;
            genre2 = genres[1] as! String;
        }
        
        if genre1 != ""{
            if genre2 != ""{
                cell.movieType.text = "\(genre1) & \(genre2)";
            }else{
                cell.movieType.text = genre1
            }
        }else{
            cell.movieType.text = "Pas de genres"
        }
        
        
        
        cell.backgroundColor = UIColor(red: 35/255.0, green: 35/255.0, blue: 35/255.0, alpha: 0.0);
        
        cell.movieTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        cell.movieTitle.numberOfLines = 0;
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 5/255.0, green: 5/255.0, blue: 5/255.0, alpha: 1.0);
        cell.selectedBackgroundView = bgColorView;
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedMovie = movies[indexPath.row] as! NSDictionary
        
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!)! as UITableViewCell
        
        imageToTransmit = currentCell.valueForKey("moviePoster") as! UIImageView;
        
        let actualMovie = self.movies[indexPath!.row]["title"] as? NSString;
        titleToTransmit.text = "\(actualMovie!)"
        
        let fullDate: String = self.movies[indexPath!.row]["release_date"] as! String
        let fullDateParts = fullDate.componentsSeparatedByString("-")
        dateToTransmit.text = "\(fullDateParts[0])"
        
        noteToTransmit = currentCell.valueForKey("movieRate") as! UILabel;
        genreToTransmit = currentCell.valueForKey("movieType") as! UILabel;
        
        performSegueWithIdentifier("showMovie", sender: AnyObject?())
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showMovie" {
            let secondView: ShowViewController = segue.destinationViewController as! ShowViewController
            
            secondView.idToShow = (selectedMovie["id"] as? Int)!;
            secondView.posterToShow = imageToTransmit;
            secondView.titleToShow = titleToTransmit.text!;
            secondView.dateToShow = dateToTransmit.text!;
            secondView.noteToShow = noteToTransmit.text!;
            secondView.genreToShow = genreToTransmit.text!;
            secondView.local = false;
            
            
        }
        
    }
    
    
    
}
