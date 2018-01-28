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

+  (void)loadLineChart: (NSMutableArray*)timeLabels chemData: (NSMutableArray*)chemData sortedDateArr :(NSMutableArray*)sortedDateArr currentPage :(int)currentPage totalPage :(int)totalPage dataDic:(NSMutableDictionary*)dataDic lineChart :(PNLineChart*)lineChart noDataLabel :(UILabel*)noDataLabel chemLine :(PNLineChartData*) chemLine chemNum :(int) chemNum;
+ (void)loadData: (NSManagedObjectContext*)managedObjectContext :(NSMutableDictionary*) dataDic :(NSMutableArray*) sortedDateArr :(int*) totalPage :(int*) currentPage;
+ (void)loadSlider: (int)totalPage :(UISlider*) slider :(UINavigationItem*) navigationItem;

@end
