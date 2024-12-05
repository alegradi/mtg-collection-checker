# Magic The Gathering - Card Collection Checker

This does not take card count into consideration. Best used in a singleton format like commander or cube building.

## How to use

1, Export your Archidect collection with only selecting the "Card Name" option
It will look something like this:
```sh
Name
Abomination of Llanowar
Acquisition Octopus
Acrobatic Maneuver
Act of Heroism
"Adeliz, the Cinder Wind"
...
```

2, Save it into the inventory directory
(sample included)

3, Get a list of cards you want to check your inventory against, for example from 

cubecobra (WIP):
- go to list
- select export
- save only cardnames into the check-cards folder

edhrec:
- select commander
- select low budget (optional)
- average deck
- export > plaintext
- save into a file in check-cards (example included)

4, Run the check
```sh
./checker-v0.1.sh -i inventory/sample-inventory.csv -c check-cards/teysa-karlov-budget.txt
```

## Disclaimer

This project is not affiliated with, endorsed, sponsored, or specifically approved by Wizards of the Coast LLC. Wizards of the Coast LLC retains all rights to Magic: The Gathering and its associated trademarks.  

By using this software, you waive all rights, and the creator is not liable for any damage caused by its use.
