//
//  Helper.m
//  Aquarium Parameter Tracker
//
//  Created by Duy Le on 1/4/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

#import "Helper.h"
#import <Foundation/Foundation.h>
#import "CoreData/CoreData.h"
#import "PNChart.h"
#import "UIKit/UIKit.h"

@implementation Helper

+  (void)loadLineChart: (NSMutableArray*)timeLabels chemData: (NSMutableArray*)chemData sortedDateArr :(NSMutableArray*)sortedDateArr currentPage :(int)currentPage totalPage :(int)totalPage dataDic:(NSMutableDictionary*)dataDic lineChart :(PNLineChart*)lineChart noDataLabel :(UILabel*)noDataLabel chemLine :(PNLineChartData*) chemLine chemNum :(int) chemNum{
    
    [timeLabels removeAllObjects];
    [chemData removeAllObjects];
    
    if(currentPage == totalPage){
        for (int i = (currentPage-1)*5; i < currentPage*5; i++){
            if(i >= sortedDateArr.count){
                break;
            }
            
            NSManagedObject *yearCore = [dataDic objectForKey:sortedDateArr[i]];
            NSManagedObject *monthCore = [yearCore valueForKey:@"yearMonth"];
            NSManagedObject *dayCore = [monthCore valueForKey:@"monthDay"];
            
            NSNumber *chem;
            switch(chemNum){
                case 0:
                    chem = [NSNumber numberWithFloat:[[dayCore valueForKey:@"ph"] floatValue]] ;
                    break;
                case 1:
                    chem = [NSNumber numberWithFloat:[[dayCore valueForKey:@"ammonia"] floatValue]] ;
                    break;
                case 2:
                    chem = [NSNumber numberWithFloat:[[dayCore valueForKey:@"nitrite"] floatValue]] ;
                    break;
                case 3:
                    chem = [NSNumber numberWithFloat:[[dayCore valueForKey:@"nitrate"] floatValue]] ;
                    break;
            }
            
            NSNumber *temp = [NSNumber numberWithInt:-1];
            
            if(![chem isEqualToNumber:temp]){
                NSString *label = [NSString stringWithFormat:@"%ld/%ld", [[monthCore valueForKey:@"month"] integerValue], [[dayCore valueForKey:@"day"] integerValue]];
                
                [timeLabels addObject:label];
                [chemData addObject:chem];
            }
        }
        
    }
    else{
        for (int i = (currentPage-1)*5; i < currentPage*5; i++){
            NSManagedObject *yearCore = [dataDic objectForKey:sortedDateArr[i]];
            NSManagedObject *monthCore = [yearCore valueForKey:@"yearMonth"];
            NSManagedObject *dayCore = [monthCore valueForKey:@"monthDay"];
            
        
            NSNumber *chem = [NSNumber numberWithFloat:[[dayCore valueForKey:@"ammonia"] floatValue]] ;
            
            NSNumber *temp = [NSNumber numberWithInt:-1];
            
            if(![chem isEqualToNumber:temp]){
                NSString *label = [NSString stringWithFormat:@"%ld/%ld", [[monthCore valueForKey:@"month"] integerValue], [[dayCore valueForKey:@"day"] integerValue]];
                
                [timeLabels addObject:label];
                [chemData addObject:chem];
            }
            
            
        }
    }
    
    if(timeLabels.count==0){
        [noDataLabel setHidden:NO];
        [lineChart setHidden:YES];
        return;
    }
    [noDataLabel setHidden:YES];
    [lineChart setHidden:NO];
    
    [lineChart setXLabels:timeLabels];

    chemLine.itemCount = lineChart.xLabels.count;
    chemLine.getData = ^(NSUInteger index) {
        CGFloat yValue = [chemData[index] floatValue];
        if(yValue == -1){
            if(index == 0){
                yValue = 0;
            }
            else if(index==([chemData count]-1)){
                yValue = [chemData[index-1] floatValue];
            }
            else{
                yValue = ([chemData[index-1] floatValue] + [chemData[index+1] floatValue])/2;
            }
        }
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    lineChart.chartData = @[chemLine];
    [lineChart strokeChart];
    
    lineChart.showSmoothLines = YES;
}

+ (void)loadData: (NSManagedObjectContext*)managedObjectContext :(NSMutableDictionary*) dataDic :(NSMutableArray*) sortedDateArr :(int*) totalPage :(int*) currentPage {
    
    [sortedDateArr removeAllObjects];
    *totalPage = 0;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Year"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"year" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSError *error ;
    NSArray *yearArray= [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSDate *date = [NSDate date];
    
    for(int i=0;i<yearArray.count;i++){
        NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
        
        NSCalendar* dupCal =  [[NSCalendar currentCalendar] copy];
        [components1 setCalendar:dupCal];
        
        NSManagedObject *monthCore1 = [yearArray[i] valueForKey:@"yearMonth"];
        
        NSManagedObject *dayCore1 = [monthCore1 valueForKey:@"monthDay"];
        
        [components1 setYear:[[yearArray[i] valueForKey:@"year"] integerValue]];
        [components1 setMonth:[[monthCore1 valueForKey:@"month"] integerValue]];
        [components1 setDay:[[dayCore1 valueForKey:@"day"] integerValue]];
        [components1 setHour:[[dayCore1 valueForKey:@"hour"] integerValue]];
        [components1 setMinute:[[dayCore1 valueForKey:@"minute"] integerValue]];
        [components1 setSecond:[[dayCore1 valueForKey:@"second"] integerValue]];
        
        NSDate *d1 = [components1 date];
        
        [sortedDateArr addObject:d1];
        
        [dataDic setObject:yearArray[i] forKey:d1];
    }
    
    [sortedDateArr sortUsingSelector:@selector(compare:)];
    
    int totalItems = sortedDateArr.count;
    while(totalItems>0){
        totalItems = totalItems - 5;
        *totalPage = *totalPage + 1;
    }
    *currentPage = *totalPage;
}

+ (void)loadSlider: (int)totalPage :(UISlider*) slider :(UINavigationItem*) navigationItem {
    slider.minimumValue = 1.0;
    slider.maximumValue = totalPage;
    slider.value = totalPage;
    
    NSString *pageText = [NSString stringWithFormat: @"Page %d of %d", totalPage, totalPage];
    navigationItem.title = pageText;
}

@end
