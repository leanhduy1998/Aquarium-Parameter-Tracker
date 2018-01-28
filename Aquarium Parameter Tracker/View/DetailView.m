//
//  DetailView.m
//  Aquarium Parameter Tracker
//
//  Created by Duy Le 2 on 1/27/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

#import "DetailView.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>

@implementation DetailView    
    typedef enum{
        ph = 0,
        ammonia = 1,
        nitrite = 2,
        nitrate = 3,
    } ChemType;
    
    + (void) changeBackgroundIVcolor:(UIImageView*)backgroundIV redFloat:(float)red greenFloat:(float)green blueFloat:(float)blue {
         [UIView animateWithDuration:1.0 animations:^{
             backgroundIV.backgroundColor = [UIColor
                                             colorWithRed:red/255.0f
                                             green:green/255.0f
                                             blue:blue/255.0f
                                             alpha:1.0f];
         }];
    }
    
    + (void) displayLabelAndBackgroundColorForCurrentChemStats: (int)currentChem chemLabel :(UILabel*)chemLabel backgroundImageView :(UIImageView*)backgroundImageView currentPh :(int)currentPh currentAmmonia :(int)currentAmmonia  currentNitrite :(int)currentNitrite currentNitrate :(int)currentNitrate{
        switch(currentChem){
            case ph:
            chemLabel.text = @"pH Level";
            
            
            if(currentPh <=0){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:179.0f greenFloat:236.0f blueFloat:255.0f];
            }
            else if(currentPh < 6){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:255.0f greenFloat:255.0f blueFloat:255.0f];
            }
            else if(currentPh >= 6 && currentPh <= 6.4){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:245.0f greenFloat:253.0f blueFloat:161.0f];
            }
            else if(currentPh > 6.4 && currentPh <= 6.6){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:206.0f greenFloat:238.0f blueFloat:156.0f];
            }
            else if(currentPh > 6.6 && currentPh <= 6.8){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:183.0f greenFloat:231.0f blueFloat:170.0f];
            }
            else if(currentPh > 6.8 && currentPh <= 7){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:162.0f greenFloat:220.0f blueFloat:162.0f];
            }
            else if(currentPh > 7 && currentPh <= 7.2){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:138.0f greenFloat:212.0f blueFloat:170.0f];
            }
            else if(currentPh > 7.4 && currentPh <= 7.6){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:103.0f greenFloat:193.0f blueFloat:192.0f];
            }
            else if(currentPh > 7.2 && currentPh <= 7.4){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:236.0f greenFloat:183.0f blueFloat:36.0f];
            }
            else if(currentPh > 7.6 && currentPh <= 7.8){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:247.0f greenFloat:188.0f blueFloat:84.0f];
            }
            else if(currentPh > 7.8 && currentPh <= 8){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:220.0f greenFloat:160.0f blueFloat:106.0f];
            }
            else if(currentPh > 8 && currentPh <= 8.2){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:183.0f greenFloat:126.0f blueFloat:107.0f];
            }
            else if(currentPh > 8.2 && currentPh <= 8.4){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:161.0f greenFloat:119.0f blueFloat:165.0f];
            }
            else if(currentPh > 8.4){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:135.0f greenFloat:106.0f blueFloat:160.0f];
            }
            break;
            
            case ammonia:
            chemLabel.text = @"Ammonia Level";
            if(currentAmmonia <= 0){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:250.0f greenFloat:244.0f blueFloat:44.0f];
            }
            else if(currentAmmonia > 0 && currentAmmonia <= 0.25){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:246.0f greenFloat:244.0f blueFloat:12.0f];
            }
            else if(currentAmmonia > 0.25 && currentAmmonia <= 0.5){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:219.0f greenFloat:236.0f blueFloat:44.0f];
            }
            else if(currentAmmonia > 0.5 && currentAmmonia <= 1){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:179.0f greenFloat:219.0f blueFloat:68.0f];
            }
            else if(currentAmmonia > 1 && currentAmmonia <= 2){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:114.0f greenFloat:193.0f blueFloat:60.0f];
            }
            else if(currentAmmonia > 2 && currentAmmonia <= 4){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:48.0f greenFloat:167.0f blueFloat:64.0f];
            }
            else if(currentAmmonia > 4){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:39.0f greenFloat:118.0f blueFloat:68.0f];
            }
            break;
            
            case nitrite:
            chemLabel.text = @"Nitrite Level";
            if(currentNitrite <= 0){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:180.0f greenFloat:230.0f blueFloat:218.0f];
            }
            else if(currentNitrite > 0 && currentNitrite <= 0.25){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:173.0f greenFloat:184.0f blueFloat:214.0f];
            }
            else if(currentNitrite > 0.25 && currentNitrite <= 0.5){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:156.0f greenFloat:148.0f blueFloat:187.0f];
            }
            else if(currentNitrite > 0.5 && currentNitrite <= 1){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:149.0f greenFloat:126.0f blueFloat:168.0f];
            }
            else if(currentNitrite > 1 && currentNitrite <= 2){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:165.0f greenFloat:110.0f blueFloat:165.0f];
            }
            else if(currentNitrite > 2){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:160.0f greenFloat:101.0f blueFloat:159.0f];
            }
            break;
            
            case nitrate:
            chemLabel.text = @"Nitrate Level";
            if(currentNitrate <= 0){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:248.0f greenFloat:251.0f blueFloat:7.0f];
            }
            else if(currentNitrate > 0 && currentNitrate <= 5){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:250.0f greenFloat:199.0f blueFloat:27.0f];
            }
            else if(currentNitrate > 5 && currentNitrate <= 10){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:246.0f greenFloat:164.0f blueFloat:32.0f];
            }
            else if(currentNitrate > 10 && currentNitrate <= 20){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:240.0f greenFloat:168.0f blueFloat:70.0f];
            }
            else if(currentNitrate > 20 && currentNitrate <= 40){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:238.0f greenFloat:107.0f blueFloat:65.0f];
            }
            else if(currentNitrate > 40 && currentNitrate <= 80){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:232.0f greenFloat:105.0f blueFloat:62.0f];
            }
            else if(currentNitrate > 80){
                [self changeBackgroundIVcolor:backgroundImageView redFloat:189.0f greenFloat:82.0f blueFloat:71.0f];
            }
            break;
            
            default:
            break;
        }
    }
    @end
        
