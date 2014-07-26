//
//  ActivityViewController.m
//  Liveabetes
//
//  Created by Dom Lamendola on 7/24/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import "ActivityViewController.h"
#import "Activity.h"
#import "AppDelegate.h"

@interface ActivityViewController () <UITextViewDelegate> 
@property (weak, nonatomic) IBOutlet UITextView *activityMinutesTextView;
@property (weak, nonatomic) IBOutlet UIProgressView *activityProgressView;
@property (weak, nonatomic) IBOutlet UITextView *goalTextView;

@end

@implementation ActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.goalTextView.delegate = self;
    self.activityMinutesTextView.delegate = self;
    
    [self loadData];
    [self updateProgressBar];
}

- (void)loadData
{
    NSNumber *goalMinutes = [[NSUserDefaults standardUserDefaults] valueForKey:@"ActivityGoal"];
    self.goalTextView.text = [NSString stringWithFormat:@"%@", goalMinutes];
    
    NSNumber *activeMinutes;
    Activity *activity = [self getActivityForToday];
    if (!activity) {
        activeMinutes = 0;
    } else {
        activeMinutes = activity.minutes;
    }
    self.activityMinutesTextView.text = [NSString stringWithFormat:@"%d", [activeMinutes intValue]];
}

- (void)updateProgressBar
{
    NSNumber *goal = [[NSUserDefaults standardUserDefaults] valueForKey:@"ActivityGoal"];
    NSNumber *minutes = [NSNumber numberWithInt:[self.activityMinutesTextView.text intValue]];
    
    float percentDone = [minutes floatValue] / [goal floatValue];
    NSLog(@"progresss: %f", percentDone);
    
    [self.activityProgressView setProgress:percentDone animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text View Delegate methods

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == self.goalTextView) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[textView.text intValue]]forKey:@"ActivityGoal"];
    } else if (textView == self.activityMinutesTextView) {
        [self saveActivity:[NSNumber numberWithInt:[textView.text intValue]]];
    }
    [self updateProgressBar];
}

- (Activity*)saveActivity:(NSNumber*)number
{
    Activity *activity;
    
    activity = [self getActivityForToday];
    if (activity) {  // if there's already entry for this date, just edit it
        activity.minutes = number;
    } else { // else create new entry for this date
        activity = [self createActivityForToday];
        activity.minutes = number;
    }
    
    return activity;
}
 /* Be sure there is not an entry already before calling this */
- (Activity*)createActivityForToday
{
    while (self.context == nil) {
        NSLog(@"context is nil");
    }
    Activity *activity = [NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:self.context];
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    NSDate *date = [calendar dateFromComponents:components];
    activity.date = date;
    activity.minutes = 0;

    return activity;
}

- (Activity*)getActivityForToday
{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    NSDate *date = [calendar dateFromComponents:components]; // just date, no time
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Activity"];
    request.predicate = [NSPredicate predicateWithFormat:@"date = %@", date];
    
    while (self.context == nil) {
        NSLog(@"context is nil");
    }
    
    NSError *error;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"Error! %@", error);
    }
    if ([results count] == 1) {
        NSLog(@"There was a result!");
        return [results objectAtIndex:0];
    } else if ([results count] == 0){
        NSLog(@"No results :(");
        return nil;
    } else {
        NSLog(@"ERROR! More than one result for given day");
        return nil;
    }
}

#pragma mark - Managed Object Context
- (NSManagedObjectContext *)context
{
    if (_context != nil) {
        return _context;
    }
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    _context = appDelegate.context;
    return _context;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
