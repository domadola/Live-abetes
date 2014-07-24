//
//  AddBolusTableViewController.m
//  Liveabetes
//
//  Created by Dom Lamendola on 7/23/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import "AddBolusTableViewController.h"
#import "SelectInsulinTypeTableViewController.h"
#import "InsulinType.h"
#import "Bolus.h"

@interface AddBolusTableViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) InsulinType *selectedType;
@property (weak, nonatomic) UITextField *carbsTextField;
@property (weak, nonatomic) UITextField *unitsTextField;

@end

@implementation AddBolusTableViewController

- (IBAction)unwindToAddBolusTable:(UIStoryboardSegue *)segue
{
    if ([[segue sourceViewController] isKindOfClass:[SelectInsulinTypeTableViewController class]]) {
        SelectInsulinTypeTableViewController *cont = [segue sourceViewController];
        self.selectedType = cont.selectedInsulinType;
        [self.tableView reloadData];
    }
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
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"insulinTypeCell" forIndexPath:indexPath];
        UILabel *label = (UILabel*)[cell viewWithTag:1];
        label.text = self.selectedType.name;
        
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"unitsCell" forIndexPath:indexPath];
        self.unitsTextField = (UITextField*)[cell viewWithTag:2];
        if (indexPath.row == 0) {
            UILabel *label = (UILabel*)[cell viewWithTag:1];
            label.text = @"Carbs";
            self.carbsTextField = (UITextField*)[cell viewWithTag:2];
        }
    }
    
    // Configure the cell...
    
    return cell;
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
        if ([[segue destinationViewController] isKindOfClass:[SelectInsulinTypeTableViewController class]]) {
            SelectInsulinTypeTableViewController *selectController = [segue destinationViewController];
            selectController.context = self.context;
        }
    
    if (sender == self.saveButton) {
        Bolus *createdBolus = [NSEntityDescription
                                insertNewObjectForEntityForName:@"Bolus"
                                inManagedObjectContext:self.context];
        createdBolus.insulinType = self.selectedType;
        createdBolus.carbs = [NSNumber numberWithFloat:[self.carbsTextField.text floatValue]];
        createdBolus.insulinUnits = [NSNumber numberWithFloat:[self.unitsTextField.text floatValue]];
        createdBolus.date = [NSDate date];
        
        self.createdBolus = createdBolus;
    }
}


@end
