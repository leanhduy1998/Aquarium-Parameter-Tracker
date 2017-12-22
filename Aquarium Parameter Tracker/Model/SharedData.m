//
//  SharedData.m
//  Aquarium Parameter Tracker
//
//  Created by Duy Le on 12/9/17.
//  Copyright © 2017 Duy Le. All rights reserved.
//

#import "SharedData.h"

@implementation SharedData
@synthesize timeArray;


+ (id)sharedManager {
    static SharedData *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        timeArray = [[NSString alloc] initWithString:@"Default Property Value"];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}





@end
