//
//  ViewController.m
//  Aquarium Aquameter Tracker
//
//  Created by Duy Le on 12/1/17.
//  Copyright © 2017 Duy Le. All rights reserved.
//

#import "PHViewController.h"
#import "CoreData/CoreData.h"
#import "PNChart.h"
#import "AppDelegate.h"

@interface PHViewController ()

@property (strong,nonatomic)NSMutableArray *timeArray;

@property (strong,nonatomic)NSMutableArray *timeLabels;

@property (strong,nonatomic)NSMutableArray *phData;
@property (strong,nonatomic)NSMutableArray *ammoniaData;
@property (strong,nonatomic)NSMutableArray *nitriteData;
@property (strong,nonatomic)NSMutableArray *nitrateData;

typedef enum{
    Year = 1,
    Month = 2,
    Day = 3,
    Hour = 4,
} ZoomMode;

extern int currentMode = 3;


@end

@implementation PHViewController

- (NSManagedObjectContext *) managedObjectContext{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate respondsToSelector:@selector(persistentContainer)]) {
        context = [[delegate persistentContainer]viewContext];
    }
    return context;
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _timeLabels = [[NSMutableArray alloc]init];
    _phData = [[NSMutableArray alloc]init];
    _ammoniaData = [[NSMutableArray alloc]init];
    _nitriteData = [[NSMutableArray alloc]init];
    _nitrateData = [[NSMutableArray alloc]init];
    ZoomMode currentZoom = Day;
    int a = currentZoom;
}

- (void)loadLineChart {
    [_lineChart setXLabels:_timeLabels];
 //   [_lineChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5",@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
    
    // Line Chart No.1
    
    PNLineChartData *phLine = [PNLineChartData new];
    phLine.color = PNLightBlue;
    phLine.itemCount = _lineChart.xLabels.count;
    phLine.getData = ^(NSUInteger index) {
        CGFloat yValue = [_phData[index] floatValue];
        if(yValue == -1){
            if(index == 0){
                yValue = 0;
            }
            else if(index==([_phData count]-1)){
                yValue = [_phData[index-1] floatValue];
            }
            else{
                yValue = ([_phData[index-1] floatValue] + [_phData[index+1] floatValue])/2;
            }
        }
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    PNLineChartData *ammoniaLine = [PNLineChartData new];
    ammoniaLine.color = PNYellow;
    ammoniaLine.itemCount = _lineChart.xLabels.count;
    ammoniaLine.getData = ^(NSUInteger index) {
        CGFloat yValue = [_ammoniaData[index] floatValue];
        if(yValue == -1){
            if(index == 0){
                yValue = 0;
            }
            else if(index==([_ammoniaData count]-1)){
                yValue = [_ammoniaData[index-1] floatValue];
            }
            else{
                yValue = ([_ammoniaData[index-1] floatValue] + [_ammoniaData[index+1] floatValue])/2;
            }
        }
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    PNLineChartData *nitriteLine = [PNLineChartData new];
    nitriteLine.color = PNBlue;
    nitriteLine.itemCount = _lineChart.xLabels.count;
    nitriteLine.getData = ^(NSUInteger index) {
        CGFloat yValue = [_nitriteData[index] floatValue];
        if(yValue == -1){
            if(index == 0){
                yValue = 0;
            }
            else if(index==([_nitriteData count]-1)){
                yValue = [_nitriteData[index-1] floatValue];
            }
            else{
                yValue = ([_nitriteData[index-1] floatValue] + [_nitriteData[index+1] floatValue])/2;
            }
        }
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    PNLineChartData *nitrateLine = [PNLineChartData new];
    nitrateLine.color = PNRed;
    nitrateLine.itemCount = _lineChart.xLabels.count;
    nitrateLine.getData = ^(NSUInteger index) {
        CGFloat yValue = [_nitrateData[index] floatValue];
        if(yValue == -1){
            if(index == 0){
                yValue = 0;
            }
            else if(index==([_nitrateData count]-1)){
                yValue = [_nitrateData[index-1] floatValue];
            }
            else{
                yValue = ([_nitrateData[index-1] floatValue] + [_nitrateData[index+1] floatValue])/2;
            }
        }
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    _lineChart.chartData = @[phLine, ammoniaLine, nitriteLine, nitrateLine];
    [_lineChart strokeChart];
    
    _lineChart.showSmoothLines = YES;
}

- (void)test{
    [_phData addObjectsFromArray:@[@1,@2.5,@4,@8,@9,@4,@3,@0,@2,@5,@1,@2.5,@4,@8,@9,@4,@3,@0,@2,@5,@1,@2.5,@4,@8,@9,@4,@3,@0,@2,@5]];
    [_ammoniaData addObjectsFromArray:@[@0,@0.25,@0.5,@1,@2,@4,@8,@2,@1,@4,@0,@0.25,@0.5,@1,@2,@4,@8,@2,@1,@4,@0,@0.25,@0.5,@1,@2,@4,@8,@2,@1,@4]];
    [_nitriteData addObjectsFromArray:@[@0,@0.25,@0.5,@1,@2,@5,@0.5,@1,@0.25,@0,@0,@0.25,@0.5,@1,@2,@5,@0.5,@1,@0.25,@0,@0,@0.25,@0.5,@1,@2,@5,@0.5,@1,@0.25,@0]];
    [_nitrateData addObjectsFromArray:@[@0,@5,@10,@20,@40,@80,@160,@0,@5,@10,@0,@5,@10,@20,@40,@80,@160,@0,@5,@10,@0,@5,@10,@20,@40,@80,@160,@0,@5,@10]];
   // [_timeLabels addObjectsFromArray:@[@1,@2.5,@4,@8,@9,@4,@3,@0,@2,@5]];
    
    NSDate *date = [NSDate date];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
    NSInteger hour = [dateComponents hour];
    NSInteger minute = [dateComponents minute];
    NSInteger second = [dateComponents second];
    
    for(int i=0;i<30;i++){
        NSManagedObject *dayCore = [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:[self managedObjectContext]];
        
        [dayCore setValue:@(i) forKey:@"day"];
        
        [dayCore setValue:_phData[i] forKey:@"ph"];
        [dayCore setValue:_ammoniaData[i] forKey:@"ammonia"];
        [dayCore setValue:_nitriteData[i] forKey:@"nitrite"];
        [dayCore setValue:_nitrateData[i] forKey:@"nitrate"];
        [dayCore setValue:@(hour) forKey:@"hour"];
        [dayCore setValue:@(minute) forKey:@"minute"];
        [dayCore setValue:@(second) forKey:@"second"];
        
        
        NSManagedObject *monthCore = [NSEntityDescription insertNewObjectForEntityForName:@"Month" inManagedObjectContext:[self managedObjectContext]];
        [monthCore setValue:@(month) forKey:@"month"];
        [monthCore setValue:dayCore forKey:@"monthDay"];
        
        NSManagedObject *yearCore = [NSEntityDescription insertNewObjectForEntityForName:@"Year" inManagedObjectContext:[self managedObjectContext]];
        [yearCore setValue:@(year) forKey:@"year"];
        
        [yearCore setValue:monthCore forKey:@"yearMonth"];
    }
    
    [_phData removeAllObjects];
    [_ammoniaData removeAllObjects];
    [_nitriteData removeAllObjects];
    [_nitrateData removeAllObjects];
}

- (void)loadData {
    [_timeLabels removeAllObjects];
    [_phData removeAllObjects];
    [_ammoniaData removeAllObjects];
    [_nitriteData removeAllObjects];
    [_nitrateData removeAllObjects];
    
    
    [self test];
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Year"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"year" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSError *error ;
    NSArray *yearArray= [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    

    NSDate *date = [NSDate date];
    

    NSArray* newArray = [yearArray sortedArrayUsingComparator: ^NSComparisonResult(NSManagedObject *yearCore1, NSManagedObject *yearCore2)
    {
        NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
        NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
        
        
        NSManagedObject *monthCore1 = [yearCore1 valueForKey:@"yearMonth"];
        NSManagedObject *monthCore2 = [yearCore2 valueForKey:@"yearMonth"];
        
        
        NSManagedObject *dayCore1 = [monthCore1 valueForKey:@"monthDay"];
        NSManagedObject *dayCore2 = [monthCore2 valueForKey:@"monthDay"];
        
        [components1 setYear:[[yearCore1 valueForKey:@"year"] integerValue]];
        [components1 setMonth:[[monthCore1 valueForKey:@"month"] integerValue]];
        [components1 setDay:[[dayCore1 valueForKey:@"day"] integerValue]];
        [components1 setHour:[[dayCore1 valueForKey:@"hour"] integerValue]];
        [components1 setMinute:[[dayCore1 valueForKey:@"minute"] integerValue]];
        [components1 setSecond:[[dayCore1 valueForKey:@"second"] integerValue]];
        
        [components2 setYear:[[yearCore2 valueForKey:@"year"] integerValue]];
        [components2 setMonth:[[monthCore2 valueForKey:@"month"] integerValue]];
        [components2 setDay:[[dayCore2 valueForKey:@"day"] integerValue]];
        [components2 setHour:[[dayCore2 valueForKey:@"hour"] integerValue]];
        [components2 setMinute:[[dayCore2 valueForKey:@"minute"] integerValue]];
        [components2 setSecond:[[dayCore2 valueForKey:@"second"] integerValue]];
        
        
        NSDate *d1 = components1.date;
        NSDate *d2 = components2.date;
        
        return [d1 compare:d2];
    }];
    
    yearArray = newArray;
    
    [_timeArray removeAllObjects];
    [_timeArray addObjectsFromArray:yearArray];
    
    
    for (int i = 0; i < [yearArray count]; i++){
        NSManagedObject *yearCore = yearArray[i];
        NSManagedObject *monthCore = [yearCore valueForKey:@"yearMonth"];
        NSManagedObject *dayCore = [monthCore valueForKey:@"monthDay"];
        
        NSNumber *ph = [NSNumber numberWithFloat:[[dayCore valueForKey:@"ph"] floatValue]] ;
        [_phData addObject:ph];
        NSNumber *ammonia = [NSNumber numberWithFloat:[[dayCore valueForKey:@"ammonia"] floatValue]] ;
        [_ammoniaData addObject:ammonia];
        NSNumber *nitrite = [NSNumber numberWithFloat:[[dayCore valueForKey:@"nitrite"] floatValue]] ;
        [_nitriteData addObject:nitrite];
        NSNumber *nitrate = [NSNumber numberWithFloat:[[dayCore valueForKey:@"nitrate"] floatValue]] ;
        [_nitrateData addObject:nitrate];
        
        NSLog(@"%@/%@/%@",[[monthCore valueForKey:@"month"] stringValue],[[dayCore valueForKey:@"day"] stringValue], [[yearCore valueForKey:@"year"] stringValue]);
        
        NSString *label = [NSString stringWithFormat:@"%ld/%ld", [[monthCore valueForKey:@"month"] integerValue], [[dayCore valueForKey:@"day"] integerValue]];
        
        [_timeLabels addObject:label];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    [self loadData];
    [self loadLineChart];
   // self.years = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end