//
//  weatherTableViewController.swift
//  Test
//
//  Created by School on 3/3/21.
//

import UIKit

class weatherTableViewController: UITableViewController {
    
    struct wher: Decodable {
        var name, region, country: String
        var lat, lon: Float
        var tz_id: String
        var localtime_epoch: Int
        var localtime: String
    }
    
    struct prof: Decodable {
        var text: String
        var icon: String
    }
    
    struct weatherAttribute: Decodable {
        var location: wher
        var current: when
    }
    
    struct when: Decodable {
        var temp_f: Float
        var condition: prof
    }
    
    

    var Welcome: weatherAttribute!

    var locations: [String] = ["SF", "LA", "Durham", "NY", "Mykonos", "Johannesburg"]
    var conditions: [Float] = [0, 0, 0, 0, 0, 0]
    var cityWeather: [String] = ["cloud", "sun", "sun", "cloud", "rain", "rain"]
    var weatherImages: [UIImage] = [UIImage(named:"DurhamCloud")!, UIImage(named:"ChapelHillSun")!, UIImage(named:"CarborroSun")!,UIImage(named:"MorrisvilleCloud")!,UIImage(named:"RaleighRain")!, UIImage(named:"CaryRain")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for x in 0...5 {
            self.getAllData(idx: x)
        }


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
        
    func downloadImage(from url: URL, idx: Int) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            self.weatherImages[idx] = UIImage(data: data)!
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    
    func getAllData(idx: Int) {
        print(locations[idx])
        let headers = [
            "x-rapidapi-key": "84ade287f9msh42e9eed2f353ed8p165a25jsn8ae6e9be3b01",
            "x-rapidapi-host": "weatherapi-com.p.rapidapi.com"
        ]

        var request = URLRequest(url: URL(string: "https://weatherapi-com.p.rapidapi.com/forecast.json?q=\(locations[idx])&days=3")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil else {
                print("Error: \(error!)")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error - ", message: "\(error!)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                return
            }
            
            guard let jsonData = data else {
                print("No data")
                return
            }
            
            do {
                self.Welcome = try JSONDecoder().decode(weatherAttribute.self, from: jsonData)
                self.conditions[idx] = self.Welcome.current.temp_f
                self.cityWeather[idx] = self.Welcome.current.condition.text
                let imgUrl = URL(string: "https:" + self.Welcome.current.condition.icon)
                self.downloadImage(from: imgUrl!, idx: idx)

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print(self.Welcome.current.temp_f)
            } catch {
                print("JSONDecoder error : \(error)")
            }
        }
            
        dataTask.resume()
        
        print("Data is loaded")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCustomCell", for: indexPath) as! weatherTableViewCell

        // Configure the cell...
        cell.cityName.text = locations[indexPath.row]
        cell.tempValue.text = "\(conditions[indexPath.row])°F"
        cell.weatherImage.image = weatherImages[indexPath.row]
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.backgroundColor = UIColor(white: 1, alpha: 0.8)
        tableView.backgroundView = UIImageView(image: UIImage(named: "weatherbackground"))

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
       return "Favorite Cities Forecast"
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destVC = segue.destination as! weatherDetailViewController
        let selectRow = tableView.indexPathForSelectedRow?.row
        
        destVC.city = locations[selectRow!]
        destVC.temp = conditions[selectRow!]
        destVC.weath = cityWeather[selectRow!]
        destVC.pic = weatherImages[selectRow!]
    }

}
