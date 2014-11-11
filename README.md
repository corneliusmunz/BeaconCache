BeaconCache
===========

Demo iOS project for indoor cache location (geocaching indoor)

To run the code you have to adapt the iBeacon parameters (uuid, major-id, minor-id) that it fits to your iBeacon. The adaption has to be done in the BeaconCacheViewController.m file where the BeaconRegion is specified:

    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"<yourUUID>"];
    self.cacheRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                           major:<Major-ID>
                                                           minor:<Minor-ID>
                                                      identifier:@"myBeacon"];
