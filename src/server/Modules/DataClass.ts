/* eslint-disable prettier/prettier */
/*
    Created by: SiriusLatte

    Simple ClassData thing which handles ProfileService as I was too lazy to create my own
    wrapper for the DataStoreService as well.
*/

/* Imports */
import { RemoteSignal } from "@rbxts/knit";
import ProfileService from "@rbxts/profileservice";
import { Profile } from "@rbxts/profileservice/globals";
import { Players } from "@rbxts/services";

/* Constants */
const Template = {
    Cash: 0,
    PeopleAccepted: 0,
    PeopleDenied: 0,
    TimesLost: 0,
    CurrentDay: 0,
    CurrentTime: 0,
}
const ProfileStore = ProfileService.GetProfileStore({Name: "kP#Q%Q@LuGj*"}, Template)

/* Interfaces & types */
type Data = {
    Cash: number
    PeopleAccepted: number,
    PeopleDenied: number,
    TimesLost: number,
    CurrentDay: number
    CurrentTime: number
}

interface PlayerData {
    Data: Data;
    PlayerProfile: Profile<Data> | undefined;
    Player: Player;

    /* Methods */
    GetData(): {};
    WriteData(Stat: string, Value: unknown): void;
    Save(): void;
    IncrementData(Stat: string, Value: number): void;
}

/* Class */
class DataClass implements PlayerData {
    Data = Template;
    Player: Player;
    PlayerProfile: Profile<Data> | undefined;
    Signal: RemoteSignal | undefined;

    constructor(Client: Player, SignalToFire: RemoteSignal) {
        /* Initialises loading of data */
        const ProfileData = ProfileStore.LoadProfileAsync("PlayerUniqueGeneratedId_%d".format(Client.UserId))
        this.Player = Client;

        if (ProfileData !== undefined) {
            ProfileData.AddUserId(Client.UserId);
            ProfileData.Reconcile(); // Fill gaps in between if there's any between the saved data and the template

            /* Gives the data table so it can be easily accessed */
            this.Data = ProfileData.Data;
            this.PlayerProfile = ProfileData;
            this.Signal = SignalToFire;
        } else {
            Client.Kick("Your profile hasn't been released! This may be due to an error while trying to save your data... Join back again!");
        }
    }

    GetData() {
        return this.Data ?? {};
    }

    WriteData(Stat: string, NewData: unknown) {
        if (NewData === undefined) { return };

        const StatTo = Stat as keyof Data;
        let Data = this.Data[StatTo];
        const OldData = Data;

        if (Data !== undefined) {
            Data = NewData as typeof this.Data[typeof StatTo];
            this.Data[StatTo] = Data;

            /* Remote */
            this.Signal?.Fire(this.Player, OldData, Data);
        } else {
            warn("[DataManager]: Provide a valid stat to write over!");
            return;
        }
    }

    IncrementData(Stat: string, Value: number) { 
        if (Value === undefined) { return };
        if (Value < 0 || Value === 0) { return }; // There's no increment so it isn't necessary!

        const StatTo = Stat as keyof Data;
        let Data = this.Data[StatTo];
        if (Data === undefined) { 
            warn("[DataManager]: Provide a valid stat to increment!");
            return;
        };
        if (type(Data) !== "number") {
             warn("[DataManager]: You can only increment number values!");
             return;
        }

        const oldValue = Data;
        Data += Value; 

        this.Data[StatTo] = Data;

        /* Remote */
        this.Signal?.Fire(this.Player, oldValue, Data);
    }

    Save() {
        /* Saves current profile */
        this.PlayerProfile!.Release();

        /* Safe kicking */
        if (this.Player.IsDescendantOf(Players)) {
            this.Player.Kick("Manually kicked as your profile has been saved already!");
        }
    }
}

export = DataClass;