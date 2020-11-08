//
//  ViewController.swift
//  SystemViewController
//
//  Created by Rohit Jangid on 05/11/20.
//

import UIKit
import SafariServices
import MessageUI

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func shareButtonTapped(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender
        
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func safariButtonTapped(_ sender: UIButton) {
        if let url = URL(string: "http://www.apple.com") {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func photosButtonTapped(_ sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
                
        let alertController = UIAlertController(title: "Choose Image Source", message: nil , preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(photoLibraryAction)
        }

        alertController.addAction(cancelAction)
        alertController.popoverPresentationController?.sourceView = sender
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            print("Can not send mail")
            return
        }
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        
        mailComposer.setToRecipients(["example@domain.com"])
        mailComposer.setSubject("New Mail")
        mailComposer.setMessageBody("Hello, this is an email from the app I made.", isHTML: false)
        mailComposer.addAttachmentData((imageView.image?.jpegData(compressionQuality: 0.8))!, mimeType: "image/jpeg", fileName: "/")
        present(mailComposer, animated: true, completion: nil)
    }
    
    @IBAction func messageButtonTapped(_ sender: UIButton) {
        guard MFMessageComposeViewController.canSendText() && MFMessageComposeViewController.canSendAttachments() else {
            print("Can not send message")
            return
        }
        
        let messageComposer = MFMessageComposeViewController()
        messageComposer.messageComposeDelegate = self
        messageComposer.addAttachmentData((imageView.image?.jpegData(compressionQuality: 0.8))!, typeIdentifier: "public.data", filename: "imageView.jpeg")
        messageComposer.body = "Hello this message is from the app I made."
        
        present(messageComposer, animated: true, completion: nil)
    }
}


//MARK: - UIImagePickerControllerDelegate

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
        imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - UINavigationControllerDelegate

extension ViewController: UINavigationControllerDelegate {}

//MARK: - MFMailComposeViewControllerDelegate

extension ViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - MFMessageComposeViewControllerDelegate

extension ViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
}
