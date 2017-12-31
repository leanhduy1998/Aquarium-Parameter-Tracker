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
#import "SharedData.h"

@interface PHViewController ()

@property (strong,nonatomic)NSMutableArray *timeLabels;

@property (strong,nonatomic)NSMutableArray *phData;
@property (strong,nonatomic)NSMutableArray *ammoniaData;
@property (strong,nonatomic)NSMutableArray *nitriteData;
@property (strong,nonatomic)NSMutableArray *nitrateData;

@property (strong,nonatomic) NSMutableDictionary *dataDic;
@property (strong,nonatomic)NSMutableArray *sortedDateArr;

@property (strong,nonatomic)SharedData *sharedManager;

@property (assign) int currentPage;
@property (assign) int totalPage;

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
    
    
    _sharedManager = [SharedData sharedManager];
    _sharedManager.timeArray = [[NSMutableArray alloc]init];
    
    _dataDic = [NSMutableDictionary new];
    
    _currentPage = 1;
    _totalPage = 0;
    
    
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToLeftWithGestureRecognizer:)];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;

    [self.view addGestureRecognizer:swipeLeftRecognizer];
    [self.view addGestureRecognizer:swipeRightRecognizer];
    
    [self test];
    [self loadData];
}

-(void)slideToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    if(_currentPage < _totalPage){
        _currentPage = _currentPage + 1;
        [self loadLineChart];
    }
}

-(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    if(_currentPage >1){
        _currentPage = _currentPage - 1;
        [self loadLineChart];
    }
}

- (IBAction)helpBtnClicked:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
        message:@"Swipe left and right to see your data."
        preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)loadLineChart {
    [_timeLabels removeAllObjects];
    [_ammoniaData removeAllObjects];
 /*   [_ammoniaData removeAllObjects];
    [_nitriteData removeAllObjects];
    [_nitrateData removeAllObjects];*/
    

  //      _totalPage = [_sharedManager.timeArray count];
        //for (int i = 0; i < [_sortedDateArr count]; i++){
    
    if(_sortedDateArr.count==0){
        [_noDataLabel setHidden:NO];
        [_lineChart setHidden:YES];
        return;
    }
    [_noDataLabel setHidden:YES];
    [_lineChart setHidden:NO];
    
    if(_currentPage == _totalPage){
        for (int i = (_currentPage-1)*5; i < _currentPage*5; i++){
            if(i >= _sortedDateArr.count){
                break;
            }
                
            NSManagedObject *yearCore = [_dataDic objectForKey:_sortedDateArr[i]];
            NSManagedObject *monthCore = [yearCore valueForKey:@"yearMonth"];
            NSManagedObject *dayCore = [monthCore valueForKey:@"monthDay"];
                
            NSNumber *ph = [NSNumber numberWithFloat:[[dayCore valueForKey:@"ph"] floatValue]] ;
                [_phData addObject:ph];
                
            NSString *label = [NSString stringWithFormat:@"%ld/%ld", [[monthCore valueForKey:@"month"] integerValue], [[dayCore valueForKey:@"day"] integerValue]];
                
            [_timeLabels addObject:label];
                
                /* NSNumber *ammonia = [NSNumber numberWithFloat:[[dayCore valueForKey:@"ammonia"] floatValue]] ;
                 [_ammoniaData addObject:ammonia];
                 NSNumber *nitrite = [NSNumber numberWithFloat:[[dayCore valueForKey:@"nitrite"] floatValue]] ;
                 [_nitriteData addObject:nitrite];
                 NSNumber *nitrate = [NSNumber numberWithFloat:[[dayCore valueForKey:@"nitrate"] floatValue]] ;
                 [_nitrateData addObject:nitrate];*/
        }

    }
    else{
        for (int i = (_currentPage-1)*5; i < _currentPage*5; i++){
            NSManagedObject *yearCore = [_dataDic objectForKey:_sortedDateArr[i]];
            NSManagedObject *monthCore = [yearCore valueForKey:@"yearMonth"];
            NSManagedObject *dayCore = [monthCore valueForKey:@"monthDay"];
                
            NSNumber *ph = [NSNumber numberWithFloat:[[dayCore valueForKey:@"ph"] floatValue]] ;
                [_phData addObject:ph];
                
            NSString *label = [NSString stringWithFormat:@"%ld/%ld", [[monthCore valueForKey:@"month"] integerValue], [[dayCore valueForKey:@"day"] integerValue]];
                
            [_timeLabels addObject:label];
                
                /* NSNumber *ammonia = [NSNumber numberWithFloat:[[dayCore valueForKey:@"ammonia"] floatValue]] ;
                 [_ammoniaData addObject:ammonia];
                 NSNumber *nitrite = [NSNumber numberWithFloat:[[dayCore valueForKey:@"nitrite"] floatValue]] ;
                 [_nitriteData addObject:nitrite];
                 NSNumber *nitrate = [NSNumber numberWithFloat:[[dayCore valueForKey:@"nitrate"] floatValue]] ;
                 [_nitrateData addObject:nitrate];*/
        }
    }
    
    
    
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
    
  /*  PNLineChartData *ammoniaLine = [PNLineChartData new];
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
    */
   // _lineChart.chartData = @[phLine, ammoniaLine, nitriteLine, nitrateLine];
    _lineChart.chartData = @[phLine];
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
    
    NSInteger year = [components year];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitHour  | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
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
        [monthCore setValue:@(1) forKey:@"month"];
        [monthCore setValue:dayCore forKey:@"monthDay"];
        
        NSManagedObject *yearCore = [NSEntityDescription insertNewObjectForEntityForName:@"Year" inManagedObjectContext:[self managedObjectContext]];
        [yearCore setValue:@(year) forKey:@"year"];
        
        [yearCore setValue:monthCore forKey:@"yearMonth"];
    }
    
    for(int i=1;i<=12;i++){
        NSManagedObject *dayCore = [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:[self managedObjectContext]];
        
        [dayCore setValue:@(1) forKey:@"day"];
        
        [dayCore setValue:_phData[i] forKey:@"ph"];
        [dayCore setValue:_ammoniaData[i] forKey:@"ammonia"];
        [dayCore setValue:_nitriteData[i] forKey:@"nitrite"];
        [dayCore setValue:_nitrateData[i] forKey:@"nitrate"];
        [dayCore setValue:@(hour) forKey:@"hour"];
        [dayCore setValue:@(minute) forKey:@"minute"];
        [dayCore setValue:@(second) forKey:@"second"];
        
        
        NSManagedObject *monthCore = [NSEntityDescription insertNewObjectForEntityForName:@"Month" inManagedObjectContext:[self managedObjectContext]];
        [monthCore setValue:@(i) forKey:@"month"];
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
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Year"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"year" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSError *error ;
    NSArray *yearArray= [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    

    NSDate *date = [NSDate date];
    NSMutableArray* newArray = [[NSMutableArray alloc]init];
    

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
        
        [newArray addObject:d1];
        
        [_dataDic setObject:yearArray[i] forKey:d1];
    }

    [newArray sortUsingSelector:@selector(compare:)];
    _sortedDateArr = newArray;
    
    int totalItems = _sortedDateArr.count;
    
    while(totalItems>0){
        totalItems = totalItems - 5;
        _totalPage = _totalPage + 1;
    }
    _currentPage = _totalPage;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadLineChart];
   // self.years = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
