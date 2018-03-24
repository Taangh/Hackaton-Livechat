//
//  chatListVC.swift
//  chatHackaton
//
//  Created by Damian on 23.03.2018.
//  Copyright © 2018 Damian. All rights reserved.
//

import UIKit
import Firebase

enum Section: Int {
    case createNewChannelSection = 0
    case currentChannelsSection
}

class chatListVC: UITableViewController {
    
    var newChannalTxtField: UITextField?
    var senderLogin: String?
    private var channels: [Channel] = []
    private lazy var channelRef: DatabaseReference = Database.database().reference().child("channels")
    private var channelRefHandle: DatabaseHandle?
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        channels.append(Channel(id: "1", name: "Ch1"))
//        channels.append(Channel(id: "2", name: "Ch2"))
//        self.tableView.reloadData()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Użytkownicy"
        observeChannels()
    }
    
    deinit {
        if let refHandel = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandel)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentSection: Section = Section(rawValue: section) {
            switch currentSection {
            case .createNewChannelSection:
                return 1
            case .currentChannelsSection:
                return channels.count
            }
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == Section.currentChannelsSection.rawValue {
            let channel = channels[(indexPath as NSIndexPath).row]
            self.performSegue(withIdentifier: "chatVC", sender: channel)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue ? "NewChannel" : "ExistingChannel"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue {
            if let createNewChannelCell = cell as? CreateChannelCell {
                newChannalTxtField = createNewChannelCell.newChannelNameField
            }
        } else if (indexPath as NSIndexPath).section == Section.currentChannelsSection.rawValue {
            cell.textLabel?.text = channels[(indexPath as NSIndexPath).row].name
        }
        
        return cell
    }
    
    @IBAction func addChannel(_ sender: Any) {
        if let name = newChannalTxtField?.text {
            let newChannelRef = channelRef.childByAutoId()
            let channelItem = [
                "name" : name
            ]
            newChannelRef.setValue(channelItem)
        }
    }
    
    private func observeChannels() {
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            if let name = channelData["name"] as! String!, name.characters.count > 0 {
                self.channels.append(Channel(id: id, name: name))
            } else {
                print("Error")
            }
            self.tableView.reloadData()

        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let channel = sender as? Channel {
            let chatVC = segue.destination as! chatVC
            
            chatVC.senderDisplayName = senderLogin
            chatVC.channel = channel
            chatVC.channelRef = channelRef.child(channel.id)
        }
    }
    
}
