//
//  AppDelegate.swift
//  SnapBugZ
//
//  Created by Shawn Marston on 13/09/2019.
//  Copyright © 2019 No-SnagZ Software. All rights reserved.
//  www.no-snagz.com
//

import UIKit
import MessageUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MFMailComposeViewControllerDelegate {

	var window: UIWindow?
	var snapShotImage: UIImage?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
				NotificationCenter.default.addObserver(self, selector: #selector(takeScreenshotAndAlert(noti:)), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
		return true
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		NotificationCenter.default.addObserver(self, selector: #selector(takeScreenshotAndAlert(noti:)), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
	}

	func applicationWillResignActive(_ application: UIApplication) {
		NotificationCenter.default.removeObserver(self, name: UIApplication.userDidTakeScreenshotNotification, object: nil)
	}
	// MARK: - Bug Snapper

	@objc func takeScreenshotAndAlert(noti: Notification?){
		self.takeScreenshotAndAlert()
	}

	@objc func takeScreenshotAndAlert(){
// Capture the Main Screen/Window as an image
		let topWindow = UIApplication.shared.windows[0]
		let windowSize = topWindow.bounds.size as CGSize
		let windowScale = topWindow.screen.scale as CGFloat
		UIGraphicsBeginImageContextWithOptions(windowSize, true, windowScale)
		topWindow.drawHierarchy(in: topWindow.frame, afterScreenUpdates: false)
		snapShotImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		// Check if eMail is available
		if MFMailComposeViewController.canSendMail() {
			// Display Alert to allow user to choose action
			let eMailAlert = UIAlertController(title: "Snapshot Taken", message: "Send a Bug Report?", preferredStyle: .actionSheet)
			let actionBugReport = UIAlertAction(title: "Send Bug Report", style: .default) { (UIAlertAction) in
				self.sendBugReport(attachedImage: self.snapShotImage!)
			}
			let actionEmail = UIAlertAction(title: "Send eMail", style: .default) { (UIAlertAction) in
				self.sendEmail(attachedImage: self.snapShotImage!)
			}
			let actionCancel = UIAlertAction(title: "Save to Camera Roll", style: .cancel) { (UIAlertAction) in
				eMailAlert.dismiss(animated: true)
			}
			eMailAlert.addAction(actionBugReport)
			eMailAlert.addAction(actionEmail)
			eMailAlert.addAction(actionCancel)
			topWindow.rootViewController?.present(eMailAlert, animated: true, completion: nil)
		// Compile email
		}
	}
	func sendBugReport(attachedImage: UIImage) {
		self.sendScreenShotEmail(asBugReport: true, withExtraText: "")
	}

	func sendEmail(attachedImage: UIImage) {
		self.sendScreenShotEmail(asBugReport: false, withExtraText: "sent using SnapBugZ by No-SnagZ")

	}

	func sendScreenShotEmail(asBugReport: Bool, withExtraText: String?){
		let myMailCVC = MFMailComposeViewController.init()
		let toAddressArray = ["to@address.missing"] as [String]//e.g.["support@myWebDomain"]
		let ccAddressArray = [] as [String]//e.g.["developer@myWebDomain"]
		let bccAddressArray = [] as [String]//e.g.["ticket@myWebDomain"]
		myMailCVC.setToRecipients(toAddressArray)
		myMailCVC.setCcRecipients(ccAddressArray)
		myMailCVC.setBccRecipients(bccAddressArray)
		let myAppName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName")  as! String
		let myAppVers = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
		var subjectStr: String
		if asBugReport {
			subjectStr = "Bug Report from \(myAppName) Ver:\(myAppVers)"
		} else {
			subjectStr = "ScreenShot from \(myAppName)"
		}
		myMailCVC.setSubject(subjectStr)
		var bodyStr: String
		if asBugReport {
			let userDevName = "\(UIDevice.current.localizedModel)"
			let userDeviceOS = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
			let currentViewCont = self.window?.rootViewController?.description
// Fill this part with any info you need for debugging.
			bodyStr = "App:\(myAppName) V:\(myAppVers)\nDevice:\(userDevName)\niOS Ver :\(userDeviceOS)\nViewCont:\(currentViewCont ?? "")\n\(withExtraText ?? "")"
		} else {
			bodyStr = "\n\(withExtraText ?? "")"
		}
		myMailCVC.setMessageBody(bodyStr, isHTML: false)// If you embed a link to your App/Website change HTML to true.
		if ((self.snapShotImage) != nil){
			guard let attachmentData = self.snapShotImage?.pngData() else { return }
			myMailCVC.addAttachmentData(attachmentData, mimeType: "image/png", fileName: "ScreenShot.png")
		}
		myMailCVC.mailComposeDelegate = self
		self.window?.rootViewController?.present(myMailCVC, animated: true, completion: {})
	}

	// MARK: - MFMailComposeViewControllerDelegate

	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true) {}
	}
}
