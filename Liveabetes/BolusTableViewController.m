//
//  BolusTableViewController.m
//  Liveabetes
//
//  Created by Dom Lamendola on 7/22/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import "BolusTableViewController.h"
#import "Bolus.h"
#import "InsulinType.h"
#import "AddBolusTableViewController.h"

@interface BolusTableViewController ()

@property (strong, nonatomic) NSMutableArray *dailyBolus; // Bolus.h of current day
@property (strong, nonatomic) NSDateFormatter *timeFormatter;

@end

@implementation BolusTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)unwindToBolusTable:(UIStoryboardSegue *)segue;
{
    [self loadData];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadData];
    
    // [self.tableView reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)loadData
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Bolus"];
    //NSDate *currentDate = [NSDate date];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date < %@", currentDate];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
    
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
    
    self.dailyBolus = [NSMutableArray arrayWithArray:results];
    NSLog(@"array filled with %d elements", [self.dailyBolus count]);
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
    return [self.dailyBolus count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bolusCell" forIndexPath:indexPath];
    
    Bolus *b = [self.dailyBolus objectAtIndex:indexPath.row];
    
    UILabel *label;
    
    label = (UILabel*)[cell viewWithTag:1];
    label.text = [NSString stringWithFormat:@"Units: %@", b.insulinUnits];
    
    label = (UILabel*)[cell viewWithTag:2];
    label.text = ((InsulinType*)b.insulinType).name;
    
    label = (UILabel*)[cell viewWithTag:3];
    label.text = [NSString stringWithFormat:@"Carbs: %@", b.carbs];
    
    label = (UILabel*)[cell viewWithTag:4];
    label.text = [self.timeFormatter stringFromDate:b.date];
    
    
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Properties
- (NSDateFormatter*)timeFormatter
{
    if (!_timeFormatter) {
        _timeFormatter = [[NSDateFormatter alloc] init];
        _timeFormatter.timeStyle = NSDateFormatterShortStyle;
        _timeFormatter.dateStyle = NSDateFormatterNoStyle;
    }
    
    return _timeFormatter;
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
    //if ([[segue destinationViewController] isKindOfClass:[UINavigationController class]]) {
        //UINavigationController *navController = [segue destinationViewController];
        if ([[segue destinationViewController] isKindOfClass:[AddBolusTableViewController class]]) {
            AddBolusTableViewController *addController = [segue destinationViewController];
            addController.context = self.context;
            NSLog(@"Passed context from BolusTVC to AddBolusTVC");
        } 
//    } else {
//        NSLog(@"destination was not a UINavController, %@ instead", [segue destinationViewController]);
//    }
}


@end
