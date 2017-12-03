//
//  ViewController.m
//  Aquarium Aquameter Tracker
//
//  Created by Duy Le on 12/1/17.
//  Copyright © 2017 Duy Le. All rights reserved.
//

#import "ViewController.h"
#import "CoreData/CoreData.h"
#import "PNChart.h"
#import "AppDelegate.h"

@interface ViewController ()
@property (strong,nonatomic)NSMutableArray *years;

@end

@implementation ViewController

- (NSManagedObjectContext *) managedObjectContext{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate respondsToSelector:@selector(persistentContainer)]) {
        context = [[delegate persistentContainer]viewContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [_lineChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5",@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
    
    // Line Chart No.1
    NSArray * data01Array = @[@60.1, @160.1, @126.4, @262.2, @186.2,@60.1, @160.1, @126.4, @262.2, @186.2];
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = PNFreshGreen;
    data01.itemCount = _lineChart.xLabels.count;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    // Line Chart No.2
    NSArray * data02Array = @[@20.1, @180.1, @26.4, @202.2, @126.2,@20.1, @180.1, @26.4, @202.2, @126.2];
    PNLineChartData *data02 = [PNLineChartData new];
    data02.color = PNRed;
    data02.itemCount = _lineChart.xLabels.count;
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [data02Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    _lineChart.chartData = @[data01, data02];
    [_lineChart strokeChart];
    
    _lineChart.showSmoothLines = YES;
    
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Year"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"year" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSError *error ;
    NSArray *resultArray= [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSManagedObject *yearCore = resultArray[0];
    
    NSString *value = [[yearCore valueForKey:@"year"] stringValue];
    NSLog(@"Value : %@",value);
    
 //   NSLog(yearCore.month)
    
    self.years = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
}

- (IBAction)testBtnPressed:(id)sender {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    
    NSManagedObject *dayCore = [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:[self managedObjectContext]];
    [dayCore setValue:@(day) forKey:@"day"];
    
    NSManagedObject *monthCore = [NSEntityDescription insertNewObjectForEntityForName:@"Month" inManagedObjectContext:[self managedObjectContext]];
    [monthCore setValue:@(month) forKey:@"month"];
    [monthCore setValue:dayCore forKey:@"monthDay"];
    
    NSManagedObject *yearCore = [NSEntityDescription insertNewObjectForEntityForName:@"Year" inManagedObjectContext:[self managedObjectContext]];
    [yearCore setValue:@(year) forKey:@"year"];
    [yearCore setValue:monthCore forKey:@"yearMonth"];
    
    
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) saveContext];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
