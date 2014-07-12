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

@interface GlucoseReadingsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property NSMutableArray *dailyReadings; // of GlucoseInfo
@property NSDate *currentDate;
@property (weak, nonatomic) IBOutlet UIButton *incrementDateButton;
@property (weak, nonatomic) IBOutlet UIButton *decrementDateButton;

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
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    AddGlucoseReadingViewController *source = [segue sourceViewController];
    GlucoseInfo *item = source.info;
    if (item != nil) {
        [self.dailyReadings addObject:item];
        [self.tableView reloadData];
    }
}

/* 
 Placeholder for now. 
 TODO: Load data from CoreData!
 */
- (void)loadWithData {
    GlucoseInfo *reading1 = [[GlucoseInfo alloc] init];
    reading1.readingMgDl = [NSNumber numberWithInt:120];
    [self.dailyReadings addObject:reading1];
    
    GlucoseInfo *reading2 = [[GlucoseInfo alloc] init];
    reading2.readingMgDl = [NSNumber numberWithInt:75];
    [self.dailyReadings addObject:reading2];
    
    GlucoseInfo *reading3 = [[GlucoseInfo alloc] init];
    reading3.readingMgDl = [NSNumber numberWithInt:238];
    [self.dailyReadings addObject:reading3];
}

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GlucoseReadingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    GlucoseInfo *reading = [self.dailyReadings objectAtIndex:indexPath.row];
    cell.textLabel.text = [reading.readingMgDl stringValue];
    if (reading.completed) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    GlucoseInfo *tappedItem = [self.dailyReadings objectAtIndex:indexPath.row];
    tappedItem.completed = !tappedItem.completed;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

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
    self.dailyReadings = [[NSMutableArray alloc] init];
    [self loadWithData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
