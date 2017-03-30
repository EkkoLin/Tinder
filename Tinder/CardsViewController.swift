//
//  CardsViewController.swift
//  Tinder
//
//  Created by Ekko Lin on 3/28/17.
//  Copyright © 2017 CodePath. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController {

    @IBOutlet weak var photoImage: UIImageView!
    
    var cardInitialCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
        let viewWidth = view.frame.width
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        let location = sender.location(in: photoImage)
        let touchStart = Date()
        var direction: Double = 1
        
        if(velocity.x < 0 && location.y > photoImage.frame.midY) || (velocity.x
            > 0 && location.y < photoImage.frame.midY) {
            direction = -1
        }
        
        if sender.state == .began {
            cardInitialCenter = CGPoint(x: photoImage.frame.midX, y: photoImage.frame.midY)
        } else if sender.state == .changed {
            let touchEnd = Date()
            let timeDelta: Double = touchEnd.timeIntervalSince(touchStart)
            let rotation = (0.1 / timeDelta < 0.99) ? 0.1 / timeDelta: 0.99
            
            photoImage.transform = photoImage.transform.translatedBy(x: translation.x, y: 0)
            photoImage.transform = photoImage.transform.rotated(by: CGFloat(direction * rotation * Double.pi / 180))
        } else if sender.state == .ended {
            if velocity.x > 50 {
                UIView.animate(withDuration: 0, animations: {
                    self.photoImage.transform = self.photoImage.transform.translatedBy(x: viewWidth, y: 0)
                }, completion: nil)
            } else if velocity.x < -50 {
                UIView.animate(withDuration: 0, animations: {
                    self.photoImage.transform = self.photoImage.transform.translatedBy(x: -1 * viewWidth, y: 0)
                }, completion: nil)
            } else {
                photoImage.transform = CGAffineTransform.identity
            }
        }
    }

    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        print("haha")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let vc = segue.destination as! DetailViewController
        vc.image = photoImage.image
    }
}
