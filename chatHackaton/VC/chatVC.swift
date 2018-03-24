//
//  chatVC.swift
//  chatHackaton
//
//  Created by Damian on 23.03.2018.
//  Copyright © 2018 Damian. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

final class chatVC: JSQMessagesViewController {
    var switchKeyboardOn: Bool = true
    var channelRef: DatabaseReference?
    var channel: Channel? {
        didSet {
            title = channel?.name
        }
    }
    var messages = [JSQMessage]()
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    private lazy var messageRef: DatabaseReference = self.channelRef!.child("messages")
    private var newMessageRefHandle: DatabaseHandle?
    
    
    @IBOutlet weak var patternLockView: UIView!
//    @IBAction func textField(_ sender: UITextField) {
//        if switchKeyboardOn == false {
//            showDots()
//            view.endEditing(true)
//        }
//    }
    fileprivate var writeYes: [Int] = [0,1,2]
    fileprivate var writeNo: [Int] = [3,4,5]
    fileprivate var timer: Timer?
    
    @IBOutlet var patternLock: OXPatternLock!
//    @IBAction func switchType(_ sender: UISwitch) {
//        if (sender.isOn == true) {
//            showKeyboard()
//            dismissDots()
//            switchKeyboardOn = true
//            print("on")
//        }
//        else {
//            switchKeyboardOn = false
//            dismissKeyboard()
//            print("off")
//        }
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = Auth.auth().currentUser?.uid
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        self.inputToolbar.contentView.leftBarButtonItem = nil
        self.inputToolbar.contentView.textView.placeHolder = "Wiadomość"
        patternLock.delegate = self
//        patternLockView.isHidden = true
        self.inputToolbar.contentView.rightBarButtonItem.setTitle("Ok", for: UIControlState.normal)
        observeMessages()
    }
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showKeyboard() {
        view.endEditing(false)
    }
    
    func showDots() {
        self.patternLockView.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.patternLockView.center.y = self.patternLockView.bounds.height
        }, completion: nil)
    }
    
    func dismissDots() {
        self.patternLockView.isHidden = true
    }
    
    @IBAction func recordPatternClick(_ sender: Any) {
        //        savedTrackPath.removeAll()
        showStatus(message: "Ready to set new pattern")
    }
    
    fileprivate func showStatus(message: String) {
        //        labelStatus.text = message
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in
            //            self.labelStatus.text = ""
        })
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: senderDisplayName, text: text) {
            messages.append(message)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let itemRef = messageRef.childByAutoId()
        let messageItem = [
            "senderId" : senderId!,
            "senderName": senderDisplayName!,
            "text": text!,
            ]
        itemRef.setValue(messageItem)
        //JSQSystemSoundPlayer.jsq_playMessageSentAlert()
        finishSendingMessage()
    }
    
    private func observeMessages() {
        //messageRef = channelRef!.child("messages")
        let messageQuery = messageRef.queryLimited(toLast: 25)
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            let messageData = snapshot.value as! Dictionary<String, String>
            print(messageData)
            if let id = messageData["senderId"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String!, text.characters.count > 0 {
                self.addMessage(withId: id, name: name, text: text)
                self.finishReceivingMessage()
            } else {
                print()
            }
        })
    }
    
    
}

extension chatVC: OXPatternLockDelegate {
    func didPatternInput(patterLock: OXPatternLock, track: [Int]) {
//        timer?.invalidate()
//        if writeYes == track {
//            textLabel.text = "yes"
//            textField.text = "yes"
//        }
//        else if writeNo == track {
//            textLabel.text = "no"
//        }
//        else {
//            print("inknown code")
//        }
    }
}
