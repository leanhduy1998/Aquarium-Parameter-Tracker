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
#import "Helper.h"

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
    PNLineChartData *nitriteLine = [PNLineChartData new];
    //loadLineChart:(NSMutableArray*)timeLabels: (NSMutableArray*) chemData: (NSMutableArray*) sortedDateArr: (int)currentPage :(int)totalPage: (NSMutableDictionary*) dataDic: (PNLineChart*) lineChart: (UILabel*) noDataLabel: (PNLineChartData*) chemLine;
    [Helper loadLineChart:_timeLabels :_nitriteData :_sortedDateArr :_currentPage :_totalPage :_dataDic :_lineChart :_noDataLabel : nitriteLine : 2];
    
    nitriteLine.color = [UIColor colorWithRed:186.0f/255.0f
                                        green:85.0f/255.0f
                                         blue:211.0f/255.0f
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
