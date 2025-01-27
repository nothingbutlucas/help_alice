# Check the mainteined version [here on Codeberg](https://codeberg.org/nothingbutlucas/help_alice)
---
# help_alice
Bash script to help Alice on Alice's Nightmare in Wonderland

This script is intended to be used in conjunction with the bookgame: [Alice's Nightmare in Wonderland](https://www.kickstarter.com/projects/jonathangreen/alices-nightmare-in-wonderland)



## Installation

Open a terminal and follow the instructions below

It's a bash script so you can only download the script:

```bash
curl -LJO https://raw.githubusercontent.com/nothingbutlucas/help_alice/main/help_alice.sh
```

Then give it permissions

```bash
chmod 744 help_alice.sh
```

Ready to use! (See the usage section below)

## Usage

```bash
./help_alice.sh
```

By default it will try to run `whiptail`. If it is not available, you can install it or use it on CLI.

If you want to see all the available options:

```bash
./help_alice.sh -h
```

```bash
❯ ./help_alice.sh -h
help_alice.sh
Usage: help_alice.sh [options]
Options:
	-t <text>   Text to convert
	-c          Use CLI mode
	-f          Fast mode, no progress bar
	-h          Show this help panel
```


Whiptail's examples:

![Preview of the script using whiptail ](/screenshot_prompt.png)

The output will be:

![Preview of the script using whiptail ](/screenshot_result.png)

Hope you like it.

Goodluck!
