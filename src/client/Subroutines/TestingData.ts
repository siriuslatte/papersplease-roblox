/* eslint-disable prettier/prettier */

/* Imports */
import { KnitClient as Knit } from "@rbxts/knit";

export = {
    /* Properties */
    

    /* Init method */
    Init() {
        Knit.GetService("PlayerService").DataChanged.Connect((Old: unknown, New: unknown) => {
            print("Before data changed, the value was: %d and now it is: %d".format(Old as number, New as number))
        })
    }
};