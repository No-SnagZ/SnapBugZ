//
//  ViewController.swift
//  SnapBugZ
//
//  Created by Shawn Marston on 13/09/2019.
//  Copyright © 2019 No-SnagZ Software. All rights reserved.
//  www.no-snagz.com
//
/*
##################################
#                                #
# Nothing in this ViewController #
#     is useful for your app     #
#     see AppDelegate instead    #
#                                #
##################################
*/

import UIKit
import MessageUI

class ViewController: UIViewController {

	@IBOutlet var simScreenShotButton: UIButton!
	@IBOutlet var textView: UITextView!

	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		#if targetEnvironment(simulator)
		simScreenShotButton.isHidden = false
		#else
		simScreenShotButton.isHidden = true
		#endif
	}


	override func viewWillAppear(_ animated: Bool) {
		#if targetEnvironment(simulator)
		if MFMailComposeViewController.canSendMail() {
			simScreenShotButton.titleLabel?.text = "Simulate Screen Snapshot"
		} else {
			simScreenShotButton.setTitle("Cannot Send eMail",  for: .disabled)
			simScreenShotButton.isEnabled = false
		}
		#endif
		let html = "<div style=\"font-family: 'Arial'; font-size: 28; text-align: center;\">SnapBugZ</br>by</br>Shawn Marston</br><a href=\"http://www.no-snagz.com\">No-SnagZ Software Ltd</a></p>Take a <a href=\"https://support.apple.com/en-us/HT200289\">ScreenShot</a> to test.</div>"

		if let dataWithHTML = html.data(using: .utf8) {

			textView.attributedText = try? NSAttributedString(data: dataWithHTML, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
		}
	}
	@IBAction func simulateScreenShot(_ sender: Any) {
		appDelegate.self.takeScreenshotAndAlert()
	}

}

