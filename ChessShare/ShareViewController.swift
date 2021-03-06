//
//  ShareViewController.swift
//  ChessShare
//
//  Created by Tim Colla on 26/02/2020.
//  Copyright © 2020 Marino Software. All rights reserved.
//

import UIKit
import Social
import CoreServices

class ShareViewController: SLComposeServiceViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        placeholder = "Enter some text"
    }

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here

        guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] else {
            return false
        }

        for extensionItem in extensionItems {
            if let itemProviders = extensionItem.attachments {
                for itemProvider in itemProviders {
                    if itemProvider.hasItemConformingToTypeIdentifier("public.json") {
                        return true
                    }
                }
            }
        }
        return false
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
//        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        passSelectedItemsToApp()
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

    func passSelectedItemsToApp() {
        guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] else {
            return
        }

        for extensionItem in extensionItems {
            if let itemProviders = extensionItem.attachments {
                for itemProvider in itemProviders {
                    if itemProvider.hasItemConformingToTypeIdentifier("public.file-url") {
                        itemProvider.loadItem(forTypeIdentifier: "public.file-url", options: nil, completionHandler: { data, error in
                            if let url = data as? URL,
                                let chessData = NSData(contentsOf: url) {
                                UserDefaults(suiteName: "group.com.marinosoftware.chess")?.set(chessData, forKey: "chessData")
                            }
                        })
                    }
                }
            }
        }

        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
}
