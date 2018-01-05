//
//  Helper.h
//  Aquarium Parameter Tracker
//
//  Created by Duy Le on 1/4/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import "PNChart.h"
#import "UIKit/UIKit.h"

@interface Helper : NSObject

+  (void)loadLineChart:(NSMutableArray*)timeLabels: (NSMutableArray*) chemData: (NSMutableArray*) sortedDateArr: (int)currentPage :(int)totalPage: (NSMutableDictionary*) dataDic: (PNLineChart*) lineChart: (UILabel*) noDataLabel: (PNLineChartData*) chemLine: (int) chemNum;
+ (void)loadData: (NSManagedObjectContext*)managedObjectContext: (NSMutableDictionary*) dataDic: (NSMutableArray*) sortedDateArr: (int*) totalPage: (int*) currentPage;
+ (void)loadSlider: (int) totalPage: (UISlider*) slider: (UILabel*) pageLabel;

@end
