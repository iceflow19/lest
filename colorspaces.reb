REBOL[
	Title:		"Colorspaces"
	File:		%colorspaces.reb
	Author:		"Boleslav Březovský"
	Date:		3-4-2014
	Version:	0.0.1
	Type:		'module
	Name:		'colorspaces
	Exports:	[
		load-web-color load-hsl load-hsv
		to-hsl to-hsv
		new-color set-color apply-color
	]
]

load-web-color: func [
	"Convert hex RGB issue! value to tuple!"
	color	[issue!] ; add string also? is it needed?
	/local pos
] [
	to tuple! debase/base next form color 16
]

to-hsl: func [
	color [tuple!]
	/local min max delta alpha total
][
	if color/4 [alpha: color/4 / 255]
	color: reduce [color/1 color/2 color/3]
	bind/new [r g b] local: object []
	set words-of local map-each c color [c / 255]
	color: local
	min: first minimum-of values-of color
	max: first maximum-of values-of color
    delta: max - min
    total: max + min
    local: object [h: s: l: to percent! total / 2]
    do in local bind [
		either zero? delta [h: s: 0] [
			s: to percent! either l > .5 [2 - max - min] [delta / total]
			h: 60 * switch max reduce [
				r [g - b / delta + either g < b 6 0]
				g [b - r / delta + 2]
				b [r - g / delta + 4]
			]
		]
    ] color
    local: values-of local
    if alpha [append local alpha]
    local
]

to-hsv: func [
	color [tuple!]
	/local min max delta alpha
][
	if color/4 [alpha: color/4 / 255]
	color: reduce [color/1 color/2 color/3]
	bind/new [r g b] local: object []
	set words-of local map-each c color [c / 255]
	color: local
	min: first minimum-of values-of color
	max: first maximum-of values-of color
    delta: max - min
    local: object [h: s: v: to percent! max]
        do in local bind [
		either zero? delta [h: s: 0] [
			s: to percent! either delta = 0 [0] [delta / max]
			h: 60 * switch max reduce [
				r [g - b / delta + either g < b 6 0]
				g [b - r / delta + 2]
				b [r - g / delta + 4]
			]
		]
    ] color
    local: values-of local
    if alpha [append local alpha]
    local
]


load-hsl: func [
	color [block!]
	/local alpha c x m i
][
	if color/4 [alpha: color/4]
	; LOCAL: HSL, COLOR: RGB
	bind/new [h s l] local: object []
	set words-of local color
	bind/new [r g b] color: object []
	do in local [
		i: h / 60
		c: 1 - (abs 2 * l - 1) * s
		x: 1 - (abs -1 + mod i 2) * c
		m: l - (c / 2)
	]
	do in color [
		set [r g b] reduce switch to integer! i [
			0 [[c x 0]]
			1 [[x c 0]]
			2 [[0 c x]]
			3 [[0 x c]]
			4 [[x 0 c]]
			5 [[c 0 x]]
		]
	]
	color: to tuple! map-each value values-of color [to integer! round m + value * 255]
	if alpha [color/4: alpha * 255]
	color
]

load-hsv: func [
	color [block!]
	/local alpha c x m i
][
	if color/4 [alpha: color/4]
	; LOCAL: HSV, COLOR: RGB
	bind/new [h s v] local: object []
	set words-of local color
	bind/new [r g b] color: object []
	do in local [
		i: h / 60
		c: v * s
		x: 1 - (abs -1 + mod i 2) * c
		m: v - c
	]
	do in color [
		set [r g b] reduce switch to integer! i [
			0 [[c x 0]]
			1 [[x c 0]]
			2 [[0 c x]]
			3 [[0 x c]]
			4 [[x 0 c]]
			5 [[c 0 x]]
		]
	]
	color: to tuple! map-each value values-of color [to integer! round m + value * 255]
	if alpha [color/4: alpha * 255]
	color
]

color!: object [
	rgb: 0.0.0.0
	web: #000000
	hsl: make block! 4
	hsv: make block! 4
]

new-color: does [make color! []]

set-color: func [
	color	[object!] "Color object"
	value	[block! tuple! issue!]
	type	[word!]
] [
	switch type [
		rgb [
			do in color [
				rgb: value
				web: to-hex value
				hsl: to-hsl value
				hsv: to-hsv value
			]
		]
		web [
			do in color [
				rgb: load-web-color value
				web: value
				hsl: to-hsl rgb
				hsv: to-hsv rgb
			]
		]
		hsl [
			do in color [
				rgb: load-hsl value
				web: to-hex rgb
				hsl: value
				hsv: to-hsv load-hsv value
			]
		]
		hsv [
			do in color [
				rgb: load-hsv value
				web: to-hex rgb
				hsl: to-hsl load-hsv value
				hsv: value
			]
		]
	]
	color
]

;apply-color color 'saturate 50%

apply-color: func [
	"Apply color effect on color"
	color	[object!]	"Color! object"
	effect	[word!]		"Effect to apply"
	amount	[number!]	"Effect amount"
] [
	effect: do bind select effects effect 'amount
	set-color color color/:effect effect
]

effects: [
	; return changed colorspace
	darken [
		color/hsl/3: max 0% color/hsl/3 - amount
		'hsl
	]
	lighten [
		color/hsl/3: min 100% color/hsl/3 + amount
		'hsl
	]
	saturate [
		color/hsl/2: min 100% max 0% color/hsl/2 + amount
		;color/hsv/2: color/hsv/2 + (100% - color/hsv/2 * amount)
		'hsl
	]
	desaturate [
		color/hsl/2: min 100% max 0% color/hsl/2 - amount
		'hsl
	]
	hue [
		color/hsl/1: color/hsl/1 + amount // 360
		'hsl
	]
]
