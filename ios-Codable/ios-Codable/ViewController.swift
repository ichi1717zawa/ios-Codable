//
//  ViewController.swift
//  ios-Codable
//
//  Created by ichi1717zawa on 2020/9/28.
//

import UIKit

class ViewController: UIViewController {
    var data = [openData]()
    var url =  URL(string: "http://odws.hccg.gov.tw/001/Upload/25/OpenData/9059/249/711eb08d-dddc-4c4b-a589-7b6049d6285a.json")!
    @IBOutlet weak var mytableview: UITableView!
    
     
     
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getData()
    }
    
    func getData()
    {
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error { assertionFailure(error.localizedDescription) }
            guard let data = data else { return }
            do{
                let decodableData = try JSONDecoder().decode([openData].self, from: data)
                decodableData.forEach { (data) in
                    let data = openData(TestTarget: data.TestTarget,
                                        補助受理單位名稱: data.補助受理單位名稱,
                                        住址: data.住址,
                                        電話01: data.電話01,
                                        F5: data.F5)
                    self.data.append(data)
                    DispatchQueue.main.async {
                        self.mytableview.reloadData()
                    }
                }
            }catch{
                assertionFailure("parsing fail")
            }
        }
        session.resume()
    }
    
}


extension ViewController : UITableViewDelegate{
    
}



extension ViewController : UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell
        cell?.setData(model: self.data, index: indexPath)
        return cell ?? UITableViewCell()
    }
    
    
}
