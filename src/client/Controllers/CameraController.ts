/* eslint-disable prettier/prettier */
/*
    Created by: SiriusLatte

    Camera controller for locking it in a single position.
*/
    
/* Imports */
import { KnitClient as Knit } from "@rbxts/knit";
import { Workspace } from "@rbxts/services";

/* Constants */
const Camera = Workspace.CurrentCamera

/* KnitController */
declare global {
    interface KnitControllers {
        CameraController: typeof CameraController;
    }
}

const CameraController = Knit.CreateController(
    {
        Name: "CameraController",

        KnitStart() {
            /* 
                Move the camera to the current position
            */

            Knit.GetService("PlayerService").SetupCamera.Connect(() => {
                print("Moving camera!")

                task.wait(2) // Necessary for some reason!
                
                /* Camera CFraming */
                Camera!.CameraType = Enum.CameraType.Scriptable;

                const CameraPosition = Workspace.WaitForChild('playercam') as BasePart;
                Camera!.CFrame = CameraPosition.CFrame;
            })
        }
    }
)

export {};
