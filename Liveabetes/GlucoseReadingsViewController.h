//
//  GlucoseReadingsViewController.h
//  Liveabetes
//
//  Created by Dom Lamendola on 7/9/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GlucoseReadingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@end
