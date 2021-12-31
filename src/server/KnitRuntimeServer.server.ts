/*
    Created by: SiriusLatte 

    The main executation of Knit framework, simple and reliable.
*/

/* Imports */
import { KnitServer as Knit } from "@rbxts/knit";

/* Constants */
const ServicesFolder = script.Parent?.FindFirstChild("Services") as Folder;
const Start = os.clock();

/* Initializer */
Knit.AddServices(ServicesFolder);
Knit.Start().andThen(() => {
	const currentTime = os.clock();

	print(string.format("Took %0.3fms to start-up server! 🖥️", 1000 * (currentTime - Start)));
});
