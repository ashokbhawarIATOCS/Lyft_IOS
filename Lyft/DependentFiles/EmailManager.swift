//
//  EmailManager.swift
//  Lyft
//
//  Created by Diwakar Garg on 05/09/22.
//  Copyright © 2022 Diwakar Garg. All rights reserved.

import Foundation
import MessageUI
public protocol EmailManagerDelegate: AnyObject {
    func getresult(mailresult: MFMailComposeResult)
}
class EmailManager: NSObject, MFMailComposeViewControllerDelegate {
    static let instance = EmailManager()
    weak var emailManagerdelegate: EmailManagerDelegate?
    var viewController: UIViewController?
    
    func canSendEmails() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }

    func sendEmail(recipients: [String], message: String, attachments: [Data]?, subject: String) {
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self
        mailViewController.setToRecipients(recipients)
        mailViewController.setMessageBody(message, isHTML: false)
        mailViewController.setSubject(subject)
       // mailViewController.addAttachmentData(<#T##attachment: Data##Data#>, mimeType: <#T##String#>, fileName: <#T##String#>)
        viewController?.present(mailViewController, animated: true)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if emailManagerdelegate != nil {
            emailManagerdelegate?.getresult(mailresult: result)
               }
        controller.dismiss(animated: true, completion: nil)
    }
}
