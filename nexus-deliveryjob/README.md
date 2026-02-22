
░██████╗░█████╗░██████╗░██╗██████╗░████████╗  ██████╗░██╗░░░██╗██╗
██╔════╝██╔══██╗██╔══██╗██║██╔══██╗╚══██╔══╝  ██╔══██╗╚██╗░██╔╝╚═╝
╚█████╗░██║░░╚═╝██████╔╝██║██████╔╝░░░██║░░░  ██████╦╝░╚████╔╝░░░░
░╚═══██╗██║░░██╗██╔══██╗██║██╔═══╝░░░░██║░░░  ██╔══██╗░░╚██╔╝░░░░░
██████╔╝╚█████╔╝██║░░██║██║██║░░░░░░░░██║░░░  ██████╦╝░░░██║░░░██╗
╚═════╝░░╚════╝░╚═╝░░╚═╝╚═╝╚═╝░░░░░░░░╚═╝░░░  ╚═════╝░░░░╚═╝░░░╚═╝

██████╗░░█████╗░██╗░░██╗░█████╗░████████╗░█████╗░
██╔══██╗██╔══██╗██║░██╔╝██╔══██╗╚══██╔══╝██╔══██╗
██║░░██║███████║█████═╝░██║░░██║░░░██║░░░███████║
██║░░██║██╔══██║██╔═██╗░██║░░██║░░░██║░░░██╔══██║
██████╔╝██║░░██║██║░╚██╗╚█████╔╝░░░██║░░░██║░░██║
╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝░╚════╝░░░░╚═╝░░░╚═╝░░╚═╝




# nexus-Delivery

Nexus-Delivery is a free delivery script designed to copy the style found in GTA Online. weve did our best to achive that ! 

Images at the bottom.

Support, please join
[DISCORD](https://discord.gg/Vm5MqyEYRT)

## Features

- Delivery job mechanics inspired by GTA Online.
- Configurable payout ranges for completed deliveries.
- Compatibility with both qb-core, ESX, ND-Core and Qbox-Core frameworks.
- Debugging options.

## Installation

1. Clone or download the nexus-Delivery repository.
2. Place the script files in the appropriate server resource directory.
3. Update the `config.lua` file to configure payout ranges and framework preferences.
4. Ensure nexus-Delivery resource in your server.cfg file.
5. If using `ESX` or `ND-Core` go into `fxmanifest.lua` and uncomment line 17 or 18
6. Restart or start your FiveM server.

## Usage

- Players can go on duty to start their delivery job.
- Once on duty, they can complete deliveries, which when delivering packages they receive a payout.
- Payouts are randomized based on configured payout ranges and added to the player's bank account.

## Configuration

- Payout ranges and framework preferences can be configured in the `config.lua` file.
- Adjust the payout ranges to balance the economy of your server.
- Choose between the `qb`, `esx`, `nd` or `qbx` based on your server's setup.
- Can change where you start the Jobs and where the vehicles spawn.
- Can change where you deliver packages as well.

## Dependencies whichever you use its workable with all the listed below ! 

- [qb-core](https://github.com/qbcore-framework/qb-core)
- [ESX](https://github.com/esx-framework) 
- [ND-Core](https://github.com/ND-Framework/ND_Core)
- [Qbox-Core](https://github.com/Qbox-project/qbx_core)

## Credits

Nexus-Delivery is maintained by [Dakota](https://github.com/DakotaOhItxScripts).



🚚✨ NEW RELEASE: Nexus Delivery Job (QBCore | Qbox | ESX | ND)

Looking to add something fresh, interactive, and profitable to your server economy?
Introducing the Nexus Delivery Job – a next-generation job system built for QBCore, Qbox, ESX, and ND frameworks.

💡 Whether you’re running a roleplay-heavy city or a casual grind-based community, this delivery system is designed to bring immersive routes, multiple job tiers, realistic payouts, and endless customization to keep players hooked.

🔥 Features:

✅ Supports QBCore, Qbox, ESX, ND out of the box

✅ Multiple delivery vehicle options (configurable)

✅ Smart job progression (starter -> advanced routes)

✅ Clean UI prompts for smooth interaction

✅ Optimized performance (low ms usage)

✅ Easy to configure & expand with your own ideas

Players can finally experience what it feels like to work their way up the delivery ladder – starting small with bikes or vans, then moving into bigger trucks, longer routes, and higher payouts.

This isn’t just a job… it’s a server economy booster 💰

⚙️ Installation Guide
1️⃣ Download & Extract

Grab the latest version of Nexus Delivery Job

Place the folder inside your resources/

2️⃣ Ensure the Script

Add the following line to your server.cfg:

ensure nexus-delivery-job

3️⃣ Configure Framework

Open config.lua and set your framework:

Config.Framework = "QBCORE" -- Options: QBCORE, QBOX, ESX, ND

4️⃣ Setup Routes & Payouts

Edit config.lua to customize delivery routes

Adjust payment rates, job ranks, and vehicle options

5️⃣ Restart Your Server

Type /restart nexus-delivery-job in console or restart your server to apply changes.

🚀 Ready to Deliver?

Fire up your city and let your players grind, roleplay, and hustle their way through the all-new Nexus Delivery Job.
This isn’t just a script… it’s the start of your server’s next big economy shift.
