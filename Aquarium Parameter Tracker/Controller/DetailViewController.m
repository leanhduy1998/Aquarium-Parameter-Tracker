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
#import "DetailView.h"


@interface DetailViewController ()
    @property (assign) int currentChem;
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
    [self addSwipeListener];
    [self addChemTFListener];
    
    _currentChem = 0;
    _currentPh = -1;
    _currentAmmonia = -1;
    _currentNitrite = -1;
    _currentNitrate = -1;
    
    [self displayUI];
    [self updateCurrentChemNumberLabel];
    
    [self addKeyboardListener];
}
    
- (void) addChemTFListener{
    _chemTF.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:_chemTF];
}
    
- (void) addSwipeListener{
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToLeftWithGestureRecognizer:)];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipeLeftRecognizer];
    [self.view addGestureRecognizer:swipeRightRecognizer];
}
    
- (void) addKeyboardListener{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}
    
- (void)keyboardWillShow:(NSNotification*)notification {        [UIView animateWithDuration:0.25 animations:^{
        CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
            
        CGRect newFrame = [[self view] frame];
        newFrame.origin.y -= keyboardSize.height;
        [[self view] setFrame:newFrame];
             
        }completion:^(BOOL finished)
        {
             
        }];
}
    
- (void)keyboardWillBeHidden:(NSNotification*)notification {
    [UIView animateWithDuration:0.25 animations:^{
        CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        
        CGRect newFrame = [[self view] frame];
        newFrame.origin.y += keyboardSize.height;
        [[self view] setFrame:newFrame];
         
     }completion:^(BOOL finished)
     {
         
     }];
    
}
    
- (void)textFieldDidChange:(NSNotification *)notification {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber *chemNum = [numberFormatter numberFromString:_chemTF.text];
    if (chemNum != nil) {
        switch(_currentChem){
            case ph:
            _currentPh = [chemNum doubleValue];
            break;
            
            case ammonia:
            _currentAmmonia = [chemNum doubleValue];
            break;
            
            case nitrite:
            _currentNitrite = [chemNum doubleValue];
            break;
            
            case nitrate:
            _currentNitrate = [chemNum doubleValue];
            break;
            
            default:
            break;
        }
        [self displayUI];
    }
    else{
        switch(_currentChem){
            case ph:
            _currentPh = -1;
            break;
            
            case ammonia:
            _currentAmmonia = -1;
            break;
            
            case nitrite:
            _currentNitrite = -1;
            break;
            
            case nitrate:
            _currentNitrate = -1;
            break;
            
            default:
            break;
        }
    }
    
    [self updateCurrentChemNumberLabel];
    numberFormatter = NULL;
}
    
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(void)slideToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    if(_currentChem == 3){
        _currentChem = 0;
    }
    else{
        _currentChem = _currentChem + 1;
    }
    
    [self updateChemTF];
    [self displayUI];
}
    
-(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    if(_currentChem == 0){
        _currentChem = 3;
    }
    else{
        _currentChem = _currentChem - 1;
    }
    
    [self updateChemTF];
    [self displayUI];
}
    
-(void) updateCurrentChemNumberLabel{
    NSMutableString *currentChemNumberString = [NSMutableString stringWithString:@""];
    if(_currentPh!=-1){
        NSString *currentPHNumberString = [NSString stringWithFormat: @"pH: %.2f  ", _currentPh];
        [currentChemNumberString appendString:currentPHNumberString];
    }
    else{
        [currentChemNumberString appendString:@"pH: ?  "];
    }
    
    if(_currentAmmonia!=-1){
        NSString *currentPHNumberString = [NSString stringWithFormat: @"Ammonia: %.2f  ", _currentAmmonia];
        [currentChemNumberString appendString:currentPHNumberString];
    }
    else{
        [currentChemNumberString appendString:@"Ammonia: ?  "];
    }
    
    if(_currentNitrite!=-1){
        NSString *currentPHNumberString = [NSString stringWithFormat: @"Nitrite: %.2f  ", _currentNitrite];
        [currentChemNumberString appendString:currentPHNumberString];
    }
    else{
        [currentChemNumberString appendString:@"Nitrite: ?  "];
    }
    
    if(_currentNitrate!=-1){
        NSString *currentPHNumberString = [NSString stringWithFormat: @"Nitrate: %.2f", _currentNitrate];
        [currentChemNumberString appendString:currentPHNumberString];
    }
    else{
        [currentChemNumberString appendString:@"Nitrate: ?"];
    }
    _currentChemNumberLabel.text = currentChemNumberString;
}
    
-(void) updateChemTF{
    switch (_currentChem) {
        case ph:
        if(_currentPh!=-1){
            _chemTF.text = [NSString stringWithFormat: @"%.2f", _currentPh];
            
            NSString *currentPHNumberString = [NSString stringWithFormat: @"%.2f", _currentPh];
        }
        else{
            _chemTF.text = @"";
        }
        break;
        
        case ammonia:
        if(_currentAmmonia!=-1){
            _chemTF.text = [NSString stringWithFormat: @"%.2f", _currentAmmonia];
            NSString *currentPHNumberString = [NSString stringWithFormat: @"%.2f", _currentAmmonia];
        }
        else{
            _chemTF.text = @"";
        }
        break;
        
        case nitrite:
        if(_currentNitrite!=-1){
            _chemTF.text = [NSString stringWithFormat: @"%.2f", _currentNitrite];
            NSString *currentPHNumberString = [NSString stringWithFormat: @"%.2f", _currentNitrite];
        }
        else{
            _chemTF.text = @"";
        }
        break;
        
        case nitrate:
        if(_currentNitrate!=-1){
            _chemTF.text = [NSString stringWithFormat: @"%.2f", _currentNitrate];
            NSString *currentPHNumberString = [NSString stringWithFormat: @"%.2f", _currentNitrate];
        }
        else{
            _chemTF.text = @"";
        }
        break;
        
        default:
        break;
    }
}

    
-(void) displayUI{
    [DetailView displayLabelAndBackgroundColorForCurrentChemStats:_currentChem chemLabel:_chemLabel backgroundImageView:_backgroundImageView currentPh:_currentPh currentAmmonia:_currentAmmonia currentNitrite:_currentNitrite currentNitrate:_currentNitrate];
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
    [dayCore setValue:nitriteNumber forKey:@"nitrite"];
    [dayCore setValue:nitrateNumber forKey:@"nitrate"];
    
    NSDate *date = [NSDate date];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitHour  | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
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
    
    
    NSError *error = nil;
    if ([[self managedObjectContext] save:&error] == NO) {
        NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
    else{
        [self performSegueWithIdentifier:@"unwindToFront" sender:self];
    }
}
@end
