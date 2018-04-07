//
//  OpenCVWrapper.h
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OpenCVWrapper : NSObject

-(void) matrixMin: (double *) data
        data_size:(int)data_size
        data_rows:(int)data_rows
        heat_rows:(int)heat_rows;

-(void) maximum_filter: (double *) data
             data_size:(int)data_size
             data_rows:(int)data_rows
             mask_size:(int)mask_size
             threshold:(double)threshold;

-(UIImage*) renderKeyPoint:(CGRect) bounds
                  keypoint:(int*) keypoint
             keypoint_size:(int) keypoint_size
                       pos:(CGPoint*) pos;

@end

