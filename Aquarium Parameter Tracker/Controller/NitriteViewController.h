//
//  NitriteViewController.h
//  Aquarium Parameter Tracker
//
//  Created by Duy Le on 12/30/17.
//  Copyright © 2017 Duy Le. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PNLineChart.h>
#import "CoreData/CoreData.h"

@interface NitriteViewController : UIViewController
@property (strong, nonatomic) IBOutlet PNLineChart *lineChart;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBarTitle;
- (IBAction)helpBtnPressed:(id)sender;
    
    
-(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer;
-(void)slideToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer;
    
    
#pragma mark - Core data for messages vriable
    @property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
    @property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
    @property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
    @property (readonly, strong) NSPersistentContainer *persistentContainer;
    
    
- (void)loadLineChart;
- (void)loadData;
    
@end
