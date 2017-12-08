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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    
    int phFilled = 0;
    int ammoniaFilled = 0;
    int nitriteFilled = 0;
    int nitrateFilled = 0;
    
    
    NSNumber *phNumber = [formatter numberFromString:_phTextField.text];
    NSNumber *ammoniaNumber = [formatter numberFromString:_ammoniaTF.text];
    NSNumber *nitriteNumber = [formatter numberFromString:_nitriteTF.text];
    NSNumber *nitrateNumber = [formatter numberFromString:_nitrateTF.text];
    
    
    NSManagedObject *dayCore = [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:[self managedObjectContext]];
    
    if (phNumber != nil) {
        phFilled = 1;
        [dayCore setValue:phNumber forKey:@"ph"];
    }
    else{
        [dayCore setValue:@-1 forKey:@"ph"];
    }

    if (ammoniaNumber != nil) {
        ammoniaFilled = 1;
        [dayCore setValue:ammoniaNumber forKey:@"ammonia"];
    }
    else{
        [dayCore setValue:@-1 forKey:@"ammonia"];
    }
    
    if (nitriteNumber != nil) {
        nitriteFilled = 1;
        [dayCore setValue:nitriteNumber forKey:@"nitrite"];
    }
    else{
        [dayCore setValue:@-1 forKey:@"nitrite"];
    }
    
    if (nitrateNumber != nil) {
        nitrateFilled = 1;
        [dayCore setValue:nitrateNumber forKey:@"nitrate"];
    }
    else{
        [dayCore setValue:@-1 forKey:@"nitrate"];
    }
    
    if(phFilled + ammoniaFilled + nitriteFilled + nitrateFilled == 0 ){
        [self showAlertWrongFormat];
        return;
    }
    
    
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
