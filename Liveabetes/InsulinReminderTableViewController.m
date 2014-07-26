//
//  InsulinReminderTableViewController.m
//  Liveabetes
//
//  Created by Dom Lamendola on 7/22/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import "InsulinReminderTableViewController.h"
#import "Reminder.h"
#import "EditReminderViewController.h"

@interface InsulinReminderTableViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (strong, nonatomic) NSMutableArray *reminders; // Reminder
@property (strong, nonatomic) NSDateFormatter *timeFormatter;

@end

@implementation InsulinReminderTableViewController

- (IBAction)unwindToReminderTable:(UIStoryboardSegue *)segue
{
    [self loadData];
    [self.tableView reloadData];
}

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self loadData];
}

- (void)loadData
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reminder"];
    
    NSError *error;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    
    self.reminders = [NSMutableArray arrayWithArray:results];
    NSLog(@"Loaded %d reminders from database", [self.reminders count]);
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
    return [self.reminders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reminderCell" forIndexPath:indexPath];
    
    Reminder *reminder = [self.reminders objectAtIndex:indexPath.row];
    
    UILabel *label;
    label = (UILabel*)[cell viewWithTag:1];
    label.text = [self.timeFormatter stringFromDate:reminder.time];
    
    label = (UILabel*)[cell viewWithTag:2];
    label.text = reminder.notes;
    
    label = (UILabel*)[cell viewWithTag:3];
    if (![reminder.repeatDaily boolValue]) {
        NSLog(@"not daily");
        label.text = @"";
    } else {
        NSLog(@"repeat daily");
        label.text = @"Daily";
    }
    
    return cell;
}

#pragma mark - Properties

- (NSDateFormatter*)timeFormatter
{
    if (!_timeFormatter) {
        _timeFormatter = [[NSDateFormatter alloc]init];
        _timeFormatter.dateStyle = NSDateFormatterNoStyle;
        _timeFormatter.timeStyle = NSDateFormatterShortStyle;
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
    
    if ([[segue destinationViewController] isKindOfClass:[EditReminderViewController class]]) {
        EditReminderViewController *editController = [segue destinationViewController];
        editController.context = self.context;
        if (sender == self.addButton) {
            editController.isEditing = NO;
        } else {
            editController.isEditing = YES;
            editController.reminder = [self.reminders objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        }
    }
}


@end
