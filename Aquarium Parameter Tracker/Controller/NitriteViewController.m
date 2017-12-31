//
//  NitriteViewController.m
//  Aquarium Parameter Tracker
//
//  Created by Duy Le on 12/30/17.
//  Copyright © 2017 Duy Le. All rights reserved.
//

#import "NitriteViewController.h"
#import "CoreData/CoreData.h"
#import "PNChart.h"
#import "AppDelegate.h"
#import "SharedData.h"

@interface NitriteViewController ()
    @property (strong,nonatomic)NSMutableArray *timeLabels;
    
    @property (strong,nonatomic)NSMutableArray *nitriteData;
    
    @property (strong,nonatomic) NSMutableDictionary *dataDic;
    @property (strong,nonatomic)NSMutableArray *sortedDateArr;
    
    @property (strong,nonatomic)SharedData *sharedManager;
    
    @property (assign) int currentPage;
    @property (assign) int totalPage;
    
    @end

@implementation NitriteViewController
    
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
    _nitriteData = [[NSMutableArray alloc]init];
    
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
    [_nitriteData removeAllObjects];
    
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
            
            NSString *label = [NSString stringWithFormat:@"%ld/%ld", [[monthCore valueForKey:@"month"] integerValue], [[dayCore valueForKey:@"day"] integerValue]];
            
            [_timeLabels addObject:label];
            
            NSNumber *nitrite = [NSNumber numberWithFloat:[[dayCore valueForKey:@"nitrite"] floatValue]] ;
            [_nitriteData addObject:nitrite];
        }
        
    }
    else{
        for (int i = (_currentPage-1)*5; i < _currentPage*5; i++){
            NSManagedObject *yearCore = [_dataDic objectForKey:_sortedDateArr[i]];
            NSManagedObject *monthCore = [yearCore valueForKey:@"yearMonth"];
            NSManagedObject *dayCore = [monthCore valueForKey:@"monthDay"];
            
            NSString *label = [NSString stringWithFormat:@"%ld/%ld", [[monthCore valueForKey:@"month"] integerValue], [[dayCore valueForKey:@"day"] integerValue]];
            
            [_timeLabels addObject:label];
            
            NSNumber *nitrite = [NSNumber numberWithFloat:[[dayCore valueForKey:@"nitrite"] floatValue]] ;
            [_nitriteData addObject:nitrite];
        }
    }
    
    
    
    [_lineChart setXLabels:_timeLabels];
    
    PNLineChartData *nitriteLine = [PNLineChartData new];
    nitriteLine.color = [UIColor colorWithRed:186.0f/255.0f
                                        green:85.0f/255.0f
                                         blue:211.0f/255.0f
                                        alpha:1.0f];
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
    
    _lineChart.chartData = @[nitriteLine];
    [_lineChart strokeChart];
    
    _lineChart.showSmoothLines = YES;
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
