//
//  GDataXMLNode+NLAdditions.h
//  MyApp
//
//  Created by Nguyen Nang on 6/3/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "GDataXMLNode.h"

@interface GDataXMLNode (NLAdditions)
- (GDataXMLNode *)parent;
- (GDataXMLNode *)nextSibling;
- (GDataXMLNode *)previousSibling;
@end

@interface GDataXMLElement (NLAdditions)
- (GDataXMLElement *)removeNodesWithXPaths:(NSArray *)xpaths;

- (GDataXMLElement *)removeNodesWithXPaths:(NSArray *)xpaths isRemoveParentNode:(BOOL)isRemoveParentNode;
@end

@interface GDataXMLDocument (NLAdditions)

- (id)initWithHTMLString:(NSString *)str options:(unsigned int)mask error:(NSError **)error;
- (id)initWithHTMLData:(NSData *)data options:(unsigned int)mask error:(NSError **)error;

@end
