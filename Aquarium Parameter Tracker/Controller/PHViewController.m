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
#import "Helper.h"

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
    _sortedDateArr = [[NSMutableArray alloc]init];
    
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
    PNLineChartData *phLine = [PNLineChartData new];
    phLine.color = PNLightBlue;
    
    //loadLineChart:(NSMutableArray*)timeLabels: (NSMutableArray*) chemData: (NSMutableArray*) sortedDateArr: (int)currentPage :(int)totalPage: (NSMutableDictionary*) dataDic: (PNLineChart*) lineChart: (UILabel*) noDataLabel: (PNLineChartData*) chemLine;
    [Helper loadLineChart:_timeLabels :_phData :_sortedDateArr :_currentPage :_totalPage :_dataDic :_lineChart :_noDataLabel : phLine : 0];
}

- (void)loadSlider {
    //loadSlider: (int) totalPage: (UISlider*) slider: (UILabel*) pageLabel
    [Helper loadSlider:_totalPage :_slider :_pageLabel];
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    _slider.value = roundf(sender.value / 1.0) * 1.0;
    _currentPage = _slider.value;
    [self loadLineChart];
    NSString *pageText = [NSString stringWithFormat: @"Page %d of %d.", (int) _slider.value, _totalPage];
    [_pageLabel setText:pageText];
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
    //loadData: (NSManagedObjectContext*)managedObjectContext: (NSMutableDictionary*) dataDic: (NSMutableArray*) sortedDateArr: (int) totalPage: (int) currentPage
    [Helper loadData:managedObjectContext :_dataDic :_sortedDateArr :&(_totalPage) :&(_currentPage)];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadLineChart];
    [self loadSlider];
   // self.years = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
}

@end
