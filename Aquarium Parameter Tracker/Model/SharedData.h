//
//  SharedData.h
//  Aquarium Parameter Tracker
//
//  Created by Duy Le on 12/9/17.
//  Copyright © 2017 Duy Le. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedData : NSObject {
    NSMutableArray *timeArray;
}

@property (nonatomic, retain) NSMutableArray *timeArray;

+ (id)sharedManager;

@end
