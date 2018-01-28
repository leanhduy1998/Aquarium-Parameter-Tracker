//
//  DetailView.h
//  Aquarium Parameter Tracker
//
//  Created by Duy Le 2 on 1/27/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DetailView : NSObject
    + (void) displayLabelAndBackgroundColorForCurrentChemStats: (int)currentChem chemLabel :(UILabel*)chemLabel backgroundImageView :(UIImageView*)backgroundImageView currentPh :(int)currentPh currentAmmonia :(int)currentAmmonia  currentNitrite :(int)currentNitrite currentNitrate :(int)currentNitrate;
@end
