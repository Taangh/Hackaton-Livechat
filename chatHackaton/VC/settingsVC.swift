//
//  settingsVC.swift
//  chatHackaton
//
//  Created by Damian on 24.03.2018.
//  Copyright © 2018 Damian. All rights reserved.
//

import UIKit

class settingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, OXPatternLockDelegate {
    func didPatternInput(patterLock: OXPatternLock, track: [Int]) {
        
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBAction func addButton(_ sender: Any) {
    }
    
    @IBOutlet weak var dotsView: UIView!
    var locker = OXPatternLock()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDotsView()
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
        return 0
    }

}
