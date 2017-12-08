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

@property (weak, nonatomic) IBOutlet UITextField *phTextField;
@property (weak, nonatomic) IBOutlet UITextField *ammoniaTF;
@property (weak, nonatomic) IBOutlet UITextField *nitriteTF;
@property (weak, nonatomic) IBOutlet UITextField *nitrateTF;

- (void) showAlertWrongFormat;



@end
