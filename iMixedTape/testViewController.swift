//
//  testViewController.swift
//  iMixedTape
//
//  Created by Mustafa on 28/03/2017.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

import UIKit


class testViewController: UIViewController {

    @IBOutlet var testView: UIView!
    @IBOutlet var testlabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        DispatchQueue.main.async {
            
        
        self.testlabel.transform = CGAffineTransform(rotationAngle: CGFloat(-0.50));
        self.testlabel.frame = self.CGRectMake(0, 0, self.testView.frame.size.width, self.testlabel.frame.size.height);
            
    }
        
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
