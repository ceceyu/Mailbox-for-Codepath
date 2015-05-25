//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Cece Yu on 5/20/15.
//  Copyright (c) 2015 Cece Yu. All rights reserved.
//


import UIKit

class MailboxViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var laterView: UIView!
    @IBOutlet weak var archiveView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rescheduleView: UIImageView!
    @IBOutlet weak var listView: UIImageView!
    
    @IBOutlet weak var deleteIconView: UIImageView!
    @IBOutlet weak var laterIconView: UIImageView!
    @IBOutlet weak var listIconView: UIImageView!
    @IBOutlet weak var archiveIconView: UIImageView!
    
    @IBOutlet weak var composeButton: UIButton!
    @IBOutlet weak var newComposeView: UIView!
    @IBOutlet weak var newMessage: UIImageView!
    
    var messageOriginalCenter: CGPoint!
    
//    var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
//    edgeGesture.edges = UIRectEdge.Left
//    contentView.addGestureRecognizer(edgeGesture)

    
    // Swiping breakpoints
    var grayBreakpoint = CGFloat(-20)
    var yellowBreakpoint = CGFloat(-60)
    var brownBreakpoint = CGFloat(-240)
    var grayLeftBreakpoint = CGFloat(20)
    var greenBreakpoint = CGFloat(60)
    var redBreakpoint = CGFloat(240)
    
    //Colors
    let blueColor = UIColor(red: 68/255, green: 170/255, blue: 210/255, alpha: 1)
    let yellowColor = UIColor (red: 254/255, green: 202/255, blue: 22/255, alpha: 1)
    let brownColor = UIColor(red: 206/255, green: 150/255, blue: 98/255, alpha: 1)
    let greenColor = UIColor(red: 85/255, green: 213/255, blue: 90/255, alpha: 1)
    let redColor = UIColor(red: 231/255, green: 65/255, blue: 14/255, alpha: 1)
    let grayColor = UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: 320, height: 1202)
        rescheduleView.alpha = 0
        listView.alpha = 0
        laterIconView.alpha = 0
        listIconView.alpha = 0
        deleteIconView.alpha = 0
        archiveIconView.alpha = 0
        archiveView.center.x = 480
        laterView.center.x = -160
        newComposeView.alpha = 0
        newMessage.center.y = 800
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func onMessagePan(sender: UIPanGestureRecognizer) {
        
        //  DESIRED ORDER OF ANIMATIONS, SWIPE RIGHT TO REVEAL RESCHEDULE
        //      onLoad: clock icon is at default location, alpha 0
        //      onLoad: list icon is at default location, alpha 0
        //      onLoad: containerView background color is gray
        //      PAN CHANGED
        //      clock icon fades to alpha 1. 0 until messageView is (1/4)yellowBreakpoint then is alpha 1 when yellowBreakpoint is reached.
        //      Let yellowBreakpoint be the point that messageview.center needs to be for containerView to be yellow
        //      When messageView.x >= yellowBreakpoint, icon.center starts moving to the left by a distance of translation.x - iconBox. Also, containerView background color turns yellow.
        //      Let brownBreakpoint
        //      When messageView > brownBreakpoint, clock icon goes to alpha 0, and list icon goes to alpha 1
        //      PAN ENDS:
        //      if messageView.center.x >= yellowBreakpoint.x, messageView.center.x animates all the way to edge, and then the reschedule screen animates to alpha 1
        //      Else, if messageView.center > brownBreakpoint, messageView.center.x animates all the way to edge and the list screen animates to alpha 1
        //      Else, if messageView.center < yellowBreakpoint, messageView animates back to original position.
        //      Once message.center.x reaches the middle of the screen, the
        var location = sender.locationInView(view)
        var velocity = sender.velocityInView(view)
        var translation = sender.translationInView(view)
        
        //BEGAN
        if sender.state == UIGestureRecognizerState.Began {
            messageOriginalCenter = messageImageView.center
        
        //CHANGED
        } else if sender.state == UIGestureRecognizerState.Changed {
            messageImageView.center = CGPoint(x: messageOriginalCenter.x + translation.x, y: messageOriginalCenter.y)
            if translation.x > grayBreakpoint && translation.x < 0 {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.laterIconView.alpha = 0
                    self.containerView.backgroundColor = self.grayColor
                })
            } else if translation.x > yellowBreakpoint && translation.x < grayBreakpoint {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.laterIconView.alpha = 0.2
                    self.containerView.backgroundColor = self.grayColor
                })
            } else if translation.x < yellowBreakpoint && translation.x > brownBreakpoint {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.containerView.backgroundColor = self.yellowColor
                    self.laterIconView.alpha = 1
                    self.listIconView.alpha = 0
                })
                laterIconView.center.x = 350 - (abs(translation.x))
            } else if translation.x < brownBreakpoint {
                containerView.backgroundColor = self.brownColor
                laterIconView.alpha = 0
                listIconView.alpha = 1
                listIconView.center.x = 350 - (abs(translation.x))
            } else if translation.x > greenBreakpoint && translation.x < redBreakpoint {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.containerView.backgroundColor = self.greenColor
                    self.archiveIconView.alpha = 1
                    self.deleteIconView.alpha = 0
                })
                archiveIconView.center.x = (abs(translation.x)) - 30
            } else if translation.x > redBreakpoint {
                containerView.backgroundColor = self.redColor
                archiveIconView.alpha = 0
                deleteIconView.alpha = 1
                deleteIconView.center.x = (abs(translation.x)) - 30
            } else if translation.x < greenBreakpoint && translation.x > 0 {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.archiveIconView.alpha = 0.2
                    self.containerView.backgroundColor = self.grayColor
                })
            } else if translation.x < grayLeftBreakpoint && translation.x > 0 {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.archiveIconView.alpha = 0
                    self.containerView.backgroundColor = self.grayColor
                })
            }
        
        //ENDED
        } else if sender.state == UIGestureRecognizerState.Ended {
            laterIconView.alpha = 0
            listIconView.alpha = 0
            archiveIconView.alpha = 0
            deleteIconView.alpha = 0
            if translation.x < yellowBreakpoint && translation.x > brownBreakpoint {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.messageImageView.center.x = self.messageImageView.center.x - 380
                    self.containerView.backgroundColor = self.yellowColor
                    }, completion: { (Bool) -> Void in
                        delay(0.2) {
                            self.rescheduleView.alpha = 1
                            self.messageImageView.center = self.messageOriginalCenter
                        }
                })
            } else if translation.x < brownBreakpoint {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.messageImageView.center.x = self.messageImageView.center.x - 300
                    self.containerView.backgroundColor = self.brownColor
                    }, completion: { (Bool) -> Void in
                        delay(0.2) {
                            self.listView.alpha = 1
                            self.messageImageView.center = self.messageOriginalCenter
                        }
                })
            } else {
                messageImageView.center = messageOriginalCenter
                containerView.backgroundColor = self.grayColor
            }
        }
    } //end pan gesture recognizer
    
        
    @IBAction func onComposeTap(sender: AnyObject) {
        newMessage.center.y = 800
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.newComposeView.alpha = 1
        })
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.newMessage.center.y = 200
        })
    }
    
    @IBAction func onTapCancel(sender: AnyObject) {
        newMessage.center.y = 200
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.newMessage.center.y = 800
        })
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.newComposeView.alpha = 0
        })
    }
    
    @IBAction func onListViewTap(sender: UITapGestureRecognizer) {
        listView.alpha = 0
    }
    
    @IBAction func onScheduleViewTap(sender: UITapGestureRecognizer) {
        rescheduleView.alpha = 0
    }
    
    @IBAction func segmentedController(sender: AnyObject) {
        println(segmentedControl.selectedSegmentIndex)
        switch segmentedControl.selectedSegmentIndex
        {
            //Later View
        case 0:
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.laterView.center.x = 160
                self.archiveView.center.x = 480
                self.segmentedControl.tintColor = self.yellowColor
            })
            
            //Default View
        case 1:
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.laterView.center.x = -160
                self.archiveView.center.x = 480
                self.segmentedControl.tintColor = self.blueColor
            })
            
            //Archive View
        case 2:
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.laterView.center.x = -160
                self.archiveView.center.x = 160
                self.segmentedControl.tintColor = self.greenColor
            })
            
            //Default View Again
        default:
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.laterView.center.x = -160
                self.archiveView.center.x = 480
                self.segmentedControl.tintColor = self.blueColor
            })
        } //End switch
    }//End segmented controller
    




}//End UI View controller


