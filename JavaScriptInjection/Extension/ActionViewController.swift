//
//  ActionViewController.swift
//  Extension
//
//  Created by Reysmer Valle on 8/10/21.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    @IBOutlet var script: UITextView!
    var pageTitle = ""
    var pageURL = ""
    let scripts = ["script_1": "alert('Script 1')", "script_2": "alert('Script 2')"]
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barButtons = [UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done)), UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(selectScript))]
        
        navigationItem.rightBarButtonItems = barButtons
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext!.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else {
                        return
                    }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    let userPrevScript = self?.defaults.object(forKey: "userPrevScript") as? [String: String] ?? [String: String]()
                    
                    
                    DispatchQueue.main.async {
                        if let pageUrl = self?.pageURL {
                            self?.script.text = userPrevScript[pageUrl]
                        }
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
    }
    
    @IBAction func done() {
        let item = NSExtensionItem()
        defaults.set([self.pageURL: script.text], forKey: "userPrevScript")
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        
        extensionContext!.completeRequest(returningItems: [item])
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue =  notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = UIEdgeInsets.zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    @objc func selectScript() {
        let alertController = UIAlertController(title: "PreSelected Scripts", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Script 1", style: .default, handler: {
            [weak self] action in
            self?.setScript(action: action, key: "script_1")
        }))
        alertController.addAction(UIAlertAction(title: "Script 2", style: .default, handler: {
            [weak self] action in
            self?.setScript(action: action, key: "script_2")
        }))
        present(alertController, animated: true)
    }
    
    func setScript(action: UIAlertAction, key: String) -> Void {
        guard let scriptText = scripts[key] else {
            return
        }
        script.text = scriptText
    }
    
}
