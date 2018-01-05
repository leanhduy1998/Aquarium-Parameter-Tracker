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
    //loadLineChart:(NSMutableArray*)timeLabels: (NSMutableArray*) chemData: (NSMutableArray*) sortedDateArr: (int)currentPage :(int)totalPage: (NSMutableDictionary*) dataDic: (PNLineChart*) lineChart: (UILabel*) noDataLabel: (PNLineChartData*) chemLine;
    
    PNLineChartData *nitrateLine = [PNLineChartData new];
    [Helper loadLineChart:_timeLabels :_nitrateData :_sortedDateArr :_currentPage :_totalPage :_dataDic :_lineChart :_noDataLabel : nitrateLine : 3];
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
    // self.years = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
