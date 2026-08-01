lib.locale()

Config.Stored = {
    Impound = 0,
    Garage = 1,
    Out = 2
}

Config.Blip = {
    garage = {
        sprite = 357,
        colour = 3,
        scale = 0.8,
        shortRange = true,
        name = 'Garage'
    },
    impound = {
        sprite = 68,
        colour = 1,
        scale = 0.8,
        shortRange = true,
        name = 'Impound'
    }
}

Config.Marker = {
    garage = {
        type = 1,
        scale = vec3(2.0, 2.0, 1.0),
        color = { r = 46, g = 204, b = 113, a = 180 },
        bobUpAndDown = false,
        faceCamera = true,
        rotate = false
    },
    store = {
        type = 27,
        scale = vec3(2.0, 2.0, 1.0),
        color = { r = 231, g = 76, b = 60, a = 180 },
        bobUpAndDown = false,
        faceCamera = true,
        rotate = true
    },
    impound = {
        type = 1,
        scale = vec3(2.0, 2.0, 1.0),
        color = { r = 255, g = 165, b = 0, a = 180 },
        bobUpAndDown = false,
        faceCamera = true,
        rotate = false
    }
}

Config.Zone = {
    ['Legion Square'] = {
        blip = 'garage', -- nil to turn off
        types = {automobile = true, bike = true},
        spawn = vec4(240.8169, -782.3262, 30.6054, 66.5994),
        points = {
            {
                action = 'retrieve',
				marker = 'garage',
                coords = vec3(238.4234, -775.6082, 30.6957)
            },
            {
                action = 'store',
				marker = 'store',
                coords = vec3(222.6082, -769.7791, 30.8008)
            }
        }
    },
    ['Impound'] = {
        blip = 'impound', -- nil to turn off
        types = {automobile = true, bike = true},
        spawn = vec4(411.2761, -1636.9634, 28.8797, 230.7380),
		impound = {
			price = 750,
			account = 'bank',
			society = 'society_police'
		},
        points = {
            {
                action = 'impound',
				marker = 'impound',
                coords = vec3(408.9862, -1622.7090, 29.2919)
            }
        }
    }
}
