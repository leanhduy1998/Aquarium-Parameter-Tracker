//
//  ViewController.h
//  Aquarium Aquameter Tracker
//
//  Created by Duy Le on 12/1/17.
//  Copyright © 2017 Duy Le. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PNLineChart.h>
#import "CoreData/CoreData.h"

@interface PHViewController : UIViewController
@property (strong, nonatomic) IBOutlet PNLineChart *lineChart;
    @property (weak, nonatomic) IBOutlet UILabel *noDataLabel;
    
- (IBAction)helpBtnClicked:(id)sender;
    

-(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer;
-(void)slideToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer;


#pragma mark - Core data for messages vriable
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong) NSPersistentContainer *persistentContainer;


- (void)loadLineChart;
- (void)loadData;

- (NSURL *)applicationDocumentsDirectory;

@end

