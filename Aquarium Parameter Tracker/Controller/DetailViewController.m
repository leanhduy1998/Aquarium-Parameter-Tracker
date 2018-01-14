//
//  DetailViewController.m
//  Aquarium Aquameter Tracker
//
//  Created by Duy Le on 12/2/17.
//  Copyright © 2017 Duy Le. All rights reserved.
//

#import "DetailViewController.h"
#import "CoreData/CoreData.h"
#import "AppDelegate.h"

@interface DetailViewController ()
    @property (assign) int currentChem;
    @property (assign) int currentChemNumber;
    
    @property (assign) double currentPh;
    @property (assign) double currentAmmonia;
    @property (assign) double currentNitrite;
    @property (assign) double currentNitrate;
    
    typedef enum{
        ph = 0,
        ammonia = 1,
        nitrite = 2,
        nitrate = 3,
    } ChemType;
    
@end

@implementation DetailViewController

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
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToLeftWithGestureRecognizer:)];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipeLeftRecognizer];
    [self.view addGestureRecognizer:swipeRightRecognizer];
    
    _currentChem = 0;
    _currentChemNumber = 0;
    _currentPh = -1;
    _currentAmmonia = -1;
    _currentNitrite = -1;
    _currentNitrate = -1;
}

-(void)slideToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    if(_currentChem == 0){
        _currentChem = 3;
    }
    else{
        _currentChem = _currentChem - 1;
    }
    [self displayUI];
}
    
-(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    if(_currentChem == 3){
        _currentChem = 0;
    }
    else{
        _currentChem = _currentChem + 1;
    }
    [self displayUI];
}
    
-(void) displayUI{
    switch(_currentChem){
        case ph:
        if(_currentChemNumber == 0){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:179.0f/255.0f
                                                    green:236.0f/255.0f
                                                    blue:255.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber < 6){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:255.0f/255.0f
                                                    green:255.0f/255.0f
                                                    blue:255.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber >= 6 && _currentChemNumber <= 6.4){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:245.0f/255.0f
                                                    green:253.0f/255.0f
                                                    blue:161.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 6.4 && _currentChemNumber <= 6.6){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:206.0f/255.0f
                                                    green:238.0f/255.0f
                                                    blue:156.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 6.6 && _currentChemNumber <= 6.8){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:183.0f/255.0f
                                                    green:231.0f/255.0f
                                                    blue:170.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 6.8 && _currentChemNumber <= 7){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:162.0f/255.0f
                                                    green:220.0f/255.0f
                                                    blue:162.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 7 && _currentChemNumber <= 7.2){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:138.0f/255.0f
                                                    green:212.0f/255.0f
                                                    blue:170.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 7.4 && _currentChemNumber <= 7.6){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:103.0f/255.0f
                                                    green:193.0f/255.0f
                                                    blue:192.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 7.2 && _currentChemNumber <= 7.4){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:236.0f/255.0f
                                                    green:183.0f/255.0f
                                                    blue:36.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 7.6 && _currentChemNumber <= 7.8){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:247.0f/255.0f
                                                    green:188.0f/255.0f
                                                    blue:84.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 7.8 && _currentChemNumber <= 8){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:220.0f/255.0f
                                                    green:160.0f/255.0f
                                                    blue:106.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 8 && _currentChemNumber <= 8.2){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:183.0f/255.0f
                                                    green:126.0f/255.0f
                                                    blue:107.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 8.2 && _currentChemNumber <= 8.4){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:161.0f/255.0f
                                                    green:119.0f/255.0f
                                                    blue:165.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 8.4){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:135.0f/255.0f
                                                    green:106.0f/255.0f
                                                    blue:160.0f/255.0f
                                                    alpha:1.0f];
        }
        break;
        
        case ammonia:
        if(_currentChemNumber == 0){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:250.0f/255.0f
                                                    green:244.0f/255.0f
                                                    blue:44.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 0 && _currentChemNumber <= 0.25){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:246.0f/255.0f
                                                    green:244.0f/255.0f
                                                    blue:12.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 0.25 && _currentChemNumber <= 0.5){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:219.0f/255.0f
                                                    green:236.0f/255.0f
                                                    blue:44.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 0.5 && _currentChemNumber <= 1){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:179.0f/255.0f
                                                    green:219.0f/255.0f
                                                    blue:68.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 1 && _currentChemNumber <= 2){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:114.0f/255.0f
                                                    green:193.0f/255.0f
                                                    blue:60.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 2 && _currentChemNumber <= 4){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:48.0f/255.0f
                                                    green:167.0f/255.0f
                                                    blue:64.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 4){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:39.0f/255.0f
                                                    green:118.0f/255.0f
                                                    blue:68.0f/255.0f
                                                    alpha:1.0f];
        }
        break;
        
        case nitrite:
        if(_currentChemNumber == 0){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:180.0f/255.0f
                                                    green:230.0f/255.0f
                                                    blue:218.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 0 && _currentChemNumber <= 0.25){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:173.0f/255.0f
                                                    green:184.0f/255.0f
                                                    blue:214.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 0.25 && _currentChemNumber <= 0.5){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:156.0f/255.0f
                                                    green:148.0f/255.0f
                                                    blue:187.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 0.5 && _currentChemNumber <= 1){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:149.0f/255.0f
                                                    green:126.0f/255.0f
                                                    blue:168.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 1 && _currentChemNumber <= 2){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:165.0f/255.0f
                                                    green:110.0f/255.0f
                                                    blue:165.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 2){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:160.0f/255.0f
                                                    green:101.0f/255.0f
                                                    blue:159.0f/255.0f
                                                    alpha:1.0f];
        }
        break;
        
        case nitrate:
        if(_currentChemNumber == 0){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:248.0f/255.0f
                                                    green:251.0f/255.0f
                                                    blue:7.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 0 && _currentChemNumber <= 5){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:250.0f/255.0f
                                                    green:199.0f/255.0f
                                                    blue:27.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 5 && _currentChemNumber <= 10){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:246.0f/255.0f
                                                    green:164.0f/255.0f
                                                    blue:32.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 10 && _currentChemNumber <= 20){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:240.0f/255.0f
                                                    green:168.0f/255.0f
                                                    blue:70.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 20 && _currentChemNumber <= 40){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:238.0f/255.0f
                                                    green:107.0f/255.0f
                                                    blue:65.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 40 && _currentChemNumber <= 80){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:232.0f/255.0f
                                                    green:105.0f/255.0f
                                                    blue:62.0f/255.0f
                                                    alpha:1.0f];
        }
        else if(_currentChemNumber > 80){
            _backgroundImageView.backgroundColor = [UIColor
                                        colorWithRed:189.0f/255.0f
                                                    green:82.0f/255.0f
                                                    blue:71.0f/255.0f
                                                    alpha:1.0f];
        }
        break;
        
        default:
        break;
    }
}
    

- (IBAction)cancelBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) showAlertWrongFormat{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Some Parameters Are Not In The Right Format!"
                                                    message:@"Please Chech Them Again!"
                                                    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* doneBtn = [UIAlertAction actionWithTitle:@"Okay"
                                                    style:UIAlertActionStyleDefault
                                                    handler:nil];
    
    [alert addAction:doneBtn];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)doneBtnPressed:(id)sender {
    NSNumber *phNumber = [NSNumber numberWithDouble:_currentPh];
    NSNumber *ammoniaNumber = [NSNumber numberWithDouble:_currentAmmonia];
    NSNumber *nitriteNumber = [NSNumber numberWithDouble:_currentNitrite];
    NSNumber *nitrateNumber = [NSNumber numberWithDouble:_currentNitrate];
    
    NSManagedObject *dayCore = [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:[self managedObjectContext]];
    
    [dayCore setValue:phNumber forKey:@"ph"];
    [dayCore setValue:ammoniaNumber forKey:@"ammonia"];
    [dayCore setValue:@-1 forKey:@"nitrite"];
    [dayCore setValue:@-1 forKey:@"nitrate"];
    
    
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
    
    [dayCore setValue:@(day) forKey:@"day"];
    [dayCore setValue:@(hour) forKey:@"hour"];
    [dayCore setValue:@(minute) forKey:@"minute"];
    [dayCore setValue:@(second) forKey:@"second"];
    
    
    NSManagedObject *monthCore = [NSEntityDescription insertNewObjectForEntityForName:@"Month" inManagedObjectContext:[self managedObjectContext]];
    [monthCore setValue:@(month) forKey:@"month"];
    [monthCore setValue:dayCore forKey:@"monthDay"];
    
    NSManagedObject *yearCore = [NSEntityDescription insertNewObjectForEntityForName:@"Year" inManagedObjectContext:[self managedObjectContext]];
    [yearCore setValue:@(year) forKey:@"year"];
    
    [yearCore setValue:monthCore forKey:@"yearMonth"];
    
    //  [((AppDelegate*)[[UIApplication sharedApplication] delegate]) saveContext];
    
    NSError *error = nil;
    if ([[self managedObjectContext] save:&error] == NO) {
        NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
    else{
        [self performSegueWithIdentifier:@"unwindToFront" sender:self];
    }
}
@end
