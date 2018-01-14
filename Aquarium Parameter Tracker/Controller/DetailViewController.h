//
//  DetailViewController.h
//  Aquarium Aquameter Tracker
//
//  Created by Duy Le on 12/2/17.
//  Copyright © 2017 Duy Le. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

- (IBAction)cancelBtnPressed:(id)sender;
- (IBAction)doneBtnPressed:(id)sender;
    @property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
    
-(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer;
-(void)slideToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer;
    

@property (weak, nonatomic) IBOutlet UITextField *chemTF;

- (void) showAlertWrongFormat;



@end
