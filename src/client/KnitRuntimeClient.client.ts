/* eslint-disable prettier/prettier */
/*
    Created by: SiriusLatte 

    The main executation of Knit framework, simple and reliable.
*/

/* Imports */
import { KnitClient as Knit } from "@rbxts/knit";

/* Types */
type Module = {
    Init(): void;
}

/* Constants */
const ControllersFolder = script.Parent?.FindFirstChild("Controllers") as Folder;
const SubroutinesFolder = script.Parent?.FindFirstChild("Subroutines") as Folder;
const Start = os.clock();

/* Initializer */
Knit.AddControllers(ControllersFolder);
Knit.Start().andThen(() => {
	const currentTime = os.clock();

	print(string.format("Took %0.3fms to start-up client! 💻", 1000 * (currentTime - Start)));
});

/* Loader of subroutines for facility */
Knit.OnStart().andThen(
    () => {
        // eslint-disable-next-line roblox-ts/no-array-pairs
        for (const [_, module] of ipairs(SubroutinesFolder.GetChildren())) {
            if (module.IsA("ModuleScript")) {
                const Required = require(module) as Module;
                
                coroutine.wrap(
                    () => {
                        Required.Init();
                    }
                )();
            }
        }
    }
)