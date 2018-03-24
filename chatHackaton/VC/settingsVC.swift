//
//  settingsVC.swift
//  chatHackaton
//
//  Created by Damian on 24.03.2018.
//  Copyright © 2018 Damian. All rights reserved.
//

import UIKit

class settingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, OXPatternLockDelegate{
    
    var patterns: [Pattern] = []
    var lastPath: [Int] = []
    func didPatternInput(patterLock: OXPatternLock, track: [Int]) {
        lastPath = track
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    @IBAction func addButton(_ sender: Any) {
        patterns.append(Pattern(name: textField.text!, path: lastPath))
        let defaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: patterns)
        defaults.set(encodedData, forKey: "patterns")
        defaults.synchronize()

        tblView.reloadData()

    }
    
    @IBOutlet weak var dotsView: UIView!
    var locker = OXPatternLock()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as? SettingsCell {
            let pattern = patterns[indexPath.row]
            cell.nameLbl.text = pattern.name
            return cell
        }
        return SettingsCell()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.delegate = self
        tblView.dataSource = self
        setUpDotsView()
        let defaults = UserDefaults.standard
        if let decoded = defaults.object(forKey: "patterns") as? Data {
            let decodedPatterns = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Pattern]
            patterns = decodedPatterns
            print(decodedPatterns)
        }

    }
    
    func setUpDotsView() {
        locker = OXPatternLock(frame: CGRect(x: 0, y: 40, width: self.view.bounds.width, height: 260))
        locker.delegate = self
        locker.backgroundColor = .white
        locker.dot = UIImage(named: "dot.png")
        locker.dotSelected = UIImage(named: "dot-selected.png")
        locker.trackLineThickness = CGFloat(3)
        locker.lockSize = 3
        locker.trackLineColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        view.addSubview(locker)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return patterns.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textField.text = patterns[indexPath.row].name
        print(patterns[indexPath.row].path)
    }
    
    
}
