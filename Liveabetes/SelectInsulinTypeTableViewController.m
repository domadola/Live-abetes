//
//  SelectInsulinTypeTableViewController.m
//  Liveabetes
//
//  Created by Dom Lamendola on 7/23/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import "SelectInsulinTypeTableViewController.h"
#import "AddInsulinTypeViewController.h"

@interface SelectInsulinTypeTableViewController ()

@property (strong, nonatomic) NSMutableArray *insulinTypes; // InsulinType
@property NSInteger selectedRowIndex;

@end

@implementation SelectInsulinTypeTableViewController

- (IBAction)unwindToSelectInsulinTypeTable:(UIStoryboardSegue *)segue
{
//    if ([[segue sourceViewController] isKindOfClass:[UINavigationController class]]) {
//        UINavigationController *navController = [segue sourceViewController];
        if ([[segue sourceViewController] isKindOfClass:[AddInsulinTypeViewController class]]) {
            AddInsulinTypeViewController *addVC = [segue sourceViewController];
            if (addVC.addedInsulinType != nil) {
                [self.insulinTypes addObject:addVC.addedInsulinType];
                [self loadData];
                [self.tableView reloadData];
            }
        }
//    }
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
    
    [self loadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)loadData
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"InsulinType"];
    
    NSError *error;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    
    self.insulinTypes = [NSMutableArray arrayWithArray:results];
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
    return [self.insulinTypes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"insulinTypeCheckmarkCell" forIndexPath:indexPath];
    
    InsulinType *t = [self.insulinTypes objectAtIndex:indexPath.row];
    cell.textLabel.text = t.name;
    
    if (self.selectedRowIndex == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRowIndex = indexPath.row;
    [self.tableView reloadData];
    self.selectedInsulinType = [self.insulinTypes objectAtIndex:indexPath.row];
    
    // rewind here somehow
    [self performSegueWithIdentifier:@"unwindToAddBolus" sender:self];

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
//    if ([[segue destinationViewController] isKindOfClass:[UINavigationController class]]) {
//        UINavigationController *navController = [segue destinationViewController];
        if ([[segue destinationViewController] isKindOfClass:[AddInsulinTypeViewController class]]) {
            AddInsulinTypeViewController *addVC = [segue destinationViewController];
            addVC.context = self.context;
            NSLog(@"Passed context from SelectInsulinTypeVC to AddInsulinTypeVC");
        }
//    }
}

@end
