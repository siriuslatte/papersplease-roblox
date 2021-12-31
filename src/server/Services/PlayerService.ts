/* eslint-disable prettier/prettier */
/* 
    Created by: SiriusLatte

    DataManager module which just handles simple cash that can be earned as a demonstration
    of a small service, the other services are a little bit more complex.
*/

/* Imports */
import { KnitServer as Knit, RemoteSignal } from "@rbxts/knit";
import { Players } from "@rbxts/services";
import DataClass from "server/Modules/DataClass";

/* KnitService */
declare global {
    interface KnitServices {
        PlayerService: typeof PlayerService;
    }
}

const PlayerService = Knit.CreateService(
    {
        Name: "PlayerService",

        /* Server properties */
        PlayersData: new Map<Player, DataClass>(),

        /* Client */
        Client: {
            DataChanged: new RemoteSignal<(OldValue: unknown, NewValue: unknown) => void>(),
            SetupCamera: new RemoteSignal<() => void>(),

            /* Client methods */
        },

        KnitStart() {
            /* 
                KnitStart() method gets invoked after the Init method, even though
                we don't need the Init method as maybe we would want to invoke different services within Knit
                that's why we set up every connection for the player's here, so there's no
                errors at all! Learn more about the Life cycle Knit here: https://sleitnick.github.io/Knit/docs/executionmodel
            */

            /* Players connection */
            Players.PlayerAdded.Connect(Client => {
                /*
                    Every single operation that needs to be done within the client/player 
                    that joint the server, SHOULD be done here for facility, i do avoid the multiple
                    connections for a single event that way i just set up different modules/services for
                    it!
                */

                /* Player data loading */
                const PlayerData = new DataClass(Client, this.Client.DataChanged);
                this.PlayersData.set(Client, PlayerData);

                coroutine.wrap(() => {
                    while (true) {
                        task.wait(1);
                        PlayerData.IncrementData("Cash", 10);
                    }
                })();

                this.Client.SetupCamera.Fire(Client);
            })

            Players.PlayerRemoving.Connect(Client => {

            });
        }
    }
)

export = PlayerService;