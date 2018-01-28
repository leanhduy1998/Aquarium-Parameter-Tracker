//
//  NitrateViewController.m
//  Aquarium Parameter Tracker
//
//  Created by Duy Le on 12/31/17.
//  Copyright © 2017 Duy Le. All rights reserved.
//

#import "NitrateViewController.h"
#import "CoreData/CoreData.h"
#import "PNChart.h"
#import "AppDelegate.h"
#import "SharedData.h"
#import "Helper.h"

@interface NitrateViewController ()
@property (strong,nonatomic)NSMutableArray *timeLabels;

@property (strong,nonatomic)NSMutableArray *nitrateData;

@property (strong,nonatomic) NSMutableDictionary *dataDic;
@property (strong,nonatomic)NSMutableArray *sortedDateArr;

@property (strong,nonatomic)SharedData *sharedManager;

@property (assign) int currentPage;
@property (assign) int totalPage;

@end

@implementation NitrateViewController

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
    _nitrateData = [[NSMutableArray alloc]init];
    _sortedDateArr = [[NSMutableArray alloc]init];
    
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

- (void)loadSlider {
    //loadSlider: (int) totalPage: (UISlider*) slider: (UILabel*) pageLabel
    [Helper loadSlider:_totalPage :_slider: _navigationBarTitle];
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    _slider.value = roundf(sender.value / 1.0) * 1.0;
    _currentPage = _slider.value;
    [self loadLineChart];
    NSString *pageText = [NSString stringWithFormat: @"Page %d of %d", (int) _slider.value, _totalPage];
    _navigationBarTitle.title = pageText;
}

- (IBAction)helpBtnPressed:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
            message:@"Swipe left and right to see your data."
            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)loadLineChart {
    // loadLineChart:(NSMutableArray*)timeLabels
    
    PNLineChartData *nitrateLine = [PNLineChartData new];
    [Helper loadLineChart:_timeLabels chemData:_nitrateData sortedDateArr:_sortedDateArr currentPage:_currentPage totalPage:_totalPage dataDic:_dataDic lineChart:_lineChart noDataLabel:_noDataLabel chemLine:nitrateLine chemNum:3];
    nitrateLine.color = [UIColor colorWithRed:255.0f/255.0f
                                        green:96.0f/255.0f
                                         blue:27.0f/255.0f
                                        alpha:1.0f];
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

    
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
    [self loadLineChart];
    [self loadSlider];
}

@end
