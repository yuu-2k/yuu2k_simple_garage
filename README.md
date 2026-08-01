# yuu2k_simple_garage

A lightweight, modern and configurable garage system for FiveM.

![Lua](https://img.shields.io/badge/Lua-5.4-blue)
![ESX](https://img.shields.io/badge/Framework-ESX-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

## Features

* Store and retrieve owned vehicles
* Multiple garage support
* ESX compatible
* ox_lib integration
* oxmysql support
* Multi-language support
* Clean and lightweight codebase
* Easy configuration

## Dependencies

* es_extended
* ox_lib
* oxmysql

## Installation

1. Download or clone this repository.
2. Place the resource inside your `resources` folder.
3. Ensure the dependencies are installed.
4. Add the resource to your `server.cfg`:

```cfg
ensure ox_lib
ensure oxmysql
ensure es_extended
ensure yuu2k_simple_garage
```

## Configuration

All configurable options can be found in:

```
shared/config.lua
```

Garage locations, markers, blips and other settings can be modified there.

## Languages

This resource uses **ox_lib** localization.

To change the server language, add the following convar to your `server.cfg` and replace `en` with your preferred language code:

```cfg
setr ox:locale en
```

### Included languages

* 🇬🇧 English (`en`)
* 🇫🇷 French (`fr`)
* 🇪🇸 Spanish (`es`)
* 🇩🇪 German (`de`)
* 🇮🇹 Italian (`it`)
* 🇵🇹 Portuguese (`pt`)

You can also create your own translation by adding a new JSON file inside the `locales` folder and setting `ox:locale` to the corresponding language code.


## Support

This resource is provided for free.

Bug reports and improvement suggestions are welcome.

## Contributions

Feel free to fork the project and submit pull requests.

## Credits

Developed by **Yuu2k**

If you use this resource, a credit is always appreciated.

## License

Released under the MIT License.

See the [LICENSE](LICENSE) file for details.