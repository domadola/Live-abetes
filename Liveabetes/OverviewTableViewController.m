//
//  OverviewTableViewController.m
//  Liveabetes
//
//  Created by Dom Lamendola on 7/27/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import "OverviewTableViewController.h"
#import "AppDelegate.h"
#import "GlucoseReading.h"
#import "A1c.h"
#import "Bolus.h"
#import "Activity.h"
#import "JBBarChartViewController.h"
#import "OverviewDatePickerViewController.h"

@interface OverviewTableViewController ()

@property (strong, nonatomic) NSDate *dateShowing;
@property (strong, nonatomic) NSMutableArray *daysGlucoseReadings; // GlucoseReading.h
@property (strong, nonatomic) NSNumber *max;
@property (strong, nonatomic) NSNumber *min;
@property (strong, nonatomic) NSNumber *avg;
@property (strong, nonatomic) NSNumber *totalUnitsInsulinTaken; // float
@property (strong, nonatomic) NSNumber *estimatedA1c;
@property (strong, nonatomic) NSNumber *goalA1c;
@property (strong, nonatomic) NSNumber *minutesOfActivity;

@end

@implementation OverviewTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadDataWithDate:[NSDate date]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDataWithDate:[NSDate date]];
    [self.tableView reloadData];
}



- (void)loadDataWithDate:(NSDate*)date
{
    self.dateShowing = date;
    [self loadGlucoseReadingsWithDate:date];
    [self loadUnitsInsulinTakenWithdate:date];
    [self loadEstimatedA1cWithDate:date];
    [self loadGoalA1c];
    [self loadMinutesOfActivityWithDate:date];
}

- (void)loadMinutesOfActivityWithDate:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
    NSDate *dateOnly = [calendar dateFromComponents:components]; // just date, no time
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Activity"];
    request.predicate = [NSPredicate predicateWithFormat:@"date = %@", dateOnly];
    
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
        Activity *activity = [results objectAtIndex:0];
        self.minutesOfActivity = activity.minutes;
    } else if ([results count] == 0){
        NSLog(@"No results :(");
        self.minutesOfActivity = [NSNumber numberWithInt:0];
    } else {
        NSLog(@"ERROR! More than one result for given day");
    }
}

- (void)loadGoalA1c
{
    self.goalA1c = [[NSUserDefaults standardUserDefaults] valueForKey:@"A1cGoal"];
}

- (void)loadEstimatedA1cWithDate:(NSDate*)date
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"GlucoseReading"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *days90= [[NSDateComponents alloc] init];
    days90.day = -90;
    
    NSDate *threeMonthsAgo = [calendar dateByAddingComponents:days90 toDate:date options:0];
    
    if (!threeMonthsAgo) {
        NSLog(@"Error fetching a1c information");
    }
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date < %@)", threeMonthsAgo, date];
    
    NSError *error;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    
    float sum = 0.0f;
    for (GlucoseReading *reading in results) {
        sum += [reading.mgdl floatValue];
        NSLog(@"sum: %f", sum);
    }
    if (sum == 0) {
        self.estimatedA1c = [NSNumber numberWithFloat:0.0f];
    } else {
        float avg = sum / results.count;
        NSLog(@"average: %f", avg);
        float estimatedA1c = (avg + 46.7) / 28.7; // formula from http://care.diabetesjournals.org/content/early/2008/06/07/dc08-0545.full.pdf+html
        NSLog(@"estimated a1c: %f", estimatedA1c);
        
        self.estimatedA1c = [NSNumber numberWithFloat:estimatedA1c];
    }
}

- (void)loadUnitsInsulinTakenWithdate:(NSDate*)date
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Bolus"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
    
    dateComponents.second = 0;
    dateComponents.minute = 0;
    dateComponents.hour = 0;
    NSDate *startOfDay = [calendar dateFromComponents:dateComponents];
    
    NSDateComponents *oneDay= [[NSDateComponents alloc] init];
    oneDay.day = 1;
    
    NSDate *endOfDay = [calendar dateByAddingComponents:oneDay toDate:startOfDay options:0];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date < %@)", startOfDay, endOfDay];
    
    NSError *error;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    
    float sum = 0;
    for (Bolus *b in results) {
        sum += [b.insulinUnits floatValue];
    }
    
    self.totalUnitsInsulinTaken = [NSNumber numberWithFloat:sum];
}

- (void)loadGlucoseReadingsWithDate:(NSDate*)date
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"GlucoseReading"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
    
    dateComponents.second = 0;
    dateComponents.minute = 0;
    dateComponents.hour = 0;
    NSDate *startOfDay = [calendar dateFromComponents:dateComponents];
    
    NSDateComponents *oneDay= [[NSDateComponents alloc] init];
    oneDay.day = 1;
    
    NSDate *endOfDay = [calendar dateByAddingComponents:oneDay toDate:startOfDay options:0];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date < %@)", startOfDay, endOfDay];
    
    NSError *error;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    
    self.daysGlucoseReadings = [NSMutableArray arrayWithArray:results];
    NSLog(@"There were %i results", results.count);
    [self getStatsFromReadings];
}

-(void)getStatsFromReadings // set max, min, average of dailyGlucoseReadings in one run
{
    if ([self.daysGlucoseReadings count] == 0) {
        self.avg = 0;
        self.min = 0;
        self.max = 0;
        return;
    }
    
    int sum = 0;
    
    GlucoseReading *first = self.daysGlucoseReadings[0];
    int max = [first.mgdl intValue];
    int min = [first.mgdl intValue];
    
    for (GlucoseReading *g in self.daysGlucoseReadings) {
        int r = [g.mgdl intValue];
        if (r > max) {
            max = r;
        }
        if (r < min) {
            min = r;
        }
        
        sum += r;
    }
    
    self.avg = [NSNumber numberWithInt: sum / [self.daysGlucoseReadings count]];
    self.max = [NSNumber numberWithInt:max];
    self.min = [NSNumber numberWithInt:min];
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
    
    // Configure the cell...
    UILabel *label;

    switch (indexPath.row) {
        case 0:
            label = (UILabel *)[cell viewWithTag:1];
            label.text = @"Average Blood Glucose";
            label = (UILabel *)[cell viewWithTag:2];
            label.text = [self.avg stringValue];
            break;
        case 1:
            label = (UILabel *)[cell viewWithTag:1];
            label.text = @"Max Blood Glucose";
            label = (UILabel *)[cell viewWithTag:2];
            label.text = [self.max stringValue];
            break;
        case 2:
            label = (UILabel *)[cell viewWithTag:1];
            label.text = @"Min Blood Glucose";
            label = (UILabel *)[cell viewWithTag:2];
            label.text = [self.min stringValue];
            break;
        case 3:
            label = (UILabel *)[cell viewWithTag:1];
            label.text = @"Total Insulin Units:";
            label = (UILabel *)[cell viewWithTag:2];
            label.text = [self.totalUnitsInsulinTaken stringValue];
            break;
        case 4:
            label = (UILabel *)[cell viewWithTag:1];
            label.text = @"Estimated A1C:";
            label = (UILabel *)[cell viewWithTag:2];
            label.text = [NSString stringWithFormat:@"%.2f", [self.estimatedA1c floatValue]];
            break;
        case 5:
            label = (UILabel *)[cell viewWithTag:1];
            label.text = @"Target A1C:";
            label = (UILabel *)[cell viewWithTag:2];
            label.text = [NSString stringWithFormat:@"%.2f", [self.goalA1c floatValue]];
            break;
        case 6:
            label = (UILabel *)[cell viewWithTag:1];
            label.text = @"Minutes of Activity:";
            label = (UILabel *)[cell viewWithTag:2];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = [self.minutesOfActivity stringValue];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            break;
    }
    
    return cell;
}

- (IBAction)unwindToOverview:(UIStoryboardSegue *)segue
{
    NSLog(@"unwindToOverview called");
    if ([[segue sourceViewController] isKindOfClass:[OverviewDatePickerViewController class]]) {
        if (self.dateNeedsUpdate) {
            self.dateNeedsUpdate = NO;
            [self loadDataWithDate:self.date];
            [self.tableView reloadData];
            NSLog(@"loading with date: %@", self.date);
        } else {
            NSLog(@"didn't need to update");
        }
    } else {
        NSLog(@"unwind source was instead: %@", [segue sourceViewController]);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 6) {
        JBBarChartViewController *barChartController = [[JBBarChartViewController alloc] initWithContext:self.context];
        NSLog(@"context was passed to bar chart from overview controller");
        [self.navigationController pushViewController:barChartController animated:YES];
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue destinationViewController] isKindOfClass:[JBBarChartViewController class]]) {
        JBBarChartViewController *barChart = (JBBarChartViewController*)[segue destinationViewController];
        barChart.context = self.context;
        NSLog(@"context was passed to bar chart.");
    } else {
        NSLog(@"%@", [segue destinationViewController]);
    }
}


@end
