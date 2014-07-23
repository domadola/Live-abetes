//
//  GlucoseReadingsViewController.m
//  Liveabetes
//
//  Created by Dom Lamendola on 7/9/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import "GlucoseReadingsViewController.h"
#import "GlucoseInfo.h"
#import "AddGlucoseReadingViewController.h"
#import "TargetRange.h"
#import "AppDelegate.h"

@interface GlucoseReadingsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property NSMutableArray *dailyReadingsOld; // of GlucoseInfo
@property NSMutableArray *dailyReadings; // of GlucoseReading (core data)
@property NSDate *currentDate;
@property (weak, nonatomic) IBOutlet UIButton *incrementDateButton;
@property (weak, nonatomic) IBOutlet UIButton *decrementDateButton;

@property NSNumber *targetRangeHigh;
@property NSNumber *targetRangeLow;

@end

@implementation GlucoseReadingsViewController

- (IBAction)incrementDatePressed:(id)sender
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:1];
    
    self.currentDate = [calendar dateByAddingComponents:components toDate:self.currentDate options:0];
    
    [self updateDayLabel];
}

- (IBAction)decrementDatePressed:(id)sender
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1];
    
    self.currentDate = [calendar dateByAddingComponents:components toDate:self.currentDate options:0];
    
    [self updateDayLabel];
}

-(BOOL)isToday:(NSDate *) date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([today isEqualToDate:otherDate]) {
        return true;
    }
    return false;
}

-(void)updateDayLabel
{
    if ([self isToday:self.currentDate]) {
        self.dayLabel.text = @"Today";
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        self.dayLabel.text = [dateFormatter stringFromDate:self.currentDate];
    }
    [self updateTable];
}

-(void)updateTable
{
    [self loadWithData];
    [self.tableView reloadData];
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    if ([[segue sourceViewController] isKindOfClass:[AddGlucoseReadingViewController class]]) {
        AddGlucoseReadingViewController *source = [segue sourceViewController];
        GlucoseReading *newReading = source.reading;
        if (newReading != nil) {
            //[self.dailyReadings addObject:newReading];
            //[self.tableView reloadData];
            [self loadWithData];
            [self.tableView reloadData];
        }
    }
    
    if (self.needToUpdateTable) {
        NSLog(@"Reloading data after change of target range");
        self.targetRangeHigh = [[NSUserDefaults standardUserDefaults] objectForKey:@"TargetRangeHigh"];
        self.targetRangeLow = [[NSUserDefaults standardUserDefaults] objectForKey:@"TargetRangeLow"];
        [self.tableView reloadData];
        self.needToUpdateTable = NO;
    }
}

- (void)loadWithData {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"GlucoseReading"];
    //NSDate *currentDate = [NSDate date];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date < %@", currentDate];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:self.currentDate];
    
    dateComponents.second = 0;
    dateComponents.minute = 0;
    dateComponents.hour = 0;
    NSDate *startOfDay = [calendar dateFromComponents:dateComponents];
    
//    dateComponents.second = 59;
//    dateComponents.minute = 59;
//    dateComponents.hour = 23;
    NSDateComponents *oneDay= [[NSDateComponents alloc] init];
    oneDay.day = 1;
    
    
    NSDate *endOfDay = [calendar dateByAddingComponents:oneDay toDate:startOfDay options:0];
//    NSDate *endOfDay = [calendar dateFromComponents:dateComponents];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date < %@)", startOfDay, endOfDay];
    
    NSError *error;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    
    self.dailyReadings = [NSMutableArray arrayWithArray:results];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dailyReadings count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GlucoseReadingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    GlucoseReading *reading = [self.dailyReadings objectAtIndex:indexPath.row];
    
    UILabel *label;
    
    label = (UILabel *)[cell viewWithTag:2];
    label.text = [reading.mgdl stringValue];
    
    label = (UILabel *)[cell viewWithTag:1];
    label.text = [self.timeFormatter stringFromDate:reading.date];
    
//    save this in case we go back to using Subtitle style instead of custom cell
//    cell.textLabel.text = [reading.mgdl stringValue];
//    cell.detailTextLabel.textColor = [UIColor blackColor];
//    cell.detailTextLabel.text = [self.timeFormatter stringFromDate:reading.date];
    
    cell.backgroundColor = [self backgroundColorForMgdl:reading.mgdl];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [self.context deleteObject:[self.dailyReadings objectAtIndex:indexPath.row]]; // remove from database
        [self.dailyReadings removeObjectAtIndex:indexPath.row]; // remove from data model
        //[self.tableView reloadData];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];  // animate deletion from table
    }
}

- (NSDateFormatter *)timeFormatter
{
    if(!_timeFormatter) {
        _timeFormatter = [[NSDateFormatter alloc] init];
        [_timeFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [_timeFormatter setDateStyle:NSDateFormatterNoStyle];
    }
    
    return _timeFormatter;
}


#pragma mark - Cell background color methods

// assuming target range is valid (max > min)
-(UIColor*)backgroundColorForMgdl:(NSNumber*)mgdl
{
    int glucoseReading = mgdl.intValue;
    int max = self.targetRangeHigh.intValue; //range.high.intValue;
    int min = self.targetRangeLow.intValue; //range.low.intValue;
    
    if (glucoseReading <= max && glucoseReading >= min) {
        return [self backgroundColorInRangeforMgdl:glucoseReading max:max min:min];
    } else {
        return [self backgroundColorOutOfRangeForMgdl:glucoseReading max:max min:min];
    }
}

-(UIColor*)backgroundColorInRangeforMgdl:(int)value max:(int)max min:(int)min
{
    float alpha = [self alphaForValue:value max:max min:min];
    
    return [[UIColor greenColor] colorWithAlphaComponent:alpha];
}

-(UIColor*)backgroundColorOutOfRangeForMgdl:(int)value max:(int)max min:(int)min
{
    float alpha;
    
    if (value < min) {
        alpha = ((float)min - (float)value)/100.0f + .15;
    } else if (value > max) {
        alpha = ((float)value - (float)max)/200.0f + .15f;
    } else {
        NSLog(@"ERROR, value was not out of range as expected!");
        alpha = 1.0f;
    }
    if(alpha < .15f) alpha = .15f;
    if(alpha > 1.0f) alpha = 1.0f;
    
    return [[UIColor redColor] colorWithAlphaComponent:alpha];
}

-(float)alphaForValue:(int)value max:(int)max min:(int)min
{
    float d = (float)((max - min) / 2);
    int dFromMax = max - value;
    int dFromMin = value - min;
    int minDist = dFromMax < dFromMin ? dFromMax : dFromMin;
    
    float alpha = minDist / d;
    if(alpha < .15f) alpha = .15f;
    if(alpha > 1.0f) alpha = 1.0f;
    
    return alpha;
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

#pragma mark - View Controller methods

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
    if (!self.currentDate) {
        self.currentDate = [NSDate date]; // set date to today
    }
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.dailyReadings = [[NSMutableArray alloc] init];
    self.targetRangeHigh = [[NSUserDefaults standardUserDefaults] objectForKey:@"TargetRangeHigh"];
    self.targetRangeLow = [[NSUserDefaults standardUserDefaults] objectForKey:@"TargetRangeLow"];
    
    [self loadWithData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *destination = [segue destinationViewController];
    if ([destination isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController*)destination;
        if ([navController.topViewController isKindOfClass:[AddGlucoseReadingViewController class]]) {
            AddGlucoseReadingViewController *addVC = (AddGlucoseReadingViewController*)navController.topViewController;
            addVC.context = self.context;
            addVC.date = self.currentDate;
        } else {
            NSLog(@"navController.topViewController was not AddGlucoseReadingViewController instance");
        }
    } else {
        NSLog(@"destination view controller was not a AddGlucoseReadingViewController, instead it was %@", [segue destinationViewController]);
    }
}


@end
